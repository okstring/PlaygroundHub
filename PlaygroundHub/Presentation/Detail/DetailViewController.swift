//
//  DetailViewController.swift
//  PlaygroundHub
//
//  Created by Ok Hyeon Kim on 2021/12/25.
//

import UIKit
import WebKit

class DetailViewController: AnimationBaseViewController, ViewModelBindableType {
    var viewModel: DetailViewModel!
    
    private let headerView: DetailHeaderView = {
        let view = DetailHeaderView()
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
    }
    
    func bindViewModel() {
        let appearTrigger = rx.viewWillAppear
            .asObservable()
        
        let input = DetailViewModel.Input(appearTrigger: appearTrigger)
        
        let output = viewModel.transform(input: input)
        
        output.repository
            .drive(onNext: { [weak self] repository in
                self?.headerView.changeStarred = self?.starredToast.onNext
                self?.headerView.configure(item: repository)
                
                if let url = URL(string: repository.htmlURL) {
                    let request = URLRequest(url: url)
                    self?.webView.load(request)
                }
                
            }).disposed(by: rx.disposeBag)
    }
    
    func makeUI() {
        view.addSubview(headerView)
        view.addSubview(webView)
        
        headerView.snp.makeConstraints({
            $0.height.equalTo(96).priority(750)
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        })
        
        webView.snp.makeConstraints({
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view)
        })
    }
}
