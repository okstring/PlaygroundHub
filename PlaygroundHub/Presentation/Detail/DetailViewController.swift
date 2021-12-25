//
//  DetailViewController.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2021/12/25.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, ViewModelBindableType {
    var viewModel: DetailViewModel!
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "okstring")
        return imageView
    }()
    
    private let repositoryName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let owner: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        let starImage = UIImage(systemName: "star")
        let selectedStarImage = UIImage(systemName: "star.fill")
        button.setImage(starImage, for: .normal)
        button.setImage(selectedStarImage, for: .selected)
        button.contentMode = .scaleAspectFit
        button.tintColor = .orange
        return button
    }()
    
    private let starCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let nameStackView = UIStackView(arrangedSubviews: [repositoryName, owner])
        nameStackView.axis = .vertical
        
        let starStackView = UIStackView(arrangedSubviews: [starButton, starCountLabel])
        starStackView.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nameStackView, starStackView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let webView: WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        
        if let url = URL(string: "https://github.com/okstring") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func bindViewModel() {
        
    }
    
    func makeUI() {
        headerView.addSubview(infoStackView)
        view.addSubview(headerView)
        view.addSubview(webView)
        
        owner.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        starCountLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        
        profileImageView.snp.makeConstraints({
            $0.width.height.equalTo(40)
        })
        
        starButton.snp.makeConstraints({
            $0.width.equalTo(40)
        })
        
        headerView.snp.makeConstraints({
            $0.height.equalTo(96).priority(750)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        
        infoStackView.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(16)
        })
        
        webView.snp.makeConstraints({
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view)
        })
    }
}
