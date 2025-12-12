//
//  UITableView+Extension.swift
//  TalknLike
//
//  Created by 이상수 on 8/28/25.
//

import UIKit

extension UITableView {
    
    func showEmptyState(message: String) {
        let emptyLabel = UILabel()
        emptyLabel.text = message
        emptyLabel.textColor = .systemGray
        emptyLabel.textAlignment = .center
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.numberOfLines = 0
        backgroundView = emptyLabel
    }

    func hideEmptyState() {
        backgroundView = nil
    }
    
}

extension UITableViewCell {
    
    static var identifier : String {
        return String(describing: self)
    }

}
