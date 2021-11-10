//
//  TrandViewController.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/19.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class TrandViewController: UIViewController, ViewModelBindableType {
    var viewModel: TrandViewModel!
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색어를 입력하세요"
        return searchController
    }()
    
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
        makeUI()
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        
        self.navigationItem.searchController = searchController
        
        view.addSubview(repositoryTableView)
        
        repositoryTableView.snp.makeConstraints({
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        })
    }
    
    func bindViewModel() {
        
        let query = searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty) { $1 }
            .distinctUntilChanged()
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .debug()
        
        let input = TrandViewModel.Input(query: query)
        
        let output = viewModel.transform(input: input)
        
        output.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        repositoryTableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.className)
        
        output.repository
            .drive(repositoryTableView.rx.items) { (tableView, indexPath, repository) -> UITableViewCell in
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.className) as? RepositoryCell else {
                    return UITableViewCell()
                }
                
                cell.configure(item: repository)
                
                return cell
            }.disposed(by: rx.disposeBag)
    }
}
