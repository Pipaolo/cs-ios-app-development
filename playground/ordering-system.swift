import Foundation
/**
 * The View protocol defines the interface that all views must implement.
 */
protocol View {
    func render() -> Void
}


struct MainMenuItem {
    let name: String
    let price: Double
}

struct CartItem {
    var quantity: Int
    var item: MainMenuItem
}

struct Cart {
    var items: [CartItem]
    init() {
        items = []
    }
    func total() -> Double {
        return items.reduce(0, { $0 + $1.item.price * Double($1.quantity) })
    }
    func totalItems() -> Int {
        return items.reduce(0, { $0 + $1.quantity })
    }
}

struct MainMenuCategory {
    let name: String
    let items: [MainMenuItem]
}



class OrderReceiptView: View {
    private let cart: Cart
    private let amountPaid: Double

    init(cart: Cart = Cart(), amountPaid: Double = 0.0) {
        self.cart = cart
        self.amountPaid = amountPaid
    }
    
    public func render(){
        print("-----------------------------------")
        print("|                                 |")
        print("|          Order Receipt          |")
        print("|                                 |")
        print("-----------------------------------")
        // Generate a random order number
        let orderNumber = Int.random(in: 100000...999999)
        print("Receipt Number: \(orderNumber)")
        print("Name of store: RYL Incorporation")
        print("Amount paid: \(amountPaid)")

        print("[1] Back to Main Menu")
        print("[2] Logout")
        print("Select Option: ")
        let selectedIndex = Int(readLine() ?? "") ?? 0
        switch(selectedIndex) {
            case 1:
                MainMenuView(cart: Cart()).render()
                return
            case 2:
                LoginView().render()
                return
            default:
                print("Invalid Option")
                self.render()
                return
        }
    }
}

class OrderPayNowView: View {
    private let cart: Cart
    private let orderNumber: Int
    init(cart: Cart = Cart(), orderNumber: Int = 0) {
        self.cart = cart
        self.orderNumber = orderNumber
    }
    public func render() {
        print("-----------------------------------")
        print("|                                 |")
        print("|          Order Pay Now          |")
        print("|                                 |")
        print("-----------------------------------")

        print("Order Number: \(orderNumber)")
        print("Name: RYL Incorporation")
        print("Enter amount to pay: ")
        let amountPaid = Double(readLine() ?? "") ?? 0.0
        if(amountPaid < cart.total()) {
            print("Insufficient amount")
            self.render()
            return
        }
        OrderReceiptView(cart: cart, amountPaid: amountPaid).render()
        return
    }
}

class OrderDetailsView: View {
    private let cart: Cart
    init(cart: Cart = Cart()) {
        self.cart = cart
    }
    public func render() {
        print("-----------------------------------")
        print("|                                 |")
        print("|          Order Details          |")
        print("|                                 |")
        print("-----------------------------------")
        let orderNumber = Int.random(in: 100000...999999)
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.string(from: now)
        print("Order Number: \(orderNumber)")
        print("Date: \(date)")
        print("Name: Paolo Tolentino")
        print("Items:")
        for item in cart.items {
            print("\(item.item.name) - \(item.item.price) x \(item.quantity) = \(item.item.price * Double(item.quantity))")
        }
        print("Total: \(cart.total())")
        print("[1]. Paynow")
        print("[2]. Cancel")
        print("Select Option: ")
        let selectedIndex = Int(readLine() ?? "") ?? 0

        switch(selectedIndex) {
            case 1:
                OrderPayNowView(cart: cart, orderNumber: orderNumber).render()
                return
            case 2:
                MainMenuView(cart:cart).render()
                return
            default:
                print("Invalid Option")
                self.render()
                return
        }
    
    }
}

class ConfirmationView: View {
    private let cart: Cart
    
    init(cart: Cart = Cart()) {
        self.cart = cart
    }

    public func render() {
        print("-----------------------------------")
        print("|                                 |")
        print("|          Confirmation           |")
        print("|                                 |")
        print("-----------------------------------")
        print("[1]. Confirm")
        print("[2]. Add more items")
        print("Select Option: ")
        let selectedIndex = Int(readLine() ?? "") ?? 0

        switch(selectedIndex) {
            case 1:
                OrderDetailsView(cart: cart).render()
                return
            case 2:
                MainMenuView(cart: cart).render()
                return
            default:
                print("Invalid Option")
                self.render()
                return
        }
    }
}

class MainMenuItemCategoryView: View {
    private var category: MainMenuCategory
    private var cart: Cart

    init(category: MainMenuCategory, cart: Cart = Cart()) {
        self.category = category
        self.cart = cart
    }

