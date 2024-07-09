//
//  ViewController.swift
//  MyChat
//
//  Created by white4ocolate on 12.04.2024.
//

import UIKit
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

class AuthViewController: UIViewController {
    
    let logoImageView = UIImageView(image: UIImage(imageLiteralResourceName: "Logo"), contentMode: .scaleAspectFit)
    let googleLabel = UILabel(text: "Get started with")
    let emailLabel = UILabel(text: "Or sign up with")
    let alreadyOnboardLabel = UILabel(text: "Allready onboard?")
    let googleButton = UIButton(title: "Google", titleColor: .black)
    let emailButton = UIButton(backgroundColor: .blackButton, title: "Email", titleColor: .white, isShadow: false)
    let loginButton = UIButton(title: "Login", titleColor: .redButton)
    
    let signUpViewController = SignUpViewController()
    let loginViewController = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraints()
        googleButton.customizeGoogleButton()
        
        emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
        
        signUpViewController.delegate = self
        loginViewController.delegate = self
    }
    
    @objc private func emailButtonTapped(){
        present(signUpViewController, animated: true)
    }
    
    @objc private func loginButtonTapped(){
        present(loginViewController, animated: true)
    }
    
    @objc private func googleButtonTapped() {
        GoogleViewController().googleSignIn(controller: self)
    }
}

//MARK: - Setup Constraints
extension AuthViewController {
    private func setupConstraints(){
        let googleView = ButtonFormView(label: googleLabel, button: googleButton)
        let emailView = ButtonFormView(label: emailLabel, button: emailButton)
        let loginView = ButtonFormView(label: alreadyOnboardLabel, button: loginButton)
        let stackView = UIStackView(arrangedSubviews: [googleView, emailView, loginView], axis: .vertical, spacing: 40)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
}

//MARK: - Delegate
extension AuthViewController: AuthNavigationDelegate {
    func toLoginVC() {
        present(loginViewController, animated: true)
    }
    
    func toSignUpVC() {
        present(signUpViewController, animated: true)
    }
}
