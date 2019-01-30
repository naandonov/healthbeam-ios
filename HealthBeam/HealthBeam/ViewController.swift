//
//  ViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 26.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {//, PagedElementsControllerDelegate, PagedElementsControllerSearchDelegate {
    
    @IBOutlet weak var containerView: UIView!

    var modificaitonElementController: ModificationElementController<Element>?
    
    struct Element: Codable {
        var name: String?
        var title: String?
    }
    
    var element = Element(name: "Niki", title: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = ModificationDatasource(element: element, inputDescriptors: [.standardOptional(title: "Full Name", keyPath: \Element.name, isRequired: true), .standardOptional(title: "Title", keyPath: \Element.title, isRequired: true)])
        modificaitonElementController = ModificationElementController(containerView: containerView, dataSource: dataSource, owner: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            print(self.element)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(modificaitonElementController?.requestModifiedElement())
    }
}

