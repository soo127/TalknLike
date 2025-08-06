//
//  FollowView.swift
//  TalknLike
//
//  Created by 이상수 on 8/6/25.
//

import UIKit

final class FollowView: UIView {

    private let menus = ["팔로워", "팔로잉"]
    private let underlineView = UIView()
    let segmentedControl = UISegmentedControl()
    let tableView = UITableView()
    private lazy var lineConstraint: NSLayoutConstraint = {
        let constraint = underlineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor)
        constraint.isActive = true
        return constraint
    }()
    var segmentChangedHandler: ((Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupSegmentedControl()
        setupUnderlineView()
        setupUI()
        setupActions()
    }

}

extension FollowView {
    
    private func setupSegmentedControl() {
        for (idx, menu) in menus.enumerated() {
            segmentedControl.insertSegment(withTitle: menu, at: idx, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.selectedSegmentTintColor = .clear
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ], for: .normal)
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ], for: .selected)
    }

    private func setupUnderlineView() {
        underlineView.backgroundColor = .systemBlue
    }
    
    private func setupUI() {
        addSubview(segmentedControl)
        addSubview(underlineView)
        addSubview(tableView)
        
        segmentedControl.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16),
            height: 40
        )
        
        underlineView.anchor(
            top: segmentedControl.bottomAnchor,
            height: 3
        )
        underlineView.widthAnchor.constraint(
            equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(menus.count)
        ).isActive = true
        
        tableView.anchor(
            top: underlineView.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        )
    }

    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
    }

    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        moveUnderline(to: index)
        segmentChangedHandler?(index)
    }

    func moveUnderline(to index: Int) {
        let segmentWidth = segmentedControl.frame.width / CGFloat(menus.count)
        let newLeading = segmentWidth * CGFloat(index)
        lineConstraint.constant = newLeading
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }

}

extension FollowView {
    
    var selectedTab: Int {
        segmentedControl.selectedSegmentIndex
    }
    
}
