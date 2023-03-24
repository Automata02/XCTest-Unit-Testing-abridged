Unit Testing Best Practices
Introduction

Unit testing is a subset of automated testing that provides quick, consistent, and unambiguous feedback. In this document, we will discuss the best practices for writing effective unit tests that ensure the quality of your codebase.
Goals of Test Assertions

Test assertions have two primary goals:

    Fail the test when something other than the expected outcome occurs.
    Document how the system under test is supposed to behave (i.e., tests as documentation).

Characteristics of a Good Unit Test

A good unit test should possess the following characteristics:

    Quick: A single unit test should complete in milliseconds, and thousands of such tests should run quickly.
    Consistent: Given the same code, a unit test should report the same results regardless of the order of test execution or global state.
    Unambiguous: A failing unit test should clearly report the problem it detected.

Writing Effective Unit Tests

    Avoid conditional branches and use accuracy for floats and doubles.
    If a test requires a conditional that doesn't exist, use XCTFail() inside the conditional clause.
    Each test should start with a clean slate and not carry over from other tests.
    Follow the Four-phase test (AAA): Arrange, Act, Assert.
    Create what you need in setUp method, remove in tearDown method.
    Use cmd + < to enable coverage scheme, cmd + 9 to show log/coverage.
    If you can delete lines of production code, and the tests still pass, then those lines aren’t covered.
    Don’t test Set and Get on stored properties, do test computed properties.
    Avoid Core data setups and populated by test code without using or changing any stored data and network requests.
    Use an in-memory store for Core Data in the AppDelegate to keep production data from interfering with test data.
    Use Subclass and Override method for classes that permit subclassing to overcome problematic methods with minimal changes to production code.
    Test Outlets should be connected.
    Use Unit tests for full access to the code and UI tests for prying the UI elements.
    Intercept dynamic messages using helper libraries that intercept data.
    Test UserDefaults by instantiating the ViewController from the storyboard, creating an instance of FakeUserDefaults, and injecting them into the ViewController before viewDidLoad().
    Replace concrete types with a protocol if needed.
    Use Test Spy to record the method calls that your system receives, and Mock Objects that do their own assertions to simplify test code.
    Pass the file name and line number in arguments while calling XCTest assertion from a helper function.
    Use test spies that capture closure and invokes them with arguments to test closure testing.
    Async code tests should be in pairs, one that waits and one that skips expectation and avoid the async part.
    Take caution when using XCTAssertEqual on types declared in ObjC, introduce an error to check failure message, and add an extension to make the type conform to CustomStringConvertible.
    Test delegate methods by requesting the delegate and calling through it.
    Describe Types written in ObjC with CustomStringConvertible protocol.
    To test the first responder, the view needs to be in a view hierarchy.
    Executing the run loop in tearDown() will prevent memory leaks when adding anything to a temp UIWindow.
    Testing tableViews is similar to textField, and both have two delegates.

Conclusion

In conclusion, effective unit tests help build reliable software, ensure code quality, and aid in debugging. The best practices mentioned in this document will help you write effective unit tests for your codebase, leading to a more stable and maintainable product.