    public func render() {
        print("-----------------------------------")
        print("|                                 |")
        print("|          Main Menu              |")
        print("|                                 |")
        print("-----------------------------------")
        print("Category: \(category.name)")
        print("Items:")
        for (index, item) in category.items.enumerated() {
            print("\(index + 1). \(item.name) - \(item.price)")
        }
        print("\(category.items.count + 1). Back")
        print("Select Item: ")
        let selectedIndex = Int(readLine() ?? "") ?? 0
    
        if (selectedIndex > category.items.count + 1) {
            print("Invalid Option")
            self.render()
            return
        }

        // Check if the selected index is the exit option
        let shouldBack = selectedIndex == category.items.count + 1
        if (shouldBack) {
            MainMenuView(cart: cart).render()
            return
        }

        let selectedItem = category.items[selectedIndex - 1]
        print("Selected Item: \(selectedItem.name) - \(selectedItem.price)")
        print("Quantity: ")
        let quantity = Int(readLine() ?? "") ?? 0

        print("Add to cart? (y/n)")
        let shouldAddToCart = readLine() ?? "" == "y"
        if (shouldAddToCart) {
            print("Added to cart")
            cart.items.append(CartItem(
                    quantity: quantity,
                    item: selectedItem
                    )
                )
            MainMenuView(cart: cart).render()
            return
        }

        print("Not added to cart")
        MainMenuView(cart: cart).render()
        return
    }
}

class MainMenuView: View {
    struct State {
        var selectedCategory: MainMenuCategory?
        var cart:Cart
        var categories: [MainMenuCategory]
    }

    private var state = State(
        selectedCategory: nil,
        cart: Cart(),
        categories: [
            MainMenuCategory(name: "Food", items: [
                MainMenuItem(name: "Sisig", price: 100),
                MainMenuItem(name: "Adobong Manak", price: 75),
                MainMenuItem(name: "Senegeng-geng na Porks", price: 85),
                MainMenuItem(name: "Laki Me Cockatoo", price: 20),
                MainMenuItem(name: "Century Tunae", price: 35),
            ]),
            MainMenuCategory(name: "Drinks", items: [
                MainMenuItem(name: "Coka-Kula 250ml", price: 30),
                MainMenuItem(name: "I-sprite 250ml", price: 30),
                MainMenuItem(name: "Ruyal", price: 30),
                MainMenuItem(name: "Meowtain Jew", price: 35),
                MainMenuItem(name: "Almold Nazis Milke", price: 40),
            ]),
        ]
    )

      init(cart: Cart = Cart()) {
        state.cart = cart
    }
    

    private func showCategories() {
        print("Categories:")
        for (index, category) in state.categories.enumerated() {
            print("\(index + 1). \(category.name)")
        }
        print("\(state.categories.count + 1). Checkout")
        print("\(state.categories.count + 2). Exit")

    }
    
    public func render() {
        print("-----------------------------------")
        print("|                                 |")
        print("|          Main Menu              |")
        print("|                                 |")
        print("-----------------------------------")
        print("Cart: \(state.cart.items.count) items")
        showCategories()
        print("Select Category: ")
        let selectedIndex = Int(readLine() ?? "") ?? 0

        if (selectedIndex > state.categories.count + 2) {
            print("Invalid Option")
            self.render()
            return
        }
        // Check if the selected index is the exit option
        let shouldExit = selectedIndex == state.categories.count + 2
        if (shouldExit) {
            print("Goodbye!")
            return
        }  

        // Check if the selected index is the checkout option
        let shouldCheckout = selectedIndex == state.categories.count + 1
        if (shouldCheckout) {
            ConfirmationView(cart: state.cart).render()
            return
        }

        state.selectedCategory = state.categories[selectedIndex - 1]
        
        if (state.selectedCategory == nil) {
            print("Invalid Category")
            self.render()
            return
        }
        
        MainMenuItemCategoryView(category: state.selectedCategory!, 
                                cart: state.cart).render()
    }
}


class LoginView: View {
    struct State {
        var retries: Int = 0
        var username: String = ""
        var password: String = ""
        let correctPassword = "1234"
        let correctUsername = "user"

        func isCorrectCredentials() -> Bool {
            return password == correctPassword && username == correctUsername
        }

        func isLocked() -> Bool {
            return retries >= 3
        }
    }

    private var state = State()

    public func render() {
        if(state.isLocked()){
            print("Too many retries. Try again later.")
            return
        }

        print("\n\n")
        print("-----------------------------------")
        print("|                                 |")
        print("|          Login Screen           |")
        print("|                                 |")
        print("-----------------------------------")
        print("Enter Username: ")
        state.username = readLine() ?? ""
        
        print("Enter Password: ")
        state.password = readLine() ?? ""
        
        if(!state.isCorrectCredentials()){
            print("Incorrect Password")
            state.retries += 1
            self.render()
            return
        }

        print("Login Successful")
        MainMenuView().render()
        return
    }
}


class GreetingsView: View {
    public func render() {
        print("-----------------------------------")
        print("|                                 |")
        print("|     Welcome to the RYL Shop     |")
        print("|                                 |")
        print("-----------------------------------")
    }


}


class OrderingSystemApplication {
    public func start() {
        GreetingsView().render()
        LoginView().render()
    }
}

var app = OrderingSystemApplication()
app.start()
