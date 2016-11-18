//
//  EmptyStateView.swift
//  CUMTDApp
//
//  Created by Faisal Abu Jabal on 11/18/16.
//  Copyright © 2016 Faisal Abu Jabal. All rights reserved.
//

import UIKit

class EmptyState {
    static func getEmptyStateView(reason emptyStateText: String) -> UIView {
        let emptyStateView = UIView()
        emptyStateView.sizeToFit()
        let emptyStateText = emptyStateText
        let emptyStateLabel = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 200))
        emptyStateLabel.text = emptyStateText
        emptyStateLabel.textColor = UIColor.black
        emptyStateLabel.textAlignment = .center
        emptyStateView.addSubview(emptyStateLabel)
        return emptyStateView
    }
}
