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

enum SegmentedControlIndex: Int, CustomStringConvertible {
    case repository = 0
    case starred = 1
    
    var description: String {
        switch self {
        case .repository:
            return "My repository"
        case .starred:
            return "Starred"
        }
    }
}

class ProfileViewController: UIViewController, ViewModelBindableType {
    var viewModel: ProfileViewModel!
    
    private let repositoryRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    private let starredRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        return control
    }()
    
    private lazy var userRepositoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.refreshControl = repositoryRefreshControl
        return tableView
    }()
    
    private lazy var userStarredTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .blue
        tableView.refreshControl = starredRefreshControl
        return tableView
    }()
    
    private let tableViewScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var tableViewStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userRepositoryTableView, userStarredTableView])
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let repoTypeSegmentedControll: CustomSegmentedControl = {
        let control = CustomSegmentedControl(frame: CGRect(x: 0, y: 0, width: 300, height: 300), buttonTitle: [SegmentedControlIndex.repository.description, SegmentedControlIndex.starred.description])
        control.selectorTextColor = .systemBlue
        control.selectorViewColor = .systemBlue
        control.backgroundColor = .clear
        return control
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
        
        view.addSubview(repoTypeSegmentedControll)
        
        repoTypeSegmentedControll.snp.makeConstraints({
            $0.left.right.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(50)
        })
        
        tableViewScrollView.addSubview(tableViewStackView)
        view.addSubview(tableViewScrollView)
        
        tableViewScrollView.snp.makeConstraints({
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(repoTypeSegmentedControll.snp.bottom)
        })
        
        tableViewStackView.snp.makeConstraints({
            $0.height.equalTo(tableViewScrollView.frameLayoutGuide)
            $0.width.equalTo(tableViewScrollView.frameLayoutGuide).priority(750)
            $0.edges.equalTo(tableViewScrollView.contentLayoutGuide)
        })
        
        userRepositoryTableView.snp.makeConstraints({
            $0.width.equalTo(tableViewScrollView.frameLayoutGuide)
        })
        
        userStarredTableView.snp.makeConstraints({
            $0.width.equalTo(tableViewScrollView.frameLayoutGuide)
        })
    }
    
    private let refresh = PublishSubject<Void>()
    
    func bindViewModel() {
        repoTypeSegmentedControll.delegate = self
        tableViewScrollView.delegate = self
        
        userRepositoryTableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        let firstLoad = rx.viewWillAppear
            .mapToVoid()
        
        let refresh = repositoryRefreshControl.rx.controlEvent(.valueChanged)
            .mapToVoid()
            .asObservable()
        
        let trigger = Observable.merge([firstLoad, refresh])
        
        let input = ProfileViewModel.Input(trigger: trigger)
        let output = viewModel.transform(input: input)
        
        output.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        output.refreshing
            .map({ !$0 })
            .drive(onNext: { [weak self] isFinished in
                if isFinished {
                    self?.userRepositoryTableView.refreshControl?.endRefreshing()
                }
            }).disposed(by: rx.disposeBag)
        
        output.repository
            .drive(userRepositoryTableView.rx.items) { (tableView, indexPath, repository) -> UITableViewCell in
          
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

extension ProfileViewController: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        let x = CGFloat(index) * tableViewScrollView.frame.size.width
        let point = CGPoint(x: x, y: 0)
        tableViewScrollView.setContentOffset(point, animated: true)
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        repoTypeSegmentedControll.setIndex(index: Int(pageNumber))
    }
}
