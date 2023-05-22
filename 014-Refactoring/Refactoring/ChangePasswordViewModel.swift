//
//  ChangePasswordViewModel.swift
//  Refactoring
//
//  Created by Roberts Kursitis on 11/05/2023.
//

import Foundation

struct ChangePasswordViewModel {
    let okButtonLabel: String
    
    let title: String = "Change Password"
    let oldPasswordPlaceholder: String = "Current Password"
    let newPasswordPlaceholder: String = "New Password"
    let confirmPasswordPlaceholder: String = "Confirm New Password"
    let submitButtonLabel: String = "Submit"
    
    var oldPassword: String = ""
    var newPassword: String = ""
    var confirmPassword: String = ""
    
    var isCancelButtonEnabled: Bool = true
    var isBlurViewShowing: Bool = false
    var isActivityIndicatorShowing: Bool = false
    
    let successMessage: String = "Your password has been successfully changed."
    
    var inputFocus: InputFocus = .noKeyboard
    
    enum InputFocus {
        case noKeyboard
        case oldPassword
        case newPassword
        case confirmPassword
    }

    func message(_ type: Message) -> String {
        type.message
    }

    enum Message: String, CaseIterable {
        case enterNew, tooShort, mismatch

        var message: String {
            switch self {
            case .enterNew:
                return "Please enter a new password."
            case .tooShort:
                return "The new password should have at least 6 characters."
            case .mismatch:
                return "The new password and the confirmation password don’t match. Please try again."
            }
        }
    }
}
