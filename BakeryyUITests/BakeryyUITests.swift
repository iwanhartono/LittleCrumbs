//
//  BakeryyUITests.swift
//  BakeryyUITests
//
//  Created by Iwan Hartono on 13/08/26.
//

import XCTest

final class BakeryyUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Drives the PRD's core ordering journey end to end against the mock
    /// data layer: Home -> Order Now -> Menu -> Product Detail -> Add to
    /// Order -> Order Bag -> Customer Info -> Send Order.
    @MainActor
    func testCoreOrderingFlow() throws {
        let app = XCUIApplication()
        app.launch()

        let orderNowButton = app.buttons["Order Now"]
        XCTAssertTrue(orderNowButton.waitForExistence(timeout: 5), "Home should show the Order Now CTA once the preorder is loaded")
        orderNowButton.tap()

        let milkBread = app.staticTexts["Milk Bread"]
        XCTAssertTrue(milkBread.waitForExistence(timeout: 5), "Menu should list Milk Bread once products load")
        milkBread.tap()

        let addToOrderButton = app.buttons["Add to Order · Rp28.000"]
        XCTAssertTrue(addToOrderButton.waitForExistence(timeout: 5), "Product Detail should show the priced Add to Order button")
        addToOrderButton.tap()

        let viewBagButton = app.buttons["View Order Bag"]
        XCTAssertTrue(viewBagButton.waitForExistence(timeout: 3), "Adding an item should offer to view the Order Bag")
        viewBagButton.tap()

        XCTAssertTrue(app.staticTexts["Milk Bread"].waitForExistence(timeout: 3), "Order Bag should list the item just added")
        let continueOrderButton = app.buttons["Continue Order"]
        XCTAssertTrue(continueOrderButton.exists)
        continueOrderButton.tap()

        let sendOrderButton = app.buttons["Send Order"]
        XCTAssertTrue(sendOrderButton.waitForExistence(timeout: 3))
        XCTAssertFalse(sendOrderButton.isEnabled, "Send Order must stay disabled until required customer info is filled in")

        let nameField = app.textFields["Name"]
        XCTAssertTrue(nameField.waitForExistence(timeout: 3))
        nameField.tap()
        nameField.typeText("Andi")

        let phoneField = app.textFields["Phone Number"]
        phoneField.tap()
        phoneField.typeText("081234567890")

        XCTAssertTrue(sendOrderButton.isEnabled, "Send Order should enable once name and phone are provided")
        sendOrderButton.tap()

        let sendViaWhatsApp = app.buttons["Send via WhatsApp"]
        XCTAssertTrue(sendViaWhatsApp.waitForExistence(timeout: 3), "Tapping Send Order should offer WhatsApp/Instagram hand-off")
        sendViaWhatsApp.tap()

        // WhatsApp isn't installed on the simulator, so the app should
        // surface a graceful alert rather than silently failing or
        // clearing the cart.
        let cannotOpenAlert = app.alerts["Couldn't Open WhatsApp"]
        XCTAssertTrue(cannotOpenAlert.waitForExistence(timeout: 3))
        cannotOpenAlert.buttons["OK"].tap()
    }

    /// Acceptance criteria from the PRD: a product with `available = false`
    /// shows Sold Out and its Add to Order control is disabled.
    @MainActor
    func testSoldOutProductCannotBeAddedToOrder() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars.buttons["Menu"].tap()

        let cinnamonRoll = app.staticTexts["Cinnamon Roll"]
        XCTAssertTrue(cinnamonRoll.waitForExistence(timeout: 5))
        cinnamonRoll.tap()

        let soldOutButton = app.buttons["Sold Out"]
        XCTAssertTrue(soldOutButton.waitForExistence(timeout: 5))
        XCTAssertFalse(soldOutButton.isEnabled, "Add to Order must be disabled for unavailable products")
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
