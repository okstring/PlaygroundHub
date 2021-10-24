//
//  ProfileViewController.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxViewController

class ProfileViewController: UIViewController, ViewModelBindableType {
    var viewModel: ProfileViewModel!
    
    private let userRepositoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .gray
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func makeUI() {
        view.backgroundColor = .white
        
        userRepositoryTableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.className)
        
        view.addSubview(userRepositoryTableView)
        
        userRepositoryTableView.translatesAutoresizingMaskIntoConstraints = false
        userRepositoryTableView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    func bindViewModel() {
        userRepositoryTableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        let input = ProfileViewModel.Input(trigger: rx.viewWillAppear.mapToVoid().asObservable())
        let output = viewModel.transform(input: input)
        
        output.repository
            .bind(to: userRepositoryTableView.rx.items) { (tableView, indexPath, repository) -> UITableViewCell in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.className) as? RepositoryCell else {
                    return UITableViewCell()
                }
                
                cell.configure(item: repository)
                
                return cell
            }.disposed(by: rx.disposeBag)
        
    }
}

extension ProfileViewController: UITableViewDelegate {
    
}
