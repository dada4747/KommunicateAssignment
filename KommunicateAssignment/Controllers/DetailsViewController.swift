//
//  profileVc.swift
//  KommunicateAssignment
//
//  Created by admin on 02/06/22.
//

import UIKit
import SafariServices

protocol UserInfoVCDelegate: AnyObject {
    func didTapGitHubProfile(for user: User)
//    func didTapGetFollowers(for user: User)
}
class UserInfoVC: UIViewController {

    let headerView          = UIView()
    let itemViewOne         = UIView()
    let itemViewTwo         = UIView()
    let dateLabel           = BodyLabel(textAlignment: .center)
    var itemViews: [UIView] = []
    
    
    var username: String!
    weak var delegate: FollowerListVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        layoutUI()
        getUserInfo()
       
    }
    
    // MARK: - Cofigure user info controller
    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    // MARK: - network call for user info
    func getUserInfo() {

        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
            case .failure(let error): break
//                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    // MARK: - Configure ui
    func configureUIElements(with user:User) {
        
        let repoItemVC              = GFRepoItemVC(user: user)
        repoItemVC.delegate         = self

        let followerItemVC          = GFFollowerItemVC(user: user)
        followerItemVC.delegate     = self
        
        self.add(childVc: UserInfoHeaderVC(user: user), to: self.headerView)
        
        self.add(childVc: repoItemVC, to: self.itemViewOne)
        self.add(childVc: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYearFormat())"
    }
    // MARK: -
    func layoutUI() {
        let padding: CGFloat = 20
        let itemHeight: CGFloat = 140
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]
        
        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),

                
            ])
        }
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: itemHeight),
            
            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: itemHeight),
         
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    func add(childVc: UIViewController, to containerView: UIView) {
        addChild(childVc)
        containerView.addSubview(childVc.view)
        childVc.view.frame = containerView.bounds
        childVc.didMove(toParent: self)
    }
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }

}

// MARK: - user info delegate
extension UserInfoVC: UserInfoVCDelegate {
    func didTapGitHubProfile(for user: User) {
        guard let url = URL(string: user.htmlUrl) else {
            return
        }
        presentSafariVC(with: url)
    }
}
