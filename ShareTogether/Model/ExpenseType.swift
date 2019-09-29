//
//  Catgory.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/15.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

enum ExpenseType: Int {
    case null = 0
    case car
    case subway
    case bicycle
    case bus
    case gasStation
    case parking
    case hotel
    case gift
    case restaurant
    case wine
    
    // swiftlint:disable cyclomatic_complexity
    func getImage(color: UIColor) -> UIImage {
            
            let size = 40
            
            switch self {
    
            case .null:
                return .getIcon(code: "logo-usd", color: color, size: size)
            case .car:
                return .getIcon(code: "ios-car", color: color, size: size)
            case .subway:
                return .getIcon(code: "ios-subway", color: color, size: size)
            case .bicycle:
                return .getIcon(code: "ios-bicycle", color: color, size: size)
            case .bus:
                return .getIcon(code: "ios-bus", color: color, size: size)
            case .gasStation:
                return .getIcon(from: .materialIcon, code: "local.gas.station", color: color, size: size)
            case .parking:
                return .getIcon(from: .materialIcon, code: "local.parking", color: color, size: size)
            case .hotel:
                return .getIcon(code: "ios-bed", color: color, size: size)
            case .gift:
                return .getIcon(code: "ios-gift", color: color, size: size)
            case .restaurant:
                return .getIcon(code: "ios-restaurant", color: color, size: size)
            case .wine:
                return .getIcon(code: "ios-wine", color: color, size: size)
            }
        
    }
    // swiftlint:enable cyclomatic_complexity
}
