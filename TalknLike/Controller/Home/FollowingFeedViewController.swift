//
//  FollowingFeedViewController.swift
//  TalknLike
//
//  Created by 이상수 on 8/13/25.
//

import UIKit

final class FollowingFeedViewController: UIViewController {
    
    private let followView = FollowView()
    
    override func loadView() {
        view = followView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
