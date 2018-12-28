//
//  HealthBeam
//
//  Created by Nikolay Andonov on 30.09.18.
//  Copyright © 2018 HealthBeam. All rights reserved.
//


import Foundation
import UIKit

protocol ReusableView: class {
    static var defaultReuseID: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseID: String {
        return nibName
    }
}

protocol CellProtocol: ReusableView {
}

extension UITableViewCell: CellProtocol {
}

extension UICollectionViewCell: CellProtocol {
}

protocol ScrollCollectionProtocol {
    associatedtype CellType
    func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> CellType
    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String)
}

extension UICollectionView: ScrollCollectionProtocol {
    typealias CellType = UICollectionViewCell
    func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> CellType {
        return dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        return register(nib, forCellWithReuseIdentifier: identifier)
    }
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        return register(cellClass, forCellWithReuseIdentifier: identifier)
    }
}

extension UITableView: ScrollCollectionProtocol {
    typealias CellType = UITableViewCell
}

extension ScrollCollectionProtocol {
    
    func registerClass<T: CellProtocol>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.defaultReuseID)
    }
    
    func registerNib<T: CellProtocol>(_: T.Type) where T: NibLoadableView {
        register(T.nib, forCellReuseIdentifier: T.defaultReuseID)
    }
    
    func dequeueReusableCell<T: CellProtocol>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseID, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseID)")
        }
        return cell
    }
}

