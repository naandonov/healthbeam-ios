//
//  MenuInteractor.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 14.01.19.
//  Copyright (c) 2019 nikolay.andonov. All rights reserved.
//

import UIKit

protocol MenuBusinessLogic {
    var presenter: MenuPresentationLogic? { get set }
    
    func performAuthorizationCheck(request: Menu.AuthorizationCheck.Request)
    func updateUserProfile(request: Menu.UserProfileUpdate.Request)
    func performUserLogout(request: Menu.UserLogout.Request)
    func requestNotificationServices()
    func updateDeviceToken()
    func checkForPendingAlerts(request: Menu.CheckForPendingAlerts.Request)
    func retrievePatientAlert(request: Menu.RetrievePatientAlert.Request)
}

protocol MenuDataStore {
    var options: [Menu.Option] { get }
}

class MenuInteractor: MenuBusinessLogic, MenuDataStore {
    
    var presenter: MenuPresentationLogic?
    lazy var options: [Menu.Option] = {
        return generateOptions()
    }()
    
    var pendingAlertsExist = false {
        didSet {
            options = generateOptions()
            presenter?.updatePatientAlertsOption(response: Menu.UpdatePatientAlertsOption.Response())
        }
    }
    
    private func generateOptions() -> [Menu.Option] {
        var model:[Menu.Option] = []
        let patientsLocateOption = Menu.Option(type: .patientsLocate,
                                               iconName: "patientsLocatorIcon",
                                               name: "Nearby Patients".localized(),
                                               description: "Locate nearby patients assigned with a tag within your discovery regions".localized())
        model.append(patientsLocateOption)
        
        let patientsOption = Menu.Option(type: .patientsSearch,
                                         iconName: "patientsIcon",
                                         name: "All Patients".localized(),
                                         description: "Search among lists of all patients registered to your premise".localized())
        model.append(patientsOption)
        
        let patientAlertsOption = Menu.Option(type: .patientAlerts,
                                              iconName: pendingAlertsExist ? "badgeAlertIcon" : "alertIcon",
                                              name: "Patient Alerts".localized(),
                                              description: "Respond to patients in need of immediate medical attention".localized())
        model.append(patientAlertsOption)
        
        let aboutOption = Menu.Option(type: .about,
                                      iconName: "neutralBlueLogo",
                                      name: "About".localized(),
                                      description: "Explore information and resources about operating with HealthBeam".localized())
        model.append(aboutOption)
        
        let logoutOption = Menu.Option(type: .logout,
                                       iconName: "logoutIcon",
                                       name: "Log Out".localized(),
                                       description: "Sign out of your HealthBeam account".localized())
        model.append(logoutOption)
        return model
    }
    
    private lazy var authorizationWorker: AuthorizationWorker = {
        guard var authorizationWorker = Injector.authorizationWorker else {
            fatalError("Missing AuthorizationWorker implementaion")
        }
        authorizationWorker.delegate = self
        return authorizationWorker
    } ()
    
    private let notificationCenter: NotificationCenter
    private let notificationManager: NotificationManger
    private let networkingManager: NetworkingManager
    private let coreDataHandler: CoreDataHandler
    
    
    init(notificationManager: NotificationManger,
         networkingManager: NetworkingManager,
         coreDataHandler: CoreDataHandler,
         notificationCenter: NotificationCenter) {
        self.notificationManager = notificationManager
        self.networkingManager = networkingManager
        self.coreDataHandler = coreDataHandler
        self.notificationCenter = notificationCenter
        registerForApplicationEvents()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    private func registerForApplicationEvents() {
        notificationCenter.addObserver(self,
                                       selector: #selector(applicationDidBecomeActive),
                                       name: UIApplication.didBecomeActiveNotification,
                                       object: nil)
    }
    
    func performAuthorizationCheck(request: Menu.AuthorizationCheck.Request) {
        let authorizationGranted = authorizationWorker.checkForAuthorization()
        presenter?.handleAuthorization(response: Menu.AuthorizationCheck.Response(authorizationGranted: authorizationGranted))
    }
    
    func requestNotificationServices() {
        notificationManager.delegate = self
        notificationManager.requestNotifiationServices()
    }
    
    func updateDeviceToken() {
        notificationManager.requestDeviceToken { [weak self] token in
            guard let strongSelf = self else {
                return
            }
            let operation = AssignDeviceTokenOperation(deviceToken: token, completion: { result in
                switch result {
                case let .success(responseObject):
                    log.debug(responseObject)
                case let .failure(responseObject):
                    log.error(responseObject.description)
                }
            })
            strongSelf.networkingManager.addNetwork(operation: operation)
        }
    }
    
    func updateUserProfile(request: Menu.UserProfileUpdate.Request) {
        
        let getUserProfileOperation = GetUserProfileOperation { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case let .success(responseObject):
                guard let value = responseObject.value else {
                    strongSelf.coreDataHandler.getUserProfile { [weak self] user in
                        self?.presenter?.handleUserProfileUpdate(response: Menu.UserProfileUpdate.Response(user: user))
                    }
                    return
                }
                strongSelf.storeUserProfile(value)
            case let .failure(responseObject):
                log.error(responseObject.description)
                strongSelf.coreDataHandler.getUserProfile { [weak self] user in
                    self?.presenter?.handleUserProfileUpdate(response: Menu.UserProfileUpdate.Response(user: user))
                }
            }
        }
        networkingManager.addNetwork(operation: getUserProfileOperation)
    }
    
