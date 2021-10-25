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
    
    private let userRepositoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        return tableView
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
        
        view.addSubview(userRepositoryTableView)
        
        userRepositoryTableView.snp.makeConstraints({
            $0.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(repoTypeSegmentedControll.snp.bottom)
        })
    }
    
    func bindViewModel() {
        repoTypeSegmentedControll.delegate = self
        
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        userRepositoryTableView.rx
            .setDelegate(self)
            .disposed(by: rx.disposeBag)
        
        let input = ProfileViewModel.Input(trigger: rx.viewWillAppear.mapToVoid().asObservable())
        let output = viewModel.transform(input: input)
        
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
        
    }
}
