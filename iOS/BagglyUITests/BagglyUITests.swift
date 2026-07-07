import XCTest

final class BagglyUITests: XCTestCase {

    func testAddEntryFlow() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["button_add"].tap()
        let field = app.textFields["field_primary"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText("UI Test Entry")
        app.buttons["button_save"].tap()
        XCTAssertTrue(app.staticTexts["UI Test Entry"].waitForExistence(timeout: 5))
    }

    func testKeyboardDismissOnTapOutside() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["button_add"].tap()
        let field = app.textFields["field_primary"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap()
        field.typeText("Dismiss Test")
        XCTAssertTrue(app.keyboards.count > 0)
        app.otherElements.firstMatch.tap()
        XCTAssertFalse(app.keyboards.element(boundBy: 0).exists)
    }

    func testSettingsOpens() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["button_settings"].tap()
        XCTAssertTrue(app.buttons["button_done_settings"].waitForExistence(timeout: 5))
    }

    func testCancelAddDismisses() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["button_add"].tap()
        XCTAssertTrue(app.buttons["button_cancel"].waitForExistence(timeout: 5))
        app.buttons["button_cancel"].tap()
        XCTAssertTrue(app.buttons["button_add"].waitForExistence(timeout: 5))
    }
}