    func performUserLogout(request: Menu.UserLogout.Request) {
        
        let operation = LogoutOperation { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(_):
                do {
                    strongSelf.presenter?.handleUserLogout(response: Menu.UserLogout.Response(isLogoutSuccessful: true))
                    try strongSelf.authorizationWorker.revokeAuthorization()
                    
                } catch {
                    strongSelf.presenter?.handleUserLogout(response: Menu.UserLogout.Response(isLogoutSuccessful: false))
                    log.error("Unable to revoke current authorization, reason: \(error.localizedDescription)")
                }
            case let .failure(responseObject):
                log.error("Unable to revoke current authorization, reason: \(responseObject.localizedDescription)")
                strongSelf.presenter?.handleUserLogout(response: Menu.UserLogout.Response(isLogoutSuccessful: false))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    
    func checkForPendingAlerts(request: Menu.CheckForPendingAlerts.Request) {
        
        let operation = GetPendingAlertsCountOperation() { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case let .success(responseObject):
                if let value = responseObject.value  {
                    strongSelf.pendingAlertsExist = value.count > 0
                    strongSelf.notificationManager.setBadgeCount(value.count)
                    strongSelf.presenter?.handlePendingAlertsCheck(response:
                        Menu.CheckForPendingAlerts.Response(pendingAlertsExist: strongSelf.pendingAlertsExist))
                } else {
               
                }
            case let .failure(responseObject):
                log.error(responseObject.description)
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
    
    func retrievePatientAlert(request: Menu.RetrievePatientAlert.Request) {
        let operation = GetAlertOperation(alertId: request.alertId) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case let .success(responseObject):
                if let value = responseObject.value  {
                    strongSelf.presenter?.handlePatientAlertRetrievalResult(response: Menu.RetrievePatientAlert.Response(isSuccessful: true, patientAlert: value, error: nil))
                } else {
                    strongSelf.presenter?.handlePatientAlertRetrievalResult(response: Menu.RetrievePatientAlert.Response(isSuccessful: false, patientAlert: nil, error: nil))
                }
            case let .failure(responseObject):
                log.error(responseObject.description)
                  strongSelf.presenter?.handlePatientAlertRetrievalResult(response: Menu.RetrievePatientAlert.Response(isSuccessful: false, patientAlert: nil, error: responseObject))
            }
        }
        networkingManager.addNetwork(operation: operation)
    }
}

//MARK: - NotificationMangerDelegate

extension MenuInteractor: NotificationMangerDelegate {
    func didReceivePendingAlertNotification(alertId: String) {
        retrievePatientAlert(request: Menu.RetrievePatientAlert.Request(alertId: alertId))
    }
    
    func didSetBadgeCount(_ badgecount: Int) {
        presenter?.handleReceivedPatientAlertNotification()
        pendingAlertsExist = badgecount != 0
    }
}


//MARK: - AutorizationEvents

extension MenuInteractor: AutorizationEvents {
    func authorizationHasExpired() {
        presenter?.handleAuthorizationRevocation()
    }
}

//MARK: - Utilities

extension MenuInteractor {
    
    private func storeUserProfile(_ userProfile: UserProfile.Model) {
        coreDataHandler.storeUserProfile(userProfile) { [weak self] success in
            guard let strongSelf = self else {
                return
            }
            strongSelf.presenter?.handleUserProfileUpdate(response: Menu.UserProfileUpdate.Response(user: userProfile))
            
        }
    }
    
}

//MARK: - Notification observers

extension MenuInteractor {

    @objc func applicationDidBecomeActive(_ sender: Any) {
        if authorizationWorker.checkForAuthorization() {
            checkForPendingAlerts(request: Menu.CheckForPendingAlerts.Request())
        }
    }
}
