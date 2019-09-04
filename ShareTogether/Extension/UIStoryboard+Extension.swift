//
//  UIStoryboard+Extension.swift
//  ShareTogether
//
//  Created by littlema on 2019/8/30.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

private struct StoryboardCategory {
    
    static let home = "Home"
    
    static let expense = "Expense"
    
    static let group = "Group"
    
    static let search = "Search"

}

extension UIStoryboard {
    
    static var home: UIStoryboard { return getStoryboard(name: StoryboardCategory.home) }
    
    static var expense: UIStoryboard { return getStoryboard(name: StoryboardCategory.expense) }
    
    static var group: UIStoryboard { return getStoryboard(name: StoryboardCategory.group) }
    
    static var search: UIStoryboard { return getStoryboard(name: StoryboardCategory.search) }
    
    private static func getStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
