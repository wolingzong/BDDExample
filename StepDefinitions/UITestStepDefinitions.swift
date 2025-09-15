import XCTest
import XCTest_Gherkin

final class UITestStepDefinitions: StepDefiner {

    // 【重要】再次提醒：强烈建议在您的测试主类（如 ShoppingCartTests.swift）中
    // 添加 setUpWithError 和 tearDownWithError 方法，以确保每个测试用例独立运行。
    /*
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        
        let app = XCUIApplication()
        // 每次测试前都重新启动App，保证干净的环境
        app.launch()
    }
    */

    override func defineSteps() {

        // --- Given Steps ---

                step("I am a logged-in user") {
                    // 此步骤保持不变，假设App启动后即为登录状态。
                    // 如果 setUp 中已包含 app.launch()，这里的启动可以移除或保留。
                    // 为保持独立性，我们假设每个 Given 都可能需要确保 App 在运行。
                    _ = XCUIApplication()
                }

                step("my shopping cart is empty") {
                    let app = XCUIApplication()

                    // 验证总价是否为 0.00
                    let priceLabel = app.staticTexts["cart_total_price"]
                    guard priceLabel.waitForExistence(timeout: 5) else {
                        XCTFail("断言失败：未找到购物车总价标签 (标识符: 'cart_total_price')。")
                        return
                    }
                    // 期望空购物车的总价是 "总价: 0.00"
                    XCTAssertEqual(priceLabel.label, "总价: 0.00", "期望空购物车的总价为 '总价: 0.00'，但实际为 '\(priceLabel.label)'。")

                    // 验证购物车角标数量是否为 0
                    let badge = app.staticTexts["cart_badge_count"]
                    guard badge.waitForExistence(timeout: 5) else {
                        XCTFail("断言失败：未找到购物车数量角标 (标识符: 'cart_badge_count')。")
                        return
                    }
                    // 从标签文本中提取数字进行比较
                    let actualCount = self.extractNumber(from: badge.label)
                    XCTAssertEqual(actualCount, "0", "期望空购物车的商品数量为 '0'，但从 '\(badge.label)' 中提取到的数量为 '\(actualCount ?? "nil")'。")
                }

                // 步骤已优化，可以根据传入的数量循环添加商品来建立初始状态
                step(#"my shopping cart already has "(\d+)" item with a total price of "(\d+\.?\d*)" yuan"#) { (matches: [String]) in
                    guard let expectedInitialItemCount = Int(matches[0]) else {
                        XCTFail("无法将期望的初始商品数量 '\(matches[0])' 转换为整数。")
                        return
                    }
                    let expectedInitialPriceString = matches[1]
                    let app = XCUIApplication()

                    // 通过循环添加商品来达到指定的初始数量
                    // 注意：这里硬编码了商品名称，如果需要更灵活，可以修改此逻辑
                    for _ in 0..<expectedInitialItemCount {
                        self.addProductToCart(productName: "iPhone 18")
                    }

                    // 验证初始商品数量
                    let badge = app.staticTexts["cart_badge_count"]
                    guard badge.waitForExistence(timeout: 5) else {
                        XCTFail("断言失败：为初始状态设置时未找到购物车数量角标。")
                        return
                    }
                    let actualCount = self.extractNumber(from: badge.label)
                    XCTAssertEqual(actualCount, String(expectedInitialItemCount), "初始购物车商品数量不匹配。期望: '\(expectedInitialItemCount)', 实际: '\(actualCount ?? "nil")'。")

                    // 验证初始总价
                    let priceLabel = app.staticTexts["cart_total_price"]
                    guard priceLabel.waitForExistence(timeout: 5) else {
                        XCTFail("断言失败：为初始状态设置时未找到购物车总价标签。")
                        return
                    }
                    // 格式化期望价格以进行比较
                    let finalExpectedPriceString = "总价: \(expectedInitialPriceString)"
                    XCTAssertEqual(priceLabel.label, finalExpectedPriceString, "初始购物车总价不匹配。期望: '\(finalExpectedPriceString)', 实际: '\(priceLabel.label)'。请检查 .feature 文件中的价格是否与应用实际价格匹配。")
                }

                // --- When Steps ---

                step(#"I add the product "(.*)" to the cart"#) { (matches: [String]) in
                    let productName = matches[0]
                    self.addProductToCart(productName: productName)
                }

                // --- Then Steps ---

                step(#"I should see "(\d+)" item(s)? in the cart"#) { (matches: [String]) in
                    let expectedCount = matches[0]
                    let app = XCUIApplication()

                    let badge = app.staticTexts["cart_badge_count"]
                    guard badge.waitForExistence(timeout: 5) else {
                        XCTFail("断言失败：验证时未找到购物车数量角标。")
                        return
                    }
                    // 从标签文本中提取数字进行比较
                    let actualCount = self.extractNumber(from: badge.label)
                    XCTAssertEqual(actualCount, expectedCount, "购物车商品数量不匹配。期望: '\(expectedCount)', 实际: '\(actualCount ?? "nil")' (来自 '\(badge.label)')。")
                }

                step(#"the total price of the cart should be "(\d+\.?\d*)" yuan"#) { (matches: [String]) in
                    let expectedPriceValueString = matches[0]
                    let app = XCUIApplication()

                    let priceLabel = app.staticTexts["cart_total_price"]
                    guard priceLabel.waitForExistence(timeout: 5) else {
                        XCTFail("断言失败：验证时未找到购物车总价标签。")
                        return
                    }
                    // 直接使用 Gherkin 文件中的价格构建期望字符串
                    let finalExpectedPriceString = "总价: \(expectedPriceValueString)"
                    XCTAssertEqual(priceLabel.label, finalExpectedPriceString, "购物车总价不匹配。期望: '\(finalExpectedPriceString)', 实际: '\(priceLabel.label)'。请检查 .feature 文件中的价格是否与应用实际价格匹配。")
                }
            }

    // MARK: - Helper Function

    // MARK: - Helper Functions

       /// 从字符串中提取所有数字并拼接成一个新的字符串。
       /// 例如，从 "Items in cart: 1" 中提取 "1"。
       private func extractNumber(from text: String) -> String? {
           let digits = text.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
           return digits.isEmpty ? nil : digits
       }

       /// 可重用的辅助函数，用于将指定商品添加到购物车。
       private func addProductToCart(productName: String) {
           let app = XCUIApplication()
           let productButton = app.buttons[productName]

           guard productButton.waitForExistence(timeout: 5) else {
               XCTFail("断言失败：5秒内未找到商品按钮 '\(productName)'。请检查其 accessibilityIdentifier 是否正确。")
               return
           }
           productButton.tap()
       }
}
