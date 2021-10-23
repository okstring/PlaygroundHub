//
//  ProfileViewController.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/21.
//

import UIKit

class ProfileViewController: UIViewController, ViewModelBindableType {
    var viewModel: ProfileViewModel!
    
    private let userRepositoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.isHidden = true
        tableView.backgroundColor = .gray
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    func makeUI() {
        view.addSubview(userRepositoryTableView)
        
        userRepositoryTableView.snp.makeConstraints({
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        })
    }
    
    func bindViewModel() {
        userRepositoryTableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
    }
}

extension ProfileViewController: UITableViewDelegate {
    
}
