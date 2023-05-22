//
//  ChangePasswordViewCommands.swift
//  Refactoring
//
//  Created by Roberts Kursitis on 22/05/2023.
//

import Foundation

protocol ChangePasswordViewCommands: AnyObject {
    func hideActivityIndicator()
    func showActivityIndicator()
    func dismissModal()
    func showAlert(message: String, action: @escaping () -> Void)
    func updateInputFocus(_ inputFocus: InputFocus)
}

enum InputFocus {
    case noKeyboard
    case oldPassword
    case newPassword
    case confirmPassword
}
