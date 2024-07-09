//
//  SignUpViewController.swift
//  MyChat
//
//  Created by white4ocolate on 13.04.2024.
//

import UIKit

class SignUpViewController: UIViewController {
    
    let welcomeLabel = UILabel(text: "Hello", font: .avenir26())
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let confirmPasswordLabel = UILabel(text: "Confirm password")
    let alreadyOnboardLabel = UILabel(text: "Already onboard?")
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    let confirmPasswordTextField = OneLineTextField(font: .avenir20())
    let signUpButton = UIButton(backgroundColor: .blackButton, title: "Sign Up", titleColor: .mainWhite)
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.redButton, for: .normal)
        button.titleLabel?.font = .avenir20()
        
        return button
    }()
    
    weak var delegate: AuthViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func signUpButtonTapped() {
        AuthService.shared.register(email: emailTextField.text!, password: passwordTextField.text!, confirmPassword: confirmPasswordTextField.text!) { [weak self] result in
            switch result {
                
            case .success(let user):
                self?.showAlert(with: "Success", message: "You have successfully registered!"){
                    self?.present(SetupProfileViewController(currentUser: user), animated: true)
                }
            case .failure(let error):
                self?.showAlert(with: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func loginButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toLoginVC()
        }
    }
}

//MARK: - Setup Constraints
extension SignUpViewController {
    private func setupConstraints() {
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [confirmPasswordLabel, confirmPasswordTextField], axis: .vertical, spacing: 0)
        let stackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmPasswordStackView, signUpButton], axis: .vertical, spacing: 40)
        let alreadyOnboardStackView = UIStackView(arrangedSubviews: [alreadyOnboardLabel, loginButton], axis:
                .horizontal, spacing: 10)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        alreadyOnboardStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(alreadyOnboardStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            alreadyOnboardStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 100),
            alreadyOnboardStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
    }
}

extension UIViewController {
    
    func showAlert(with title: String, message: String, complition: @escaping () -> () = {}){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            complition()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
