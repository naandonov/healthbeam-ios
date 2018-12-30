//
//  LoginViewController.swift
//  HealthBeam
//
//  Created by Nikolay Andonov on 29.12.18.
//  Copyright (c) 2018 nikolay.andonov. All rights reserved.
//

import UIKit
import UnderLineTextField

typealias LoginInteractorProtocol = LoginBusinessLogic & LoginDataStore
typealias LoginPresenterProtocol =  LoginPresentationLogic
typealias LoginRouterProtocol = LoginRoutingLogic & LoginDataPassing

protocol LoginDisplayLogic: class {
    
}

class LoginViewController: UIViewController, LoginDisplayLogic {
    
    var interactor: LoginInteractorProtocol?
    var router: LoginRouterProtocol?
    
    private var keyboardScrollHandler: KeyboardScrollHandler?
    private var notificationCenter: NotificationCenter!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var emailTextField: FloatingTextField!
    @IBOutlet weak var passwordTextField: FloatingTextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var noAccountButton: UIButton!
    @IBOutlet weak var loginButton: RoundedButton!
    
    @IBOutlet weak var topContainerView: UIView!
    
    private var lightLogoView: LightLogoView!
    
    // MARK:- View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .paleGray
        topContainerView.addSubview(lightLogoView)
        topContainerView.addConstraintsForWrappedInsideView(lightLogoView)
        
        emailTextField.placeholder = "Email".localized()
        emailTextField.keyboardType = .emailAddress
        emailTextField.font = .applicationRegularFont()
        emailTextField.delegate = self
        //Curently there is a bug in the UnderLineTextField library disregarding the onCommit validation type
        emailTextField.validationType = UnderLineTextFieldValidateType.init(rawValue: 1 << 3)
        
        passwordTextField.placeholder = "Password".localized()
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.font = .applicationRegularFont()
        passwordTextField.delegate = self
        //Curently there is a bug in the UnderLineTextField library disregarding the onCommit validation type
        passwordTextField.validationType = UnderLineTextFieldValidateType.init(rawValue: 1 << 3)
        
        forgotPasswordButton.setTitle("Forgotten Password".localized(), for: .normal)
        forgotPasswordButton.titleLabel?.font = .applicationSubButtonTextFont()
        forgotPasswordButton.tintColor = .neutralBlue
        
        noAccountButton.setTitle("Don't have an account?".localized(), for: .normal)
        noAccountButton.titleLabel?.font = .applicationSubButtonTextFont()
        noAccountButton.tintColor = .neutralBlue
        
        loginButton.setTitle("LOGIN".localized(), for: .normal)
        loginButton.titleLabel?.font = .applicationRegularFont()
        
        keyboardScrollHandler = KeyboardScrollHandler(scrollView: scrollView, notificationCenter: notificationCenter)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func initiateLogin() {
        do {
            try emailTextField.validate()
            try passwordTextField.validate()
        }
        catch {
            print("validation failed")
            return
        }
    }
}

//MARK: - Button Actions

extension LoginViewController {
    
    @IBAction func forgotPasswordButtonAction(_ sender: Any) {
    }
    @IBAction func loginButtonAction(_ sender: Any) {
        initiateLogin()
    }
}

//MARK: - UnderLineTextFieldDelegate

extension LoginViewController: UnderLineTextFieldDelegate {
    
    func textFieldValidate(underLineTextField: UnderLineTextField) throws {
        
        let noContentError  = UnderLineTextFieldErrors
            .error(message: "Required Field".localized())
        
        guard let text = underLineTextField.text else {
            throw noContentError
        }
        if text.count == 0 {
            throw noContentError
        }
        
        if underLineTextField == passwordTextField {
            //Pasword validation
        }
        else if underLineTextField == emailTextField {
            if !text.isValidEmail() {
                throw UnderLineTextFieldErrors
                    .error(message: "Invalid Email Format")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
//            try? emailTextField.validate()
            _ = emailTextField.resignFirstResponder()
            _ = passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
//            try? passwordTextField.validate()
            _ = passwordTextField.resignFirstResponder()
            initiateLogin()
        }
        return true
    }
}

//MARK: - Properties Injection

extension LoginViewController {
    func injectProperties(interactor: LoginInteractorProtocol,
                          presenter: LoginPresenterProtocol,
                          router: LoginRouterProtocol,
                          lightLogoView: LightLogoView,
                          notificationCenter: NotificationCenter) {
        self.interactor = interactor
        self.router = router
        self.router?.dataStore = interactor
        self.interactor?.presenter = presenter
        self.interactor?.presenter?.presenterOutput = self
        self.router?.viewController = self
        
        self.lightLogoView = lightLogoView
        self.notificationCenter = notificationCenter
    }
}
