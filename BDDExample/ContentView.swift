import SwiftUI

struct Product: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let price: Double
}

struct ContentView: View {
    @State private var cartItems: [Product] = []

    let products = [
        Product(name: "iPhone 18", price: 1299.00),
        Product(name: "MacBook Pro 16", price: 2499.00),
        Product(name: "Apple Watch Ultra", price: 799.00)
    ]

    var totalPrice: Double {
        cartItems.reduce(0) { $0 + $1.price }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Displays cart item count
                Text("\(cartItems.count)") // Displays only the number, matching step "(\d+)"
                    .font(.headline)
                    .padding(.top)
                    .accessibilityIdentifier("cart_badge_count") // Matches step definition
                    .accessibilityLabel("Items in cart: \(cartItems.count)") // For VoiceOver

                // Displays calculated total price
                // Format: "总价: X.XX" (ensure colon and space match)
                Text("总价: \(String(format: "%.2f", totalPrice))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom)
                    .accessibilityIdentifier("cart_total_price") // Matches step definition

                // Product list
                List(products) { product in
                    HStack {
                        Text(product.name)
                            .font(.title3)
                        Text("\(String(format: "%.2f", product.price)) 元") // Display price with unit
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Spacer()

                        Button(action: {
                            cartItems.append(product)
                        }) {
                            Image(systemName: "cart.badge.plus")
                                .font(.title2)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .accessibilityIdentifier(product.name) // Matches step definition's `addProductToCart`
                    }
                }
                .navigationTitle("Product List")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
