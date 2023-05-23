//
//  ChangePasswordViewController.swift
//  Refactoring
//
//  Created by Roberts Kursitis on 06/04/2023.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    private lazy var presenter = ChangePasswordPresenter(view: self,
                                                         viewModel: viewModel,
                                                         securityToken: securityToken,
                                                         passwordChanger: passwordChanger)
    /*
     We have a View Commands protocol to which the view conforms to.
     The view controller has a presenter that points back to the view controller through the protocol.
     */
    
    @IBOutlet private(set) var cancelBarButton: UIBarButtonItem!
    @IBOutlet private(set) var oldPasswordTextField: UITextField!
    @IBOutlet private(set) var newPasswordTextField: UITextField!
    @IBOutlet private(set) var confirmPasswordTextField: UITextField!
    @IBOutlet private(set) var submitButton: UIButton!
    @IBOutlet private(set) var navigationBar: UINavigationBar!
    
    lazy var passwordChanger: PasswordChanging = PasswordChanger()
    var securityToken = ""
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var viewModel: ChangePasswordViewModel!
    
    @IBAction private func cancel() {
        dismissModal()
        updateInputFocus(.noKeyboard)
    }
    
    @IBAction private func changePassword() {
        let passwordInputs = PasswordInputs(
            oldPassword: oldPasswordTextField.text ?? "",
            newPassword: newPasswordTextField.text ?? "",
            confirmPassword: confirmPasswordTextField.text ?? "")
        guard presenter.validateInputs(passwordInputs: passwordInputs) else { return }
        setUpWaitingAppearance()
        presenter.attemptToChangePassword(passwordInputs: passwordInputs)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 8
        blurView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        setLabels()
    }
    
    func setLabels() {
        navigationBar.topItem?.title = viewModel.title
        oldPasswordTextField.placeholder = viewModel.oldPasswordPlaceholder
        newPasswordTextField.placeholder = viewModel.newPasswordPlaceholder
        confirmPasswordTextField.placeholder = viewModel.confirmPasswordPlaceholder
        submitButton.setTitle(viewModel.submitButtonLabel, for: .normal)
    }
}

//MARK: ViewController Extension
extension ChangePasswordViewController: UITextFieldDelegate, ChangePasswordViewCommands {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField === newPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField === confirmPasswordTextField {
            changePassword()
        }
        return true
    }
    
    private func setUpWaitingAppearance() {
        updateInputFocus(.noKeyboard)
        setCancelButtonEnabled(false)
        showBlurView()
        viewModel.isActivityIndicatorShowing = true
        showActivityIndicator()
    }
    
    func clearNewPasswordFields() {
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    func clearAllPasswordFields() {
        oldPasswordTextField.text = ""
        newPasswordTextField.text = ""
        confirmPasswordTextField.text = ""
    }
    
    func updateInputFocus(_ inputFocus: InputFocus) {
        switch inputFocus {
        case .noKeyboard:
            view.endEditing(true)
        case .oldPassword:
            oldPasswordTextField.becomeFirstResponder()
        case .newPassword:
            newPasswordTextField.becomeFirstResponder()
        case .confirmPassword:
            confirmPasswordTextField.becomeFirstResponder()
        }
    }
    
    func setCancelButtonEnabled(_ enabled: Bool) {
        cancelBarButton.isEnabled = enabled
    }
    
    func hideBlurView() {
        blurView.removeFromSuperview()
        view.backgroundColor = .white
    }
    
    func showBlurView() {
        view.backgroundColor = .clear
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.heightAnchor.constraint(equalTo: view.heightAnchor),
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func showActivityIndicator() {
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    func dismissModal() {
        self.dismiss(animated: true)
    }
    
    private func textFieldsShouldReturn(_ textField: UITextField) -> Bool {
        if textField === oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        } else if textField === newPasswordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField === confirmPasswordTextField {
            changePassword()
        }
        return true
    }
    
    private func finishViewsForFailure() {
        clearAllPasswordFields()
        hideBlurView()
        viewModel.isActivityIndicatorShowing = false
        updateInputFocus(.oldPassword)
        cancelBarButton.isEnabled = true
    }
    
    private func showAlert(message: String,
                           okAction: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert)
        let okButton = UIAlertAction(
            title: viewModel.okButtonLabel,
            style: .default,
            handler: okAction)
        alertController.addAction(okButton)
        alertController.preferredAction = okButton
        self.present(alertController, animated: true)
    }
    
    func showAlert(message: String,
                   action: @escaping () -> Void) {
        let wrappedAction: (UIAlertAction) -> Void = { _ in action() }
        showAlert(message: message, okAction: {wrappedAction($0) })
        
    }
}
