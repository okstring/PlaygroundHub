//
//  RepositoryCell.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/24.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class RepositoryCell: UITableViewCell {
    private var disposeBag = DisposeBag()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let repositoryName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
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
        button.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
        return button
    }()
    
    private let starCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    private lazy var infoStackView: UIStackView = {
        let nameStackView = UIStackView(arrangedSubviews: [repositoryName, owner])
        nameStackView.axis = .vertical
        
        let starStackView = UIStackView(arrangedSubviews: [starButton, starCount])
        starStackView.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, nameStackView, starStackView])
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    private let repositoryDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .vertical)
        return label
    }()
    
    private let topics: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let forkImageView: UIImageView = {
        let starImage = UIImage(systemName: "person.2.fill")
        let imageView = UIImageView(image: starImage)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let forkCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let languageImageView: UIImageView = {
        let starImage = UIImage(systemName: "character.bubble")
        let imageView = UIImageView(image: starImage)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let language: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var bottomInfoStackView: UIStackView = {
        let contributorStackView = UIStackView(arrangedSubviews: [forkImageView, forkCount])
        contributorStackView.axis = .horizontal
        contributorStackView.spacing = 4
        contributorStackView.setContentHuggingPriority(UILayoutPriority(rawValue: 250), for: .horizontal)
        
        let languageStackView = UIStackView(arrangedSubviews: [languageImageView, language])
        languageStackView.axis = .horizontal
        languageStackView.spacing = 4
        
        let stackView = UIStackView(arrangedSubviews: [contributorStackView, languageStackView])
        stackView.axis = .horizontal
        stackView.spacing = 16
        
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoStackView, separatorView, repositoryDescription, topics, bottomInfoStackView])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var subContentView: UIView = {
        let view = UIView()
        view.addSubview(mainStackView)
        
        //MARK: - shadow
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        repositoryDescription.isHidden = false
        topics.isHidden = false
        disposeBag = DisposeBag()
    }
    
    func configure(item: Repository) {
        repositoryName.text = item.title
        owner.text = item.loginName
        
        starCount.text = item.abbreviateStarCount
        
        if item.repositoryDescription == "" {
            repositoryDescription.isHidden = true
        } else {
            repositoryDescription.text = item.repositoryDescription
        }
        
        if item.topics.reduce("", +) == "" {
            topics.isHidden = true
        } else {
            topics.text = item.topics.reduce("", +)
        }
        
        forkCount.text = "\(item.forkCount)"
        language.text = item.language
        
        bind(item: item)
    }
    
    private func bind(item: Repository) {
        StarredLoader.starred(endpoint: .isStarred(name: item.loginName, repo: item.title))
            .asObservable()
            .bind(to: starButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        starButton.rx.tap
            .withLatestFrom(Observable.just(starButton.isSelected)) { $1 }
            .flatMap{ isSelected -> Single<Bool> in
                if isSelected == true {
                    return StarredLoader.starred(endpoint: .deleteStarred(name: item.loginName, repo: item.title))
                } else {
                    return StarredLoader.starred(endpoint: .putStarred(name: item.loginName, repo: item.title))
                }
            }.subscribe(onNext: { [weak self] result in
                if result {
                    guard let self = self else {
                        return
                    }
                    self.starButton.isSelected = !self.starButton.isSelected
                }
            }).disposed(by: disposeBag)
        
        ImageLoader.load(from: item.profileImageURL)
            .drive(profileImageView.rx.image)
            .disposed(by: rx.disposeBag)
    }
    
    private func makeUI() {
        contentView.addSubview(subContentView)

        subContentView.snp.makeConstraints({
            $0.edges.equalTo(contentView).inset(16)
        })
        
        mainStackView.snp.makeConstraints({
            $0.edges.equalTo(subContentView).inset(8)
        })
        
        profileImageView.snp.makeConstraints({
            $0.width.height.equalTo(40)
        })
        
        starButton.snp.makeConstraints({
            $0.width.equalTo(40)
        })
        
        infoStackView.snp.makeConstraints({
            $0.leading.trailing.equalTo(mainStackView)
        })
        
        separatorView.snp.makeConstraints({
            $0.width.equalTo(mainStackView).multipliedBy(0.9)
            $0.height.equalTo(1)
        })
        
        repositoryDescription.snp.makeConstraints({
            $0.leading.trailing.equalTo(mainStackView)
        })
        
        topics.snp.makeConstraints({
            $0.leading.trailing.equalTo(mainStackView)
        })
        
        bottomInfoStackView.snp.makeConstraints({
            $0.leading.trailing.equalTo(mainStackView)
        })
        
        forkImageView.snp.makeConstraints({
            $0.width.height.equalTo(17)
        })
        
        forkCount.snp.makeConstraints({
            $0.width.equalTo(40)
        })
        
        languageImageView.snp.makeConstraints({
            $0.width.height.equalTo(17)
        })
    }
}
