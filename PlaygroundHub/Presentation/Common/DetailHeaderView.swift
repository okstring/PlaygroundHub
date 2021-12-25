//
//  DetailHeaderView.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2021/12/25.
//

import UIKit
import RxSwift

class DetailHeaderView: UIView {
    let disposeBag = DisposeBag()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        imageView.image = UIImage()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        makeUI()
    }
    
    func configure(item: Repository) {
        self.repositoryName.text = item.fullTitle
        self.owner.text = item.loginName
        self.starCountLabel.text = item.starCount.abbreviateStarCount
        bind(item: item)
    }
    
    func bind(item: Repository) {
        ImageLoader.load(from: item.profileImageURL)
            .drive(profileImageView.rx.image)
            .disposed(by: disposeBag)
    }
    
    private func makeUI() {
        self.addSubview(infoStackView)
        
        owner.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        starCountLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .vertical)
        
        profileImageView.snp.makeConstraints({
            $0.width.height.equalTo(40)
        })
        
        starButton.snp.makeConstraints({
            $0.width.equalTo(40)
        })
        
        infoStackView.snp.makeConstraints({
            $0.edges.equalToSuperview().inset(16)
        })
    }
}
