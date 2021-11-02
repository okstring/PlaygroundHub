//
//  OAuthViewController.swift
//  GithubInsight
//
//  Created by Issac on 2021/10/18.
//

import UIKit
import RxSwift
import RxCocoa
import Lottie

class OAuthViewController: UIViewController, ViewModelBindableType {
    var viewModel: OAuthViewModel!
    
    private let loginButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        
        let logo = UIImage(named: "githubLogo")
        button.setImage(logo, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.backgroundColor = .black
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitle("Log in With Github", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.height / 10
        return button
    }()
    
    private let welcomeView: UIStackView = {
        let firstLabel = UILabel()
        firstLabel.font = .systemFont(ofSize: 32, weight: .bold)
        firstLabel.text = "Hello,"
        
        let secondLabel = UILabel()
        secondLabel.font = .systemFont(ofSize: 32, weight: .bold)
        secondLabel.text = "Wellcome Back!"
        
        let stackView = UIStackView(arrangedSubviews: [firstLabel, secondLabel])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var animationView: AnimationView = {
        let animationView = AnimationView(name: "GithubNeonImage")
        
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        
        return animationView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeUI()
    }
    
    func makeUI() {
        view.addSubview(welcomeView)
        view.addSubview(loginButton)
        
        welcomeView.snp.makeConstraints({
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(72)
        })
        
        let buttonHeight: CGFloat = 48.0
        
        loginButton.snp.makeConstraints({
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(72)
            $0.height.equalTo(buttonHeight)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(72)
        })
        
        let logoImage = loginButton.imageView?.image?.resize(newWidth: buttonHeight / 1.4, newHeight: buttonHeight / 1.4)
        loginButton.setImage(logoImage, for: .normal)
        
        view.addSubview(animationView)
        animationView.play()
        
        animationView.snp.makeConstraints({
            let width = view.bounds.width
            let scale = width / animationView.bounds.width
            let height = animationView.bounds.height * scale
            
            $0.center.equalTo(view.center)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        })
        
    }
    
    func bindViewModel() {
        let input = OAuthViewModel.Input(oAuthLoginTrigger: loginButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)
    }
    
}
