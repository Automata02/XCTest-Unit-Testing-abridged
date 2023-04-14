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
        putFocusOn(textField: sut.confirmPasswordTextField)
        XCTAssertTrue(sut.confirmPasswordTextField.isFirstResponder, "precondition")
        tapTap(sut.submitButton)
        XCTAssertFalse(sut.confirmPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnNewPassword_resignsFocus() {
        setUpValidPasswordEntries()
        putFocusOn(textField: sut.newPasswordTextField)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        tapTap(sut.submitButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingSubmit_withValidFieldsFocusedOnOldPassword_resignsFocus() {
        setUpValidPasswordEntries()
        putFocusOn(textField: sut.oldPasswordTextField)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        tapTap(sut.submitButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }
    
    @MainActor func test_tappingSubmit_withCOnfirmationMismatch_shouldShowMismatchAlert() {
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
    
    private func putFocusOn(textField: UITextField) {
        putInViewHierarchy(sut)
        textField.becomeFirstResponder()
    }
    
    func test_tappingCancel_withFocusOnOldPassword_shouldResignThatFocus() {
        putFocusOn(textField: sut.oldPasswordTextField)
        XCTAssertTrue(sut.oldPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.oldPasswordTextField.isFirstResponder)
    }
    
    func test_tappingCancel_withFocusOnNewPassword_shouldResignThatFocus() {
        putFocusOn(textField: sut.newPasswordTextField)
        XCTAssertTrue(sut.newPasswordTextField.isFirstResponder, "precondition")
        tap(sut.cancelBarButton)
        XCTAssertFalse(sut.newPasswordTextField.isFirstResponder)
    }
    
    func test_tappingCancel_withFocusOnConfirmPassword_shouldResignThatFocus() {
        putFocusOn(textField: sut.confirmPasswordTextField)
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
