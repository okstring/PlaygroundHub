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
    private let topicsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 2
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 75, height: 25)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        collectionView.backgroundColor = .systemGray6
        collectionView.isScrollEnabled = false
        
        collectionView.register(TopicsCollectionViewCell.self, forCellWithReuseIdentifier: TopicsCollectionViewCell.className)
        
        return collectionView
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let repositoryDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    private let starCount: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let language: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let owner: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let starImageView: UIImageView = {
        let starImage = UIImage(systemName: "star.fill")
        let imageView = UIImageView(image: starImage)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .top
        return stackView
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
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        registerCollectionView()
        setStackView()
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerCollectionView()
        setStackView()
        setSubviews()
        setConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        topicsCollectionView.delegate = nil
        topicsCollectionView.dataSource = nil
        disposeBag = DisposeBag()
    }
    
    func configure(item: Repository) {
        name.text = item.fullTitle
        repositoryDescription.text = item.repositoryDescription
        starCount.text = item.abbreviateStarCount
        language.text = item.language
        owner.attributedText = makeAttributedString(normal: "owner: ", bold: item.loginName)
        bind(item: item)
    }
    
    private func bind(item: Repository) {
        StarredLoader.starred(endpoint: .isStarred(name: item.loginName, repo: item.title))
            .asObservable()
            .bind(to: starButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        bindTopicCollectionItems(topics: item.topics)
        
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
            
    }
    
    private func bindTopicCollectionItems(topics: [String]) {
        Observable.just(topics)
            .bind(to: topicsCollectionView.rx.items) { collectionView, row, topic in
                let indexPath = IndexPath(row: row, section: 0)
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopicsCollectionViewCell.className, for: indexPath) as? TopicsCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.configure(topic: topic)
                return cell
            }.disposed(by: disposeBag)
    }
    
    private func registerCollectionView()  {
        topicsCollectionView.register(TopicsCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: TopicsCollectionViewCell.className)
    }
    
    private func setStackView() {
        let starStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                starImageView,
                starCount
            ])
            stackView.axis = .horizontal
            stackView.spacing = 0
            
            return stackView
        }()
        
        let infoStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [
                starStackView,
                language,
                owner
            ])
            stackView.spacing = 8
            stackView.axis = .horizontal
            return stackView
        }()
        
        rightStackView.addArrangedSubview(name)
        rightStackView.addArrangedSubview(repositoryDescription)
        rightStackView.addArrangedSubview(topicsCollectionView)
        rightStackView.addArrangedSubview(infoStackView)
        
        mainStackView.addSubview(starButton)
        mainStackView.addSubview(rightStackView)
    }
    
    private func setSubviews() {
        contentView.addSubview(mainStackView)
    }
    
    private func setConstraints() {
        mainStackView.snp.makeConstraints({
            $0.edges.equalTo(contentView).inset(16)
        })
        
        rightStackView.snp.makeConstraints({
            $0.leading.equalTo(starButton.snp.trailing).offset(8)
            $0.trailing.top.bottom.equalTo(mainStackView)
        })

        starButton.snp.makeConstraints({
            $0.leading.top.equalTo(mainStackView)
            $0.width.height.equalTo(20)
        })
        
        topicsCollectionView.snp.makeConstraints({
            $0.leading.trailing.equalTo(rightStackView)
            $0.height.equalTo(100)
        })
    }
}
