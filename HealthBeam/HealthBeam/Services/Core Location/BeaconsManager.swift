//
//  BeaconsManager.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 12.10.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//

import Foundation
import CoreLocation

enum TrackingError: Error {
    case locationDisabled
    case locationEnabledInUseOnly
    case locationNotDetermined
}

extension BeaconsManager {
    enum Constants {
        enum Beacons {
            static let RegionUUID = "a5e343ee-0a98-11e5-a6c0-1697f925ec7a"
            static let RegionIdentifier = "SearchingRegion"
            
            static let BeaconRecordExpirationSeconds = 10.0
            static let BeaconsTrackingStartDelaySeconds = 10.0
        }
        enum Notifications {
            static let LocationAccessAllowsTracking = Notification.Name("LocationAccessAllowsTracking")
            static let LocationAccessForbidsTracking = Notification.Name("LocationAccessForbidsTracking")
            static let BeaconsFound = Notification.Name("BeaconsFound")
            
            static let UserInfoErrorKey = "error"
            static let UserInfoBeaconsKey = "beacons"
        }
    }
}

private struct BeaconRecord {
    init(beacon: Beacon) {
        self.beacon = beacon
        recordDate = Date()
    }
    let beacon: Beacon
    let recordDate: Date
}

final class BeaconsManager: NSObject {
    
    private var searchIsInProgress = false
    private let notificationCenter: NotificationCenter
    
    private var beaconRecords: [BeaconRecord] = []
    private var interactionRequestBeacons: [Beacon]?
    
    var lastBeaconsUpdate: Date?
    private var shouldDelayNextTrackingEvent = false
    
    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    private var interEventsDelay: TimeInterval {
        var delay = Constants.Beacons.BeaconRecordExpirationSeconds
        if shouldDelayNextTrackingEvent {
            delay += Constants.Beacons.BeaconsTrackingStartDelaySeconds
        }
        return delay
    }
    
    private var searchingRegion: CLBeaconRegion = {
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: Constants.Beacons.RegionUUID)!, identifier: Constants.Beacons.RegionIdentifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    func handleLocationServiceAuthorization() {
        if (CLLocationManager.locationServicesEnabled()) {
            switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                locationManager.requestAlwaysAuthorization()
                let errorUserInfo = [Constants.Notifications.UserInfoErrorKey : TrackingError.locationNotDetermined]
                notificationCenter.post(Notification(name: Constants.Notifications.LocationAccessForbidsTracking, object: self, userInfo: errorUserInfo))
            case .authorizedAlways:
                notificationCenter.post(Notification(name: Constants.Notifications.LocationAccessAllowsTracking, object: self, userInfo: nil))
            case .authorizedWhenInUse:
                let errorUserInfo = [Constants.Notifications.UserInfoErrorKey : TrackingError.locationEnabledInUseOnly]
                notificationCenter.post(Notification(name: Constants.Notifications.LocationAccessForbidsTracking, object: self, userInfo: errorUserInfo))
            default:
                let errorUserInfo = [Constants.Notifications.UserInfoErrorKey : TrackingError.locationEnabledInUseOnly]
                notificationCenter.post(Notification(name: Constants.Notifications.LocationAccessForbidsTracking, object: self, userInfo: errorUserInfo))
            }
        }
    }
    
    func startListentingForBeaconsInProximity() {
        locationManager.startMonitoring(for: searchingRegion)
    }
    
    func stopListeningForBeacons() {
        locationManager.stopMonitoring(for: searchingRegion)
        locationManager.stopRangingBeacons(in: searchingRegion)
    }
    
    func delayNextTrackingEvent() {
        shouldDelayNextTrackingEvent = true
    }
}

//MARK: - Utilities

extension BeaconsManager {
    
    private func unrecordedBeaconsAfterProcessing(_ beacons: [Beacon]) -> [Beacon] {
        var unrecordedBeacons: [Beacon] = []
        let checkedBeacons = checkedBeaconsAfterCleanup()
        for beacon in beacons {
            if !checkedBeacons.contains(beacon) {
                unrecordedBeacons.append(beacon)
                beaconRecords.append(BeaconRecord(beacon: beacon))
            }
        }
        return unrecordedBeacons
    }
    
    private func checkedBeaconsAfterCleanup() -> [Beacon] {
        beaconRecords = beaconRecords.filter {
            abs($0.recordDate.timeIntervalSinceNow) < Constants.Beacons.BeaconRecordExpirationSeconds
        }
        return beaconRecords.compactMap{ $0.beacon }
    }
}

//MARK:- CLLocationManagerDelegate

extension BeaconsManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleLocationServiceAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        locationManager.requestState(for: region)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == CLRegionState.inside {
            locationManager.startRangingBeacons(in: searchingRegion)
        }
        else {
            locationManager.stopRangingBeacons(in: searchingRegion)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    }
    
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            if let lastBeaconsUpdate = lastBeaconsUpdate, Date().timeIntervalSince(lastBeaconsUpdate) < interEventsDelay {
                return
            }
            shouldDelayNextTrackingEvent = false
            
            let parsedBeacons = beacons.compactMap {
                Beacon(minor: $0.minor.intValue, major: $0.major.intValue, rssi: $0.rssi)
            }
            print("\(parsedBeacons)")
            let beaconsUserInfo = [Constants.Notifications.UserInfoBeaconsKey: parsedBeacons]
            notificationCenter.post(Notification(name: Constants.Notifications.BeaconsFound, object: self, userInfo: beaconsUserInfo))
            self.lastBeaconsUpdate = Date()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error)
    }
    
    
    private func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: Error?) {
        if let error = error {
            print(error)
        }
    }
    
}
