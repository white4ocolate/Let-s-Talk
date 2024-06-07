//
//  LoginViewController.swift
//  MyChat
//
//  Created by white4ocolate on 14.04.2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    let welcomeBackLabel = UILabel(text: "Welcome Back!", font: .avenir26())
    let loginWithLabel = UILabel(text: "Login with")
    let orLabel = UILabel(text: "or")
    let emailLabel = UILabel(text: "Email")
    let passwordLabel = UILabel(text: "Password")
    let needAnAccountLabel = UILabel(text: "Need an account?")
    let googleButton = UIButton(title: "Google", titleColor: .black)
    let loginButton = UIButton(backgroundColor: .blackButton, title: "Login", titleColor: .mainWhite)
    let emailTextField = OneLineTextField(font: .avenir20())
    let passwordTextField = OneLineTextField(font: .avenir20())
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.redButton, for: .normal)
        button.titleLabel?.font = .avenir20()
        
        return button
    }()
    
    weak var delegate: AuthViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        googleButton.customizeGoogleButton()
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
    }
    
    @objc private func googleButtonTapped() {
        GoogleViewController().googleSignIn(controller: self)
    }
    
    @objc private func loginButtonTapped() {
        AuthService.shared.login(email: emailTextField.text!, password: passwordTextField.text!) { [weak self] result in
            switch result {
            case .success(let user):
                self?.showAlert(with: "Success", message: "You have successfully logged in!") {
                    FireStoreService.shared.getUserData(user: user) { result in
                        switch result {
                        case .success(let myuser):
                            let mainTabBarController = MainTabBarController(currentUser: myuser)
                            mainTabBarController.modalPresentationStyle = .fullScreen
                            self?.present(mainTabBarController, animated: true)
                        case .failure(let error):
                            print("Error with login: \(error.localizedDescription)")
                            self?.present(SetupProfileViewController(currentUser: user), animated: true)
                        }
                    }
                }
            case .failure(let error):
                self?.showAlert(with: "Error", message: error.localizedDescription)
            }
        }
    }
    
    @objc private func signUpButtonTapped() {
        dismiss(animated: true) {
            self.delegate?.toSignUpVC()
        }
    }
}

//MARK: - Setup Constraints
extension LoginViewController {
    private func setupConstraints() {
        let googleLoginView = ButtonFormView(label: loginWithLabel, button: googleButton)
        let emailStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [passwordLabel, passwordTextField], axis: .vertical, spacing: 0)
        let stackView = UIStackView(arrangedSubviews: [googleLoginView, orLabel, emailStackView, passwordStackView, loginButton], axis: .vertical, spacing: 40)
        let alreadyOnboardStackView = UIStackView(arrangedSubviews: [needAnAccountLabel, signUpButton], axis: .horizontal, spacing: 10)
        
        welcomeBackLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        alreadyOnboardStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeBackLabel)
        view.addSubview(stackView)
        view.addSubview(alreadyOnboardStackView)
        
        NSLayoutConstraint.activate([
            welcomeBackLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            welcomeBackLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: welcomeBackLabel.bottomAnchor, constant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        NSLayoutConstraint.activate([
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            alreadyOnboardStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            alreadyOnboardStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
    }
}

#Preview {
    LoginViewController()
}
