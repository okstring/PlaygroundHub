//
//  TopicsCollectionViewCell.swift
//  GithubApp
//
//  Created by Issac on 2021/09/29.
//

import UIKit

class TopicsCollectionViewCell: UICollectionViewCell {
    private let topicLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .lightGray
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setSubviews()
    }
    
    func configure(topic: String) {
        topicLabel.text = topic
        setConstraints(text: topic)
        setBorder()
    }
    
    private func setBorder() {
        topicLabel.clipsToBounds = true
        topicLabel.layer.cornerRadius = contentView.frame.height / 4
    }
    
    private func setSubviews() {
        addSubview(topicLabel)
    }
    
    private func setConstraints(text: String) {
        topicLabel.snp.makeConstraints({
            $0.height.equalTo(25)
            $0.width.equalTo(50)
        })
    }
}
