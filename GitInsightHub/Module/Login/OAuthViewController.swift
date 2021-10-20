//
//  OAuthViewController.swift
//  GithubInsight
//
//  Created by Issac on 2021/10/18.
//

import UIKit
import RxSwift
import RxCocoa

class OAuthViewController: UIViewController, ViewModelBindableType {
    var viewModel: OAuthViewModel!
    
    private let loginButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        button.setTitle("깃허브 로그인", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.height / 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeUI()
    }
    
    private func makeUI() {
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints({
            $0.width.equalTo(150)
            $0.height.equalTo(50)
            $0.center.equalToSuperview()
        })
    }
    
    func bindViewModel() {
        let input = OAuthViewModel.Input(oAuthLoginTrigger: loginButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
        
    }
    
}
