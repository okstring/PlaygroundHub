//
//  TrandViewController.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/19.
//

import UIKit

class TrandViewController: UIViewController, ViewModelBindableType {
    var viewModel: TrandViewModel!
    
    private var repositorySearchBar: UISearchBar {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.delegate = self
        return searchBar
    }
    
    private lazy var repositoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = repositorySearchBar
        repositoryTableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.className)
    }
    
    func bindViewModel() {
        let input = TrandViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}

extension TrandViewController: UISearchBarDelegate {
    
}
