//
//  PasswordChanger.swift
//  Refactoring
//
//  Created by Roberts Kursitis on 06/04/2023.
//

import Foundation


protocol PasswordChanging {
    func change(securityToken: String,
                oldPassword: String,
                newPassword: String,
                onSuccess: @escaping () -> Void,
                onFailure: @escaping (String) -> Void)
}

final class PasswordChanger: PasswordChanging {
    private static var pretendToSucceed = false
    private var successOrFailureTimer: SuccessOrFailureTimer?
    
    /*
     The change() method takes a security token, the old password, and a new password.
     Upon success, it calls the onSuccess closure.
     Upon failure, it calls the onFailure closure with a failure message.
     */
    func change(securityToken: String,
                oldPassword: String,
                newPassword: String,
                onSuccess: @escaping () -> Void,
                onFailure: @escaping (String) -> Void) {
        print("Initiate Change Password:")
        print("securityToken = \(securityToken)")
        print("oldPassword = \(oldPassword)")
        print("newPassword = \(newPassword)")
        successOrFailureTimer = SuccessOrFailureTimer(onSucess: onSuccess, onFailure: onFailure, timer: Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { [weak self] _ in self?.callSuccessOrFailure() }
        )
    }
    
    /*
     The helper method callSuccessOrFailure() alternates between failure and success.
     The pretendToSucceed flag is a static property, so it persists across PasswordChanger instances.
     The change() method calls it after a 1-second timer to simulate net- work lag.
     */
    private func callSuccessOrFailure() {
        if PasswordChanger.pretendToSucceed {
            successOrFailureTimer?.onSucess()
        } else {
            successOrFailureTimer?.onFailure("Sorry, something went wrong.")
        }
        PasswordChanger.pretendToSucceed.toggle()
        successOrFailureTimer?.timer.invalidate()
        successOrFailureTimer = nil
    }
    
    private struct SuccessOrFailureTimer {
        let onSucess: () -> Void
        let onFailure: (String) -> Void
        let timer: Timer
    }
}
