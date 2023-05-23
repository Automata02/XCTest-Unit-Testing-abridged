//
//  PasswordInputs.swift
//  Refactoring
//
//  Created by Roberts Kursitis on 22/05/2023.
//

import Foundation

struct PasswordInputs {
    var oldPassword: String
    var newPassword: String
    var confirmPassword:String
//    
    var isOldPasswordEmpty: Bool { oldPassword.isEmpty }
    var isNewPasswordEmpty: Bool { newPassword.isEmpty }
    var isNewPasswordTooShort: Bool { newPassword.count < 6 }
    var isConfirmPasswordMismatched: Bool { newPassword != confirmPassword }
}
