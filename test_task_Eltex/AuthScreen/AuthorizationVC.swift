//
//  AuthorizationVC.swift
//  test_task_Eltex
//
//  Created by Konstantin on 04.10.2022.
//

import UIKit

final class AuthorizationVC: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    private lazy var logoImage: UIView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "logo_eltex")
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.contentMode = .scaleAspectFit
        return logoImage
    }()
    
    private lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 2
        textField.indent(size: 10)
        textField.layer.borderColor = Constants.blueColorForTF
        textField.placeholder = "Enter email"
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 2
        textField.indent(size: 10)
        textField.layer.borderColor = Constants.blueColorForTF
        textField.placeholder = "Enter password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var myButton: UIButton = {
        let myButton = UIButton()
        myButton.backgroundColor = UIColor(cgColor: Constants.blueColorForTF)
        myButton.setTitle("Log In", for: .normal)
        myButton.layer.cornerRadius = 8
        myButton.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        return myButton
    }()
    
    private var textFieldsStackView = UIStackView()
    
    private let networkAuthManager: AuthProtocol
    private var storageManager: StorageManagerProtocol
    
    // MARK: - Initialization
    init(networkAuth: AuthProtocol, storage: StorageManagerProtocol) {
        self.networkAuthManager = networkAuth
        self.storageManager = storage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.hidesBackButton = true
        self.setupViews()
        self.setupDelegate()
        self.setConstraints()
    }
    
    // MARK: - Methods
    private func setupViews() {
    
        self.textFieldsStackView = UIStackView(arrangedSubviews: [userNameTextField, passwordTextField, myButton],
                                          axis: .vertical,
                                          spacing: 10,
                                          distribution: .fillEqually)
        
        self.view.addSubview(self.logoImage)
        self.view.addSubview(self.textFieldsStackView)
    }
    
    private func setupDelegate() {
        self.userNameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            self.logoImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.widthMultiplierForLogo),
            self.logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.logoImage.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: Constants.indentForLogo)
        ])
        NSLayoutConstraint.activate([
            self.textFieldsStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.textFieldsStackView.topAnchor.constraint(equalTo: self.logoImage.bottomAnchor, constant: Constants.topAnchorStackView),
            self.textFieldsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Constants.lead_trailAnchorStackView),
            self.textFieldsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Constants.lead_trailAnchorStackView)
        ])
    }
    
    @objc
    private func loginButtonTapped() {
        guard let userNameText = userNameTextField.text, let passwordText = passwordTextField.text else { return }
        
        self.networkAuthManager.authorization(userName: userNameText, password: passwordText) { [unowned self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError(message: error.localizedDescription)
                }
            case .success(let data):
                self.storageManager.saveTokenInStorage(token: data.access_token)
                self.storageManager.isLoginIn = true
                DispatchQueue.main.async {
                    let vc = Assembly.shared.createUserProfileVC()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
}


