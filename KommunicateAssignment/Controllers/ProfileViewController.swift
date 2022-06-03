//
//  ProfileViewController.swift
//  KommunicateAssignment
//
//  Created by admin on 02/06/22.
//


import UIKit
//import SDWebImage

protocol ProfileControllerDelegate: AnyObject {
    func handleLogout()
}

class ProfileViewController: UIViewController {
    weak var delegate   : ProfileControllerDelegate?

    let label = TitleLabel(textAlignment: .center, fontSize: 30)
    let nameLabel = TitleLabel(textAlignment: .left, fontSize: 23)
    let emailLabel = TitleLabel(textAlignment: .left, fontSize: 23)
    let name = BodyLabel(textAlignment: .left)
    let email = BodyLabel(textAlignment: .left)
    let logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 3
        button.backgroundColor = UIColor.lightGray
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
       
        configureTitleLabel()
        configureNameLabel()
        configureEmailLabel()
        configureName()
        configureEmail()
        configureLogoutButton()
       checkDetails()
    }
    func checkDetails() {
        guard let username = UserDefaults.standard.value(forKey: "name") as? String else {
            return
        }
        guard let useremail = UserDefaults.standard.value(forKey: "email") as? String else { return }
        print(username)
        print(useremail)
    }
    
    func configureTitleLabel(){
        view.addSubview(label)
    
        label.text = "Welcome To Profile"
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            label.widthAnchor.constraint(equalToConstant: 300)
        ])
        
    }
    func configureNameLabel(){
        view.addSubview(nameLabel)
        nameLabel.text = "username"
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
        
    }

    func configureEmailLabel(){
        view.addSubview(emailLabel)
        emailLabel.text = "password"
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 100),
            emailLabel.heightAnchor.constraint(equalToConstant: 20),
            emailLabel.widthAnchor.constraint(equalToConstant: 150)
        ])
       
    }
    func configureName(){
        view.addSubview(name)
        name.text = UserDefaults.standard.value(forKey: "name") as? String
        name.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            name.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 20),
            name.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40),
            name.heightAnchor.constraint(equalToConstant: 50),
            name.widthAnchor.constraint(equalToConstant: 200)
        ])
       
    }

    func configureEmail(){
        view.addSubview(email)
        email.text = UserDefaults.standard.value(forKey: "email") as? String
        email.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            email.leftAnchor.constraint(equalTo: emailLabel.rightAnchor, constant: 20),
            email.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 100),
            email.heightAnchor.constraint(equalToConstant: 20),
            email.widthAnchor.constraint(equalToConstant: 200)
        ])
       
}
    func configureLogoutButton(){
        view.addSubview(logOutButton)
        logOutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        NSLayoutConstraint.activate([
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 40),
            logOutButton.heightAnchor.constraint(equalToConstant: 50),
            logOutButton.widthAnchor.constraint(equalToConstant: 200)
        ])
       
    }
    @objc func handleLogout() {
        let alert = UIAlertController(title: nil, message: "Are you sure want to Logout", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
 

