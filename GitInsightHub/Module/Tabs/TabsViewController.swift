//
//  TabsViewController.swift
//  GitInsightHub
//
//  Created by Issac on 2021/10/19.
//

import UIKit

class TabsViewController: UITabBarController, ViewModelBindableType {
    var viewModel: TabsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
