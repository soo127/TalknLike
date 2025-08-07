//
//  SearchUserViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/6/25.
//

import UIKit

final class SearchUserViewController: UIViewController {
    
    let searchUserView = SearchUserView()
    
    override func loadView() {
        view = searchUserView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
