//
//  TrandViewController.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/19.
//

import UIKit
import Lottie
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
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = view.center
        return indicator
    }()
    
    let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    private lazy var repositoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshControl
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        return tableView
    }()
    
    private lazy var animationView: AnimationView = {
        let animationView = AnimationView(name: "SearchImage")
        
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        
        return animationView
    }()
    
    private lazy var imageBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(animationView)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }
    
    private func makeUI() {
        view.backgroundColor = .white
        
        searchController.searchBar.setImage(UIImage(named: "okstring"), for: .clear, state: .reserved)
        
        self.navigationItem.searchController = searchController
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(repositoryTableView)
        
        view.addSubview(imageBackgroundView)
        
        imageBackgroundView.snp.makeConstraints({
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        })
        
        animationView.snp.makeConstraints({
            $0.centerX.equalTo(view.snp_centerXWithinMargins)
            $0.centerY.equalTo(view.snp_centerYWithinMargins)
            $0.width.height.equalTo(view.snp.width).multipliedBy(0.7)
        })
        
        repositoryTableView.snp.makeConstraints({
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
        })
        
        view.addSubview(indicator)
    }
    
    func bindViewModel() {
        
        let query = searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty) { $1 }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        
        let pullRefresh = refreshControl.rx.controlEvent(.valueChanged)
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty) { $1 }
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
        
        let nextPage = repositoryTableView.rx.reachedBottom(offset: 250)
            .withLatestFrom(self.searchController.searchBar.rx.text.orEmpty) { $1 }
        
        let input = TrandViewModel.Input(query: query, pullRefresh: pullRefresh, nextPage: nextPage)
        
        let output = viewModel.transform(input: input)
        
        let isEmptyQuery = searchController.searchBar.rx.text
            .map({ return $0 == nil || $0 == "" })
        
        isEmptyQuery
            .map({ !$0 })
            .bind(to: imageBackgroundView.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        isEmptyQuery
            .bind(to: repositoryTableView.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        output.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        output.isRefresh
            .drive(onNext: { isRefresh in
                if isRefresh {
                    self.indicator.startAnimating()
                } else {
                    self.indicator.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.repositoryTableView.setContentOffset(.zero, animated: true)
                }
                
            }).disposed(by: rx.disposeBag)
        
        repositoryTableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.className)
        
        output.repository
            .bind(to: repositoryTableView.rx.items) { (tableView, indexPath, repository) -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryCell.className) as? RepositoryCell else {
                    return UITableViewCell()
                }
                cell.configure(item: repository)
                
                return cell
            }.disposed(by: rx.disposeBag)
        
        Observable.zip(repositoryTableView.rx.itemSelected, repositoryTableView.rx.modelSelected(Repository.self))
            .do(onNext: { [weak self] indexPath, repository in
                self?.repositoryTableView.deselectRow(at: indexPath, animated: true)
            })
            .map{ $0.1 }
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
        
    }
}
