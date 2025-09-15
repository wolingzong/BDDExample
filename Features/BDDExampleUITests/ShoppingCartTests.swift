import XCTest
import XCTest_Gherkin

// 确保这是您的测试主类
class ShoppingCartTests: XCTestCase {



    
    override func setUp() {
        XCUIDevice.shared.orientation = .portrait // 强制竖屏
        continueAfterFailure = false // 失败立即停止
    }

    // 【【【请添加或修改此方法】】】
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        // 这是至关重要的设置。如果一个断言失败，测试将立即停止，
        // 而不是继续运行并产生一连串无关的错误。
        continueAfterFailure = false

        let app = XCUIApplication()
        
        // 在每个测试场景（Scenario）开始之前，都重新启动一次App。
        // 这能确保每个测试都在一个干净、独立的环境中运行，避免互相干扰。
        app.launch()
    }

    // 您的 test...() 方法应该保持不变
    func test000000AddAProductToAnEmptyCart() {
        Given("I am a logged-in user")
        And("my shopping cart is empty")
        When(#"I add the product "iPhone 18" to the cart"#)
        Then(#"I should see "1" item in the cart"#)
        And(#"the total price of the cart should be "1299.00" yuan"#)
    }

    func test001001AddASecondProductToTheCart() {
        Given(#"my shopping cart already has "1" item with a total price of "1299.00" yuan"#)
        When(#"I add the product "iPhone 18" to the cart"#)
        Then(#"I should see "2" items in the cart"#)
        And(#"the total price of the cart should be "2598.00" yuan"#)
    }
}
