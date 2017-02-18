//
//  UIBarButtonItem+Hidden.swift
//  FormToolbar
//
//  Created by Suguru Kishimoto on 2/18/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation
import UIKit

/// Hidden UIBarButtonSystemItem "<" ">" "^" "v"
enum UIBarButtonHiddenItem: Int {
    case prev = 101
    case next = 102
    case up = 103
    case down = 104
    
    var systemItem: UIBarButtonSystemItem  {
        return UIBarButtonSystemItem(rawValue: rawValue)!
    }
}

extension UIBarButtonItem {
    convenience init(barButtonHiddenItem item: UIBarButtonHiddenItem, target: AnyObject?, action: Selector) {
        self.init(barButtonSystemItem: item.systemItem, target:target, action: action)
    }
}
