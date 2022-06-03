//
//  HomeVCViewController.swift
//  KommunicateAssignment
//
//  Created by admin on 30/05/22.
//

import UIKit

protocol FollowerListVCDelegate: AnyObject {
    func didRequestFollowers(for username: String)
}
class DashboardViewController: UIViewController {
    var searchController = UISearchController(searchResultsController: nil)
    let tableView = UITableView()
    var filteredFollowers: [Follower]   = []
    var userName: String!
    var page  = 1
    var followers: [Follower] = []
    var isSearching  = false
    var hasMoreFollowers   = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName = "dada4747"
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.backgroundColor = .white
        showLogInPage()
    }
    func getFollowers(userName: String, page: Int) {
        NetworkManager.shared.getFollowers(for: userName, page: page) { [weak self] result in
            guard let self = self  else{ return}
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followers.append(contentsOf: followers)
                if self.followers.isEmpty {
                    _ = "This user doesn't have any followers. Go follow them 😀."
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(_): break
            }
        }
    }

    func showLogInPage(){
        DispatchQueue.main.async {
            let vc = ViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .flipHorizontal
            vc.navigationItem.hidesBackButton = true
            vc.navigationController?.navigationBar.backItem?.hidesBackButton = true
            self.navigationController?.present(vc, animated: true, completion: {
                self.showHomeViewUI()
            })
        }
    }
    
    func showHomeViewUI(){
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.backItem?.hidesBackButton = true
        navigationController?.isNavigationBarHidden = false

        getFollowers(userName: userName, page: 1)
        view.backgroundColor = .systemCyan
        configureView()
        configureSeachController()
        configureTableView()
    }

    func configureView() {
        let profileButtonItem   = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(profileTapped))
        navigationController?.navigationBar.tintColor           = .label
        navigationItem.setRightBarButton(profileButtonItem, animated: false)
        definesPresentationContext                               = true
        navigationItem.hidesSearchBarWhenScrolling               = false
    }
    func configureSeachController() {
        searchController.loadViewIfNeeded()
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType                 = UIReturnKeyType.done
        searchController.searchBar.placeholder                   = "Search Notes"
        searchController.searchBar.autocorrectionType            = .no
        searchController.hidesNavigationBarDuringPresentation    = false
        searchController.searchBar.backgroundColor               = .secondarySystemBackground
        searchController.searchBar.tintColor                     = .label
        navigationItem.titleView = searchController.searchBar
        searchController.searchResultsUpdater                   = self
        searchController.searchBar.delegate                     = self
    }
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame         = view.bounds
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(FollowerCell.self, forCellReuseIdentifier: FollowerCell.reuseID)
    }
    @objc func profileTapped(){
        let provc = ProfileViewController()
        provc.delegate = self
        self.present(provc, animated: true)
     }
}
extension DashboardViewController: ProfileControllerDelegate {
    func handleLogout() {
        showLogInPage()
    }
}

extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredFollowers.count
        } else {
            return followers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowerCell.reuseID) as! FollowerCell
        if isSearching{
            let follower = filteredFollowers[indexPath.row]
            cell.set(follower: follower)
        }else{
            let follower = followers[indexPath.row]
            cell.set(follower: follower)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                let follower = followers[indexPath.item]

                let destVc                                  = UserInfoVC()
                destVc.username                             = follower.login
                self.present(destVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let follower = followers[indexPath.row]
        followers.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
}
extension DashboardViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText      = searchController.searchBar.text!
        if !searchText.isEmpty {
            isSearching     = true
            filteredFollowers.removeAll()
            for item in followers {
                if item.login.lowercased().contains(searchText.lowercased()) == true
                {
                    filteredFollowers.append(item)
                }
            }
        }
        else {
            isSearching     = false
            filteredFollowers.removeAll()
            filteredFollowers   = followers
        }
        
        
        guard let filter    = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching         = true
        filteredFollowers.removeAll()
        
        for item in followers {
            if item.login.lowercased().contains(filter.lowercased()) == true
            {
                filteredFollowers.append(item)
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredFollowers.removeAll()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
