//
//  UU.swift
//  ShareTogether
//
//  Created by littlema on 2019/10/6.
//  Copyright © 2019 littema. All rights reserved.
//

import AuthenticationServices

struct CredentialUser {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }

}
