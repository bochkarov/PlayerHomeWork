//
//  Validators.swift
//  AuthApp
//
//  Created by Алексей Пархоменко on 03.05.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation

class Validators {
    
    static func isFilled(firstname: String?, lastname: String?, email: String?, password: String?) -> Bool {
        guard let firstname = firstname,
            let lastname = lastname,
            let email = email,
            let password = password,
            firstname != "",
            lastname != "",
            email != "",
            password != "" else { return false }
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
