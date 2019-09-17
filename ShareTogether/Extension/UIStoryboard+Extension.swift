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
    
    static let login = "Login"
    
    static let main = "Main"
    
    static let home = "Home"
    
    static let expense = "Expense"
    
    static let group = "Group"
    
    static let activity = "Activity"
    
    static let menu = "Menu"

}

extension UIStoryboard {
    
    static var main: UIStoryboard { return getStoryboard(name: StoryboardCategory.main) }
    
    static var login: UIStoryboard { return getStoryboard(name: StoryboardCategory.login) }
    
    static var home: UIStoryboard { return getStoryboard(name: StoryboardCategory.home) }
    
    static var expense: UIStoryboard { return getStoryboard(name: StoryboardCategory.expense) }
    
    static var group: UIStoryboard { return getStoryboard(name: StoryboardCategory.group) }
    
    static var activity: UIStoryboard { return getStoryboard(name: StoryboardCategory.activity) }
    
    static var menu: UIStoryboard { return getStoryboard(name: StoryboardCategory.menu) }
    
    private static func getStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
