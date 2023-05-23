//
//  ChangePasswordPresenter.swift
//  Refactoring
//
//  Created by Roberts Kursitis on 22/05/2023.
//

import Foundation

class ChangePasswordPresenter {
    private unowned var view: ChangePasswordViewCommands!
    private var viewModel: ChangePasswordViewModel
    private let securityToken: String
    private let passwordChanger: PasswordChanging
    
    init(view: ChangePasswordViewCommands,
         viewModel: ChangePasswordViewModel,
         securityToken: String,
         passwordChanger: PasswordChanging) {
        self.view = view
        self.viewModel = viewModel
        self.securityToken = securityToken
        self.passwordChanger = passwordChanger
    }
    
    func validateInputs(passwordInputs: PasswordInputs) -> Bool {
        if passwordInputs.isOldPasswordEmpty {
            view.updateInputFocus(.oldPassword)
            return false
        }
        
        if passwordInputs.isNewPasswordEmpty {
            view.showAlert(message: viewModel.message(.enterNew)) { [weak self] in
                self?.view.updateInputFocus(.newPassword)
            }
            return false
        }
        
        if passwordInputs.isNewPasswordTooShort {
            view.showAlert(message: viewModel.message(.tooShort)) { [weak self] in
                self?.clearNewPasswordFields()
            }
            return false
        }
        
        if passwordInputs.isConfirmPasswordMismatched {
            view.showAlert(message: viewModel.message(.mismatch)) { [weak self] in
                self?.clearNewPasswordFields()
            }
            return false
        }
        return true
    }
    
    func clearNewPasswordFields() {
        view.clearNewPasswordFields()
        view.updateInputFocus(.newPassword)
    }
    
    func handleSuccess() {
        view.hideActivityIndicator()
        view.showAlert(message: viewModel.successMessage) { [weak self] in
            self?.view.dismissModal()
        }
    }
    
    func handleFailure(_ message: String) {
        view.hideActivityIndicator()
        view.showAlert(message: message) { [weak self] in
            self?.startOver()
        }
    }
    
    func attemptToChangePassword(passwordInputs: PasswordInputs) {
        passwordChanger.change(
            securityToken: securityToken,
            oldPassword: passwordInputs.oldPassword,
            newPassword: passwordInputs.newPassword,
            onSuccess: { [weak self] in
                self?.handleSuccess()
            },
            onFailure: { [weak self] message in
                self?.handleFailure(message)
            }
        )
    }
    
    private func startOver() {
        view.clearAllPasswordFields()
        view.updateInputFocus(.oldPassword)
        view.hideBlurView()
        view.setCancelButtonEnabled(true)
    }
}
