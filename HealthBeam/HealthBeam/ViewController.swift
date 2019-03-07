//
//  ViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 26.12.18.
//  Copyright © 2018 nikolay.andonov. All rights reserved.
//

import UIKit
import Cleanse

class ViewController: UIViewController, UITableViewDelegate {//, PagedElementsControllerDelegate, PagedElementsControllerSearchDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var viewz: ScanningView?
    var modificaitonElementController: ModificationElementController<Element>?
    
    var alertNavigationProvider: Provider<AlertRespondNavigationViewController>?
    
    struct Element: Codable {
        var name: String?
        var title: String?
        var date: Date?
        var date1: Date?
        var value: String?
        var value2: String?
        var value3: [String]?
        var text: String?



    }
    
    var element = Element(name: "Niki", title: "", date: nil, date1: Date(), value: nil, value2: "", value3: ["test", "test2"], text: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
        
        
//        let dataSource = ModificationDatasource(element: element, inputDescriptors: [
//            .standardOptional(title: "Full Name", keyPath: \Element.name, isRequired: true),
//                                                                                     .standardOptional(title: "Title", keyPath: \Element.title, isRequired: true),
//                                                                                     .datePicker(title: "Birth Date", keyPath: \Element.date, isRequired: true),
//                                                                                     .datePicker(title: "Birth Date1", keyPath: \Element.date1, isRequired: true),
//                                                                                     .itemsPicker(title: "Select", keyPath: \Element.value, model: ["a", "b", "c"], isRequired: true),
//                                                                                     .itemsPicker(title: "Select 2", keyPath: \Element.value2, model: ["1", "2", "3"], isRequired: true),
//                                                                                     .multitude(title: "Attr", keyPath: \Element.value3, isRequired: true),
//                                                                                     .notes(title: "Text", keyPath: \Element.text, isRequired: true)
//                                                                                     ]
//                                                )
        
        
        let dataSource = ModificationDatasource(element: element, inputDescriptors: [
            .standardOptional(title: "Title", keyPath: \Element.title, keyboardType: .default, isRequired: true),
            .datePickerOptional(title: "Birth Date", keyPath: \Element.date, isRequired: false),
            .datePickerOptional(title: "Birth Date1", keyPath: \Element.date1, isRequired: false),
            .itemsPickerOptional(title: "Select", keyPath: \Element.value, model: ["a", "b", "c"], isRequired: false),
            .itemsPickerOptional(title: "Select 2", keyPath: \Element.value2, model: ["1", "2", "3"], isRequired: false),
            .multitudeOptional(title: "Attr", keyPath: \Element.value3, isRequired: true),
            .notesOptional(title: "Text", keyPath: \Element.text, isRequired: true),
             .standardOptional(title: "Title", keyPath: \Element.title, keyboardType: .default, isRequired: false),
            ])
        
        //modificaitonElementController = ModificationElementController(containerView: containerView, dataSource: dataSource, notificationCenter: NotificationCenter.default)
        
        
//        viewz = ScanningView.fromNib()
//        containerView.addSubview(viewz!)
//        view.addConstraintsForWrappedInsideView(viewz!)
        
       
        
    }
    
    @IBAction func validate(_ sender: Any) {
        
        let vc2: PatientTagsSearchViewController! =  UIStoryboard.patientTags.instantiateViewController()
        let vc3: AlertRespondNavigationViewController! =  UIStoryboard.alerts.instantiateViewController()

//        vc3.injectProperties(interactor: AlertRespondNavigationInteractor(), presenter: AlertRespondNavigationPresenter(), router: AlertRespondNavigationRouter())
        
        let vc = PopUpContainerViewController.generate(forContainedViewController: vc3, mode: .alert)
        present(vc, animated: true, completion: nil)
        
        
//        UIView.animate(withDuration: 3) {
//            self.bottomConstraint.constant = 500
//            self.viewz!.animationView.layoutIfNeeded()
//            self.viewz!.layoutIfNeeded()
//
//
//        }
        
//        do {
//           let a = try modificaitonElementController?.requestModifiedElement()
//            print(a)
//        } catch ModificationError.failedInputValidation {
//            print("validation error")
//        }
//        catch {
//        }
        
    }
    
    
}

extension ViewController {
    
    func injectProperties(alertNavigationProvider: Provider<AlertRespondNavigationViewController>) {
        self.alertNavigationProvider = alertNavigationProvider
    }
    
}
