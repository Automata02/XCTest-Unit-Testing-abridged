//
//  iOSUnitTestingTests.swift
//  iOSUnitTestingTests
//
//  Created by roberts.kursitis on 21/02/2023.
//

import XCTest
@testable import iOSUnitTesting

final class iOSUnitTestingTests: XCTestCase {
	
	//MARK: Simple assertions
	func test_fail() {
		XCTFail()
	}
	
	func test_fail_withSimpleMessage() {
		XCTFail("We have a problem")
	}
	
	
	func test_fail_withInterpolatedMessage() {
		 let theAnswer = 42
		 XCTFail("The Answer to the Great Question is \(theAnswer)")
	 }
	
	func test_assertTrue() {
		let success = false
		XCTAssertTrue(success)
	}
	
	func test_assertNil() {
		let optionalValue: Int? = 123
		XCTAssertNil(optionalValue)
	}
	
	//MARK: Describing objects upon failure.
	
	struct StructWithDescription: CustomStringConvertible {
		let x: Int
		let y: Int
		var description: String { "(\(x), \(y))" }
	}
	
	func test_assertNil_withSelfDescribingType() {
		let optionalValue: StructWithDescription? = StructWithDescription(x: 1, y: 2)
		XCTAssertNil(optionalValue)
	}
	//Outputs: XCTAssertNil failed: "(1, 2)"
	
	//MARK: Equal Assertion
	func test_assertEqual() {
		let actual = "actual"
		XCTAssertEqual(actual, "expected")
	}
	/*
	 Order of evaluation matters because failure message states which is which: expected: <"expected"> but was: <"actual">
	 XCTAssert requires both arguments to be the same type, if one value is optional the other one will be optional as well.
	 It does it by checking if a variable is of type T and if it is, it wraps the other value as optional. It's done to
	 make tests easier to writewhen optionals are involved.
	*/
	
	func test_floatingPointDanger() {
		let result = 0.1 + 0.2
//		XCTAssertEqual(result, 0.3)
		XCTAssertEqual(result, 0.3, accuracy: 0.0001)
	}
	/*
	 Outputs: XCTAssertEqual failed: ("0.30000000000000004") is not equal to ("0.3")
	 Floating point numbers are approximations. Using accuracy helps with asserting doubles and floats.
	*/
}
