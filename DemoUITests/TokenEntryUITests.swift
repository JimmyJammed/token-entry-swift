import XCTest
final class TokenEntryUITests: XCTestCase {
    @MainActor func testAddAndDeleteToken() {
        let app = XCUIApplication(); app.launch()
        let field = app.textFields["token-input"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap(); field.typeText("Jordan\n")
        XCTAssertEqual(app.staticTexts["token-count"].label, "4 tokens")
        field.typeText(XCUIKeyboardKey.delete.rawValue + XCUIKeyboardKey.delete.rawValue)
        XCTAssertEqual(app.staticTexts["token-count"].label, "3 tokens")
    }
}
