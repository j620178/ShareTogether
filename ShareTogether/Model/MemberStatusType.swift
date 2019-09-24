//
//  MemberStatusType.swift
//  ShareTogether
//
//  Created by littlema on 2019/9/17.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation

enum MemberStatusType: Int {
    case builder = 0
    case willInvite = 1
    case inviting = 2
    case joined = 3
    case quit = 4
    case archive = 5
    
    var getString: String {
        switch self {

        case .builder:
            return "建立者"
        case .willInvite:
            return "即將邀請"
        case .inviting:
            return "邀請中"
        case .joined:
            return "已加入"
        case .quit:
            return "已退出"
        case .archive:
            return "已封存"
        }
    }
    
}
