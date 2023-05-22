//
//  MyClassTests.swift
//  iOSUnitTestingTests
//
//  Created by roberts.kursitis on 21/02/2023.
//

import XCTest
@testable import iOSUnitTesting
// As MyClass has no access control it defaults to internal. Testable makes internal declarations visible. Anything marked private remains private.

final class MyClassTests: XCTestCase {
//	func test_zero() {
//		XCTFail("Tests not yet implemented in MyClassTests")
//	}
	//test zero because it precedes the first real test.
	private var sut: MyClass!
	//SUT = system under test aka "the thing we're testing."
	
	override func setUp() {
		super.setUp()
		sut = MyClass()
	}
	
	override func tearDown() {
		sut = nil
		super.tearDown()
	}
	
	func test_methodOne() {
		sut.methodOne()
	}
	
	func test_methodTwo() {
		sut.methodTwo()
	}
}
