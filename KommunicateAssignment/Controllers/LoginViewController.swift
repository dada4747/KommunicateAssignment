//
//  ViewController.swift
//  KommunicateAssignment
//
//  Created by admin on 30/05/22.
//

import UIKit

class ViewController: UIViewController {
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.1)
        return tf
    }()
    
    let name: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Name"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = UIColor(white: 0, alpha: 0.1)
        return tf
    }()
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo")
        return iv
    }()
    let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.darkGray
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue("rahul", forKey: "name")
        UserDefaults.standard.setValue("adsurerahul96@gmail.com", forKey: "email")
        view.backgroundColor = .systemCyan
        setupTextFields()
        confugureIcon()
    }
    
    func setupTextFields() {
        let stackView = UIStackView(arrangedSubviews: [ name, emailTextField, logInButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            stackView.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        logInButton.addTarget(self, action: #selector(tapLogin), for: .touchUpInside)
    }
    func confugureIcon(){
        view.addSubview(icon)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.widthAnchor.constraint(equalToConstant: 200),
            icon.heightAnchor.constraint(equalToConstant: 200),
            icon.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }
    
    @objc func tapLogin() {
        //        self.dismiss(animated: true)
        guard let newName = name.text,
              let email = emailTextField.text,
              !newName.isEmpty,
              !email.isEmpty else {
            showLoginFailedAlert()
            return
        }
        name.resignFirstResponder()
        emailTextField.resignFirstResponder()
        print(newName)
        print(email)
        print(checkLogin(email: email, password: newName))
        if checkLogin(email: email, password: newName) {
            print("present pop your current controller")
            self.dismiss(animated: true)
        } else {
            showLoginFailedAlert()
        }
    }
    
    private func showLoginFailedAlert() {
        let alertView = UIAlertController(title: "Login Problem",
                                          message: "Wrong username or password.",
                                          preferredStyle:. alert)
        let okAction = UIAlertAction(title: "Foiled Again!", style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
    
    func checkLogin(email: String, password: String) -> Bool {
        guard let username = UserDefaults.standard.value(forKey: "name") as? String else {
            return false
        }
        guard let useremail = UserDefaults.standard.value(forKey: "email") as? String else { return false }
        print("******************************************")
        print(username)
        print(useremail)
        print("******************************************")
        //        guard email == UserDefaults.standard.value(forKey: "username") as? String else {
        //            return false
        //        }
        //        guard password == UserDefaults.standard.value(forKey: "password") as? String else {
        //            return false
        //        }
        //
        if((useremail == email) && (username == password)) {
            return true
        }
        return true
    }
}

