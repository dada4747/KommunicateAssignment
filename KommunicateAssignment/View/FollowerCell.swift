//
//  File.swift
//  KommunicateAssignment
//
//  Created by admin on 02/06/22.
//

import UIKit
class FollowerCell: UITableViewCell {
    
    
    static let reuseID  = "FollowerCell"
    let avatarImageView = AvatarImageView(frame: .zero)
    let usernameLabel = TitleLabel(textAlignment: .left, fontSize: 26)
    let nameLabel = SecondaryTitleLabel(fontSize: 18)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set properties
    
    func set(follower: Follower) {
        usernameLabel.text = follower.login
        NetworkManager.shared.getUserInfo(for: follower.login) { [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let user):
                    DispatchQueue.main.async {
                        self.nameLabel.text = user.name
                    }
            case .failure(_): break
            }
        
        }
        NetworkManager.shared.downloadImage(from: follower.avatarUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.avatarImageView.image = image }
        }
    }
    
    // MARK:- configure view
    private func configure() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(nameLabel)
        
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 12
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            avatarImageView.heightAnchor.constraint(equalToConstant: 60),
            avatarImageView.widthAnchor.constraint(equalToConstant: 60),
            usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 20),

            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40),
            nameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5),
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
}
