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
    
    static let main = "Main"
    
    static let expense = "Expense"
    
    static let group = "Group"

}

extension UIStoryboard {
    
    static var main: UIStoryboard { return getStoryboard(name: StoryboardCategory.main) }
    
    static var expense: UIStoryboard { return getStoryboard(name: StoryboardCategory.expense) }
    
    static var group: UIStoryboard { return getStoryboard(name: StoryboardCategory.group) }
    
    private static func getStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
