Feature: ShoppingCartTests
  As a user, I want to add products to my shopping cart and see the total price update correctly.

  Scenario: 000 Add A Product To An Empty Cart
    Given I am a logged-in user
    And my shopping cart is empty
    When I add the product "iPhone 18" to the cart
    Then I should see "1" item in the cart
    And the total price of the cart should be "1299.00" yuan

  Scenario: 001 Add A Second Product To The Cart
    Given my shopping cart already has "1" item with a total price of "1299.00" yuan
    When I add the product "iPhone 18" to the cart
    Then I should see "2" items in the cart
    And the total price of the cart should be "2598.00" yuan

