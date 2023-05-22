//
//  ChangePasswordViewControllerTests.swift
//  ChangePasswordViewControllerTests
//
//  Created by Roberts Kursitis on 06/04/2023.
//

import XCTest
import ViewControllerPresentationSpy
@testable import Refactoring

final class ChangePasswordViewControllerTests: XCTestCase {
    private var sut: ChangePasswordViewController!
    private var passwordChanger: MockPasswordChanger!
    private var alertVerifier: AlertVerifier!
    
    @MainActor override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: String(describing: ChangePasswordViewController.self))
        sut.viewModel = ChangePasswordViewModel(okButtonLabel: "OK")
        
        passwordChanger = MockPasswordChanger()
        sut.passwordChanger = passwordChanger
        alertVerifier = AlertVerifier()
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        executeRunLoop()
        sut = nil
        passwordChanger = nil
        alertVerifier = nil
        super.tearDown()
    }
    //MARK: Behavior tests
    
    //MARK: Testing hitting return key from different textFields
    //asserting delegates are connected before testing
    func test_textFieldDelegates_shouldBeConnected() {
        XCTAssertNotNil(sut.oldPasswordTextField.delegate, "oldPasswordTextField")
        XCTAssertNotNil(sut.newPasswordTextField.delegate, "newPasswordTextField")
        XCTAssertNotNil(sut.confirmPasswordTextField.delegate, "confirmPasswordTextField")
    }
    
    func test_hittingReturnFromConfirmPassword_shouldRequestPasswordChange() {
        sut.securityToken = "TOKEN"
        sut.oldPasswordTextField.text = "OLD456"
        sut.newPasswordTextField.text = "NEW456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
        
        shouldReturn(in: sut.confirmPasswordTextField)
        
        passwordChanger.verifyChange(
            securityToken: "TOKEN",
            oldPassword: "OLD456",
            newPassword: "NEW456")
    }
    
    func test_hittingReturnFromOldPassword_shouldNotRequestPasswordChange() {
        setUpValidPasswordEntries()
        shouldReturn(in: sut.oldPasswordTextField)
        passwordChanger.verifyChangeNeverCalled()
    }
    
    func test_hittingReturnFromNewPassword_shouldNotRequestPasswordChange() {
        setUpValidPasswordEntries()
        shouldReturn(in: sut.newPasswordTextField)
        passwordChanger.verifyChangeNeverCalled()
    }
    
    //MARK: Tapping OK in Failure Alert
    @MainActor func test_tappingOKInFailureAlert_shouldNotDismissModal() throws {
        showPasswordChangeFailureAlert()
        let dismissalVerifier = DismissalVerifier()
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(dismissalVerifier.dismissedCount, 0)
    }
    
    @MainActor func test_tappingOkInFailureAlert_shouldEnableCancelBarButton() throws {
        showPasswordChangeFailureAlert()
        XCTAssertFalse(sut.cancelBarButton.isEnabled, "precondition")
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.cancelBarButton.isEnabled)
    }
    
    @MainActor func test_tappingOKInFailureAlert_shouldEnableCancelBarButton() throws {
        showPasswordChangeFailureAlert()
        XCTAssertFalse(sut.cancelBarButton.isEnabled, "precondition")
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.cancelBarButton.isEnabled)
    }
    
    @MainActor func test_tappingOKInFailureAlert_shouldHideBlur() throws {
        showPasswordChangeFailureAlert()
        XCTAssertNotNil(sut.blurView.superview, "precondition")
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertNil(sut.blurView.superview)
    }
    
    @MainActor func test_tappingOKInFailureAlert_shouldSetBackgroundBacktoWhite() throws {
        showPasswordChangeFailureAlert()
        XCTAssertNotEqual(sut.view.backgroundColor, .white, "precondition")
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.view.backgroundColor, .white)
    }
    
    @MainActor func test_tappingOKInFailureAlert_shouldPutFocusOnOldPassword() throws {
        showPasswordChangeFailureAlert()
        putInViewHierarchy(sut)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder)
    }
    
    @MainActor func test_tappingOKInFailureAlert_shouldClearAllFieldsToStartOver() throws {
        showPasswordChangeFailureAlert()
        try alertVerifier.executeAction(forButton: "OK")
        
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, true, "old")
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirm")
    }
    

    private func showPasswordChangeFailureAlert() {
        setUpValidPasswordEntries()
        tapTap(sut.submitButton)
        passwordChanger.changeCallFailure(message: "DUMMY")
    }
    
    @MainActor func test_changePasswordFailure_shouldShowFailureAlertWithGivenMessage() {
        setUpValidPasswordEntries()
        tapTap(sut.submitButton)
        passwordChanger.changeCallFailure(message: "MESSAGE")
        verifyAlertPresented(title: "", message: "MESSAGE")
    }
    
    //MARK: Tapping OK in Success Alert
    @MainActor func test_changePasswordSuccess_shouldShowSuccessAlert() {
        setUpValidPasswordEntries()
        tapTap(sut.submitButton)
        passwordChanger.changeCallSuccess()
        verifyAlertPresented(title: "", message: "Your password has been successfully changed.")
    }
    
    @MainActor func test_tappingOKInSuccessAlert_shouldDismissModal() throws {
        setUpValidPasswordEntries()
        tapTap(sut.submitButton)
        passwordChanger.changeCallSuccess()
        let dismissalVerifier = DismissalVerifier()
        try alertVerifier.executeAction(forButton: "OK")
        dismissalVerifier.verify(animated: true, dismissedViewController: sut)
    }
    
    //MARK: Activity Indicator Tests
    func test_changePasswordFailure_shouldStopActivityIndicatorAnimation() {
        setUpValidPasswordEntries()
        tapTap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating, "precondition")
        passwordChanger.changeCallFailure(message: "DUMMY")
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func test_changePasswordFailure_shouldHideActivityIndicator() {
        setUpValidPasswordEntries()
        tapTap(sut.submitButton)
        XCTAssertNotNil(sut.activityIndicator.superview, "precondition")
        passwordChanger.changeCallFailure(message: "DUMMY")
        XCTAssertNil(sut.activityIndicator.superview)
    }
    
    func test_changePasswordSuccess_shouldStopActivityIndicatorAnimation() {
        setUpValidPasswordEntries()
        tapTap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating, "precondition")
        passwordChanger.changeCallSuccess()
        XCTAssertFalse(sut.activityIndicator.isAnimating)
    }
    
    func test_changePasswordSuccess_shouldHideActivityIndicator() {
        setUpValidPasswordEntries()
        tapTap(sut.submitButton)
        XCTAssertNotNil(sut.activityIndicator.superview, "precondition")
        passwordChanger.changeCallSuccess()
        XCTAssertNil(sut.activityIndicator.superview)
    }
    
    //MARK: Tapping Submit with Valid textFields
    func test_tappingSubmit_withValidFields_shouldRequestChangePassword() {
        sut.securityToken = "TOKEN"
        sut.oldPasswordTextField.text = "OLD456"
        sut.newPasswordTextField.text = "NEW456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
        
        tapTap(sut.submitButton)
        passwordChanger.verifyChange(securityToken: "TOKEN", oldPassword: "OLD456", newPassword: "NEW456")
    }
    
    func test_tappingSubmit_withValidFields_shouldClearBackgroundColorForBlur() {
        setUpValidPasswordEntries()
        XCTAssertNotEqual(sut.view.backgroundColor, .clear, "precondition")
        tapTap(sut.submitButton)
        XCTAssertEqual(sut.view.backgroundColor, .clear)
    }
    
    func test_tappingSubmit_withValidFields_shouldStartActivityAnimation() {
        setUpValidPasswordEntries()
        XCTAssertFalse(sut.activityIndicator.isAnimating, "precondition")
        tapTap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }
    
    func test_tappingSubmit_withValidFields_shouldShowActivityIndicator() {
        setUpValidPasswordEntries()
        XCTAssertNil(sut.activityIndicator.superview, "precondition")
        tapTap(sut.submitButton)
        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }
    
    func test_tappingSubmit_withValidFields_shouldShowBlurView() {
        setUpValidPasswordEntries()
        XCTAssertNil(sut.blurView.superview, "precondition")
        tapTap(sut.submitButton)
        XCTAssertNotNil(sut.blurView.superview)
    }
    
    func test_tappingSubmit_withValidFields_shouldDisableCancelBarButton() {
        setUpValidPasswordEntries()
        XCTAssertTrue(sut.cancelBarButton.isEnabled, "precondition")
        tapTap(sut.submitButton)
        XCTAssertFalse(sut.cancelBarButton.isEnabled)
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnConfirmPassword_resignsFocus() {
        setUpValidPasswordEntries()
        putFocusOn(.confirmPassword)
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder, "precondition")
        tapTap(sut.submitButton)
        XCTAssertFalse(sut.confirmPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnNewPassword_resignsFocus() {
        setUpValidPasswordEntries()
        putFocusOn(.newPassword)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        tapTap(sut.submitButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnOldPassword_resignsFocus() {
        setUpValidPasswordEntries()
        putFocusOn(.oldPassword)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        tapTap(sut.submitButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }
    
    //MARK: Tapping Submit with mismatched textFields
    @MainActor func test_tappingSubmit_withConfirmationMismatch_shouldShowMismatchAlert() {
        setUpMismatchedConfirmationEntry()
        tapTap(sut.submitButton)
        verifyAlertPresented(title: "", message: "The new password and the confirmation password " + "don’t match. Please try again.")
    }
    
    func test_tappingSubmit_withConfirmationMismatch_shouldNotChangePassword() {
        setUpMismatchedConfirmationEntry()
        tapTap(sut.submitButton)
        passwordChanger.verifyChangeNeverCalled()
    }
    
    private func setUpMismatchedConfirmationEntry() {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "123456"
        sut.confirmPasswordTextField.text = "abcdef"
    }
    
    //MARK: Password length tests
    @MainActor func test_tappingOKInTooShortAlert_shouldPutFocusOnNewPassword() throws {
        setUpEntriesNewPasswordTooShort()
        tapTap(sut.submitButton)
        putInViewHierarchy(sut)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }
    
    @MainActor func test_tappingOKInTooShortAlert_shouldNotClearOldPasswordField() throws {
        setUpEntriesNewPasswordTooShort()
        tapTap(sut.submitButton)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.oldPasswordTextField.text?.isEmpty, false)
    }
    
    @MainActor func test_tappingOKInTooShortAlert_shouldClearNewAndConfirmation() throws {
        setUpEntriesNewPasswordTooShort()
        tapTap(sut.submitButton)
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertEqual(sut.newPasswordTextField.text?.isEmpty, true, "new")
        XCTAssertEqual(sut.confirmPasswordTextField.text?.isEmpty, true, "confirmation")
    }
    
    func test_tappingSubmit_withNewPasswordTooShort_shouldNotChangePassword() {
        setUpEntriesNewPasswordTooShort()
        tapTap(sut.submitButton)
        passwordChanger.verifyChangeNeverCalled()
    }
    
    @MainActor func test_tappingSubmit_withPasswordTooShort_shouldShowTooShortAlert() {
        setUpEntriesNewPasswordTooShort()
        tapTap(sut.submitButton)
        verifyAlertPresented(title: "", message: "The new password should have at least 6 characters.")
        #warning("Problem with alertVerifier. For some reason need to pass an empty titles for the test to pass. 🤷")
    }
    
    private func setUpEntriesNewPasswordTooShort() {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "12345"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
    }
    
    @MainActor func test_tappingOKPasswordBlankAlert_shouldPutFocusOnNewPassword() throws {
        setUpValidPasswordEntries()
        sut.newPasswordTextField.text = ""
        tapTap(sut.submitButton)
        putInViewHierarchy(sut)
        
        try alertVerifier.executeAction(forButton: "OK")
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withNewPasswordEmpty_shouldNotChangePassword() {
        setUpValidPasswordEntries()
        sut.newPasswordTextField.text = ""
        tapTap(sut.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    @MainActor func test_tappingSubmit_withNewPasswordEmpty_shouldShowPasswordBlankAlert() {
        setUpValidPasswordEntries()
        sut.newPasswordTextField.text = ""
        tapTap(sut.submitButton)
        verifyAlertPresented(title: "", message: "Please enter a new password.")
        #warning("Problem with alertVerifier. 🤷")
    }
    
    @MainActor private func verifyAlertPresented(title: String?, message: String, file: StaticString = #file, line: UInt = #line) {
        alertVerifier.verify(title: title, message: message, animated: true, actions: [.default("OK")], file: file, line: line)
        XCTAssertEqual(alertVerifier.preferredAction?.title, "OK", "preferred action", file: file, line: line)
    }
    
    func test_tappingSubmit_withOldPasswordEmpty_shouldPutFocusOnOldPassword() {
        setUpValidPasswordEntries()
        sut.oldPasswordTextField.text = ""
        putInViewHierarchy(sut)
        tapTap(sut.submitButton)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withOldPasswordEmpty_shouldNotChangePassword() {
        setUpValidPasswordEntries()
        sut.oldPasswordTextField.text = ""
        
        tapTap(sut.submitButton)
        
        passwordChanger.verifyChangeNeverCalled()
    }
    
    private func setUpValidPasswordEntries() {
        sut.oldPasswordTextField.text = "NONEMPTY"
        sut.newPasswordTextField.text = "123456"
        sut.confirmPasswordTextField.text = sut.newPasswordTextField.text
    }
    
    @MainActor func test_tappingCancelShouldDismissModal() {
        let dismissalVerifier = DismissalVerifier()
        tap(sut.cancelBarButton)
        dismissalVerifier.verify(animated: true, dismissedViewController: sut)
    }
    
    private func putFocusOn(_ inputFocus: InputFocus) {
        putInViewHierarchy(sut)
        sut.updateInputFocus(inputFocus)
    }
    
    func test_tappingCancel_withFocusOnOldPassword_shouldResignThatFocus() {
        putFocusOn(.oldPassword)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingCancel_withFocusOnNewPassword_shouldResignThatFocus() {
        putFocusOn(.newPassword)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingCancel_withFocusOnConfirmPassword_shouldResignThatFocus() {
        putFocusOn(.confirmPassword)
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.confirmPasswordTextField.isFirstResponder)
    }
    
    //MARK: Basic tests
    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.cancelBarButton, "cancelButton")
        XCTAssertNotNil(sut.oldPasswordTextField, "oldPasswordTextField")
        XCTAssertNotNil(sut.newPasswordTextField, "newPasswordTextField")
        XCTAssertNotNil(sut.confirmPasswordTextField, "confirmPasswordTextField")
        XCTAssertNotNil(sut.submitButton, "submitButton")
        XCTAssertNotNil(sut.navigationBar, "navigationBar")
    }
    
    func test_navigationBar_shouldHaveTitle() {
        XCTAssertEqual(sut.navigationBar.topItem?.title, "Change Password")
    }
    
    func test_cancelBarButton_shouldBeSystemItemCancel() {
        XCTAssertEqual(systemItem(for: sut.cancelBarButton), .cancel)
    }
    
    func test_oldPasswordTextField_shouldHavePlaceholder() {
        XCTAssertEqual(sut.oldPasswordTextField.placeholder, "Current Password")
    }
    
    func test_newPasswordTextField_shouldHavePlaceholder() {
        XCTAssertEqual(sut.newPasswordTextField.placeholder, "New Password")
    }
    
    func test_confirmPasswordTextField_shouldHavePlaceholder() {
        XCTAssertEqual(sut.confirmPasswordTextField.placeholder, "Confirm New Password")
    }
    
    func test_submitButton_shouldHaveTitle() {
        XCTAssertEqual(sut.submitButton.titleLabel?.text, "Submit")
    }
    
    func test_oldPasswordTextField_shouldHavePasswordAttribute() {
        let textField = sut.oldPasswordTextField!
        XCTAssertEqual(textField.textContentType, .password, "textContentType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecuredTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically, "enamesReturnKeyAutomatically")
    }
    
    func test_newPasswordTextField_shouldHavePasswordAttribute() {
        let textField = sut.newPasswordTextField!
        XCTAssertEqual(textField.textContentType, .newPassword, "textContentType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecuredTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically, "enamesReturnKeyAutomatically")
    }
    
    func test_confirmPasswordTextField_shouldHavePasswordAttribute() {
        let textField = sut.confirmPasswordTextField!
        XCTAssertEqual(textField.textContentType, .newPassword, "textContentType")
        XCTAssertTrue(textField.isSecureTextEntry, "isSecuredTextEntry")
        XCTAssertTrue(textField.enablesReturnKeyAutomatically, "enamesReturnKeyAutomatically")
    }

}
