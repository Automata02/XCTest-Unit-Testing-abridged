//
//  ChangePasswordViewModel.swift
//  Refactoring
//
//  Created by Roberts Kursitis on 11/05/2023.
//

import Foundation

struct ChangePasswordViewModel {
    let okButtonLabel: String
    
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
