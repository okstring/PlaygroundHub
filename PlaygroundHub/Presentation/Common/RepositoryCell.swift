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
        stackView.spacing = 4
        return stackView
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    private let repositoryDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let topics: TopicLabel = {
        let label = TopicLabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .darkNavy
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
        view.backgroundColor = .white
        view.addSubview(mainStackView)
        
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.10
        view.layer.shadowRadius = 3.5
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        
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
        disposeBag = DisposeBag()
    }
    
    func configure(item: Repository) {
        repositoryName.text = item.title
        owner.text = item.loginName
        
        repositoryDescription.text = item.repositoryDescription == "" ? "" : item.repositoryDescription
        topics.setAttributenTagString(arr: item.topics)
        
        forkCount.text = "\(item.forkCount)"
        language.text = item.language
        
        bind(item: item)
    }
    
    private func bind(item: Repository) {
        let starred = BehaviorSubject<Bool>(value: false)
        let starCount = BehaviorSubject<Int>(value: item.starCount)
        let countToggle = PublishSubject<Bool>()
        
        StarredLoader.starred(endpoint: .isStarred(name: item.loginName, repo: item.title))
            .asObservable()
            .subscribe(onNext: starred.onNext)
            .disposed(by: disposeBag)
        
        let tabResult = starButton.rx.tap
            .withLatestFrom(starred) { $1 }
            .debug()
            .flatMap{ starSelected -> Single<Bool> in
                if starSelected == true {
                    return StarredLoader.starred(endpoint: .deleteStarred(name: item.loginName, repo: item.title))
                } else {
                    return StarredLoader.starred(endpoint: .putStarred(name: item.loginName, repo: item.title))
                }
            }.filter{ $0 }
            .withLatestFrom(starred)
            .map({ !$0 })
            .share()
        
        tabResult
            .bind(to: starred)
            .disposed(by: disposeBag)
        
        tabResult
            .bind(to: countToggle)
            .disposed(by: disposeBag)
        
        starCount
            .map({ $0.abbreviateStarCount })
            .bind(to: starCountLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        countToggle
            .withLatestFrom(starCount){ ($0, $1) }
            .map{ $0 ? $1 + 1 : $1 - 1 }
            .do(onNext: starCount.onNext)
            .map({ $0.abbreviateStarCount })
            .bind(to: starCountLabel.rx.text)
            .disposed(by: rx.disposeBag)
        
        starred
            .bind(to: starButton.rx.isSelected)
            .disposed(by: rx.disposeBag)
        
        ImageLoader.load(from: item.profileImageURL)
            .drive(profileImageView.rx.image)
            .disposed(by: rx.disposeBag)
    }
    
    private func makeUI() {
        contentView.addSubview(subContentView)
        
        owner.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        topics.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        starCountLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        
        profileImageView.snp.makeConstraints({
            $0.width.height.equalTo(40)
        })
        
        starButton.snp.makeConstraints({
            $0.width.equalTo(40)
        })
        
        infoStackView.snp.makeConstraints({
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
        
        bottomInfoStackView.snp.makeConstraints({
            $0.leading.trailing.equalTo(mainStackView)
        })
        
        separatorView.snp.makeConstraints({
            $0.width.equalTo(mainStackView).multipliedBy(0.9)
            $0.height.equalTo(1)
        })
        
        repositoryDescription.snp.makeConstraints({
            $0.leading.trailing.equalTo(mainStackView)
            $0.height.greaterThanOrEqualTo(0).priority(750)
        })
        
        topics.snp.makeConstraints({
            $0.leading.trailing.equalTo(mainStackView)
            $0.height.greaterThanOrEqualTo(0).priority(750)
        })
        
        subContentView.snp.makeConstraints({
            $0.edges.equalTo(contentView).inset(16)
        })
        
        mainStackView.snp.makeConstraints({
            $0.edges.equalTo(subContentView).inset(16)
        })
    }
}
