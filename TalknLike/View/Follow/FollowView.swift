//
//  FollowView.swift
//  TalknLike
//
//  Created by 이상수 on 8/6/25.
//

import UIKit

protocol FollowViewDelegate: AnyObject {
    func didSelectSegment(at index: Int)
}

final class FollowView: UIView {

    weak var delegate: FollowViewDelegate?
    
    private let underlineView = UIView()
    private let segmentedControl = UISegmentedControl()
    let tableView = UITableView()
    
    private lazy var lineConstraint: NSLayoutConstraint = {
        let constraint = underlineView.leadingAnchor.constraint(equalTo: segmentedControl.leadingAnchor)
        constraint.isActive = true
        return constraint
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupSubviews()
        setupActions()
        setupLayout()
    }

}

private extension FollowView {
    
    private func setupSubviews() {
        backgroundColor = .systemBackground
        setupSegmentedControl()
        setupUnderlineView()
        setupTableView()
    }
    
    private func setupSegmentedControl() {
        addSubview(segmentedControl)
        FollowTab.allCases.forEach { tab in
            segmentedControl.insertSegment(withTitle: tab.titleWithCount(0), at: tab.rawValue, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        
        // Appearance
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
        addSubview(underlineView)
        underlineView.backgroundColor = .systemBlue
    }
    
    private func setupTableView() {
        addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
}

extension FollowView {
    
    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
    }
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        moveUnderline(to: index)
        delegate?.didSelectSegment(at: index)
    }
    
    func moveUnderline(to index: Int) {
        let segmentWidth = segmentedControl.frame.width / CGFloat(FollowTab.allCases.count)
        let newLeading = segmentWidth * CGFloat(index)
        lineConstraint.constant = newLeading
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
    
}

extension FollowView {
    
    private func setupLayout() {
        layoutSegmentControl()
        layoutUnderlineView()
        layoutTableView()
    }
    
    private func layoutSegmentControl() {
        segmentedControl.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16),
            height: 40
        )
    }
    
    private func layoutUnderlineView() {
        underlineView.anchor(
            top: segmentedControl.bottomAnchor,
            height: 3
        )
        underlineView.widthAnchor.constraint(
            equalTo: segmentedControl.widthAnchor,
            multiplier: 1.0 / CGFloat(FollowTab.allCases.count)
        ).isActive = true
    }
    
    private func layoutTableView() {
        tableView.anchor(
            top: underlineView.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor,
            padding: UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        )
    }
    
}

extension FollowView {
    
    var selectedTab: FollowTab {
        FollowTab(rawValue: segmentedControl.selectedSegmentIndex) ?? .followers
    }
    
    func updateFollowerCount(_ count: Int) {
        segmentedControl.setTitle(FollowTab.followers.titleWithCount(count), forSegmentAt: FollowTab.followers.rawValue)
    }
    
    func updateFollowingCount(_ count: Int) {
        segmentedControl.setTitle(FollowTab.followings.titleWithCount(count), forSegmentAt: FollowTab.followings.rawValue)
    }
    
}

extension FollowView {
    
    enum FollowTab: Int, CaseIterable {
        case followers = 0
        case followings = 1
        
        var title: String {
            switch self {
            case .followers: return "팔로워"
            case .followings: return "팔로잉"
            }
        }
        
        func titleWithCount(_ count: Int) -> String {
            return "\(title) \(count)"
        }
    }
    
}
