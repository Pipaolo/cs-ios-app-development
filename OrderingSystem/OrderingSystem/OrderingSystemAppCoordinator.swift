//
//  OrderingSystemAppCoordinator.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/9/23.
//
import ComposableArchitecture
import Foundation
import SwiftUI
import TCACoordinators

struct OrderingSystemAppCoordinator: ReducerProtocol {
    struct State: IdentifiedRouterState, Equatable {
        static let initialState = Self(routeIDs: [.root(.login, embedInNavigationView: true)])
        
        var loginState = LoginModel.State()
        var mainMenuState = MainMenuModel.State(user: .init(), cart: .init())
        var categoryDetailState = CategoryDetailModel.State(
            category: .init(name: "test", products: [])
        )
        var productAddToCartState = ProductAddToCartModel.State()
        var cartState = CartModel.State()
        var checkoutState = CheckoutModel.State(
            cart: .init()
        )
        var checkoutSuccessState = CheckoutSuccessModel.State()
        
        var routeIDs: IdentifiedArrayOf<Route<AppScreen.State.ID>>
        var routes: IdentifiedArrayOf<Route<AppScreen.State>> {
            get {
                let routes = routeIDs.map { route -> Route<AppScreen.State> in
                    route.map { id in
                        switch id {
                        case .login:
                            return .login(loginState)
                        case .mainMenu:
                            return .mainMenu(mainMenuState)
                        case .categoryDetail:
                            return .categoryDetail(categoryDetailState)
                        case .productAddToCart:
                            return .productAddToCart(productAddToCartState)
                        case .cart:
                            return .cart(cartState)
                        case .checkout:
                            return .checkout(checkoutState)
                        case .checkoutSuccess:
                            return .checkoutSuccess(checkoutSuccessState)
                        }
                    }
                }
                return IdentifiedArray(uniqueElements: routes)
            }
            set {
                let routeIDs = newValue.map { route -> Route<AppScreen.State.ID> in
                    route.map { id in
                        switch id {
                        case .login(let loginState):
                            self.loginState = loginState
                            return .login
                            
                        case .mainMenu(let mainMenuState):
                            self.mainMenuState = mainMenuState
                            return .mainMenu
                            
                        case .categoryDetail(let categoryDetailState):
                            self.categoryDetailState = categoryDetailState
                            return .categoryDetail
                        
                        case .productAddToCart(let productAddToCartState):
                            self.productAddToCartState = productAddToCartState
                            return .productAddToCart
                    
                        case .cart(let cartState):
                            self.cartState = cartState
                            return .cart
                        case .checkout(let checkoutState):
                            self.checkoutState = checkoutState
                            return .checkout
                        case .checkoutSuccess(let checkoutSuccessState):
                            self.checkoutSuccessState = checkoutSuccessState
                            return .checkoutSuccess
                        }
                    }
                }
                
                self.routeIDs = IdentifiedArray(uniqueElements: routeIDs)
            }
        }
    }
    
    enum Action: IdentifiedRouterAction {
        case updateRoutes(IdentifiedArrayOf<Route<AppScreen.State>>)
        case routeAction(AppScreen.State.ID, action: AppScreen.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .routeAction(_, action: .login(.submitted)):
                if state.loginState.error != "" {
                    return .none
                }
                state.mainMenuState.user = state.loginState.user ?? .init()
                state.routeIDs = [.root(.mainMenu, embedInNavigationView: true)]
                return .none
            case .routeAction(_, action: .mainMenu(.categorySelected(let category))):
                state.categoryDetailState.category = category
                state.routeIDs.push(.categoryDetail)
                return .none
            case .routeAction(_, action: .mainMenu(.logoutPressed)):
                // Clear the cart
                state.cartState = .init()
                state.mainMenuState.cart = state.cartState
                
                // Navigate to the login screen
                state.routeIDs = [.root(.login, embedInNavigationView: true)]
                return .none
            case .routeAction(_, action: .categoryDetail(.productSelected(let product))):
                state.productAddToCartState.product = product
                state.routeIDs.presentSheet(.productAddToCart, embedInNavigationView: true)
                return .none
            case .routeAction(_, action: .mainMenu(.cartViewed)):
                state.routeIDs.push(.cart)
                return .none
            case .routeAction(_, action: .cart(.cartItem(_, action: .binding(\.$quantity)))):
                state.mainMenuState.cart = state.cartState
                return .none
            case .routeAction(_, action: .cart(.checkoutPressed)):
                state.checkoutState.cart = state.cartState
                state.routeIDs.push(.checkout)
                return .none
            case .routeAction(_, action: .cart(.clearCartConfirmed)):
                state.mainMenuState.cart = state.cartState
                return .none
            case .routeAction(_, action: .checkout(.orderPlaced)):
                state.checkoutSuccessState = .init(
                    items: state.checkoutState.cart.items,
                    shippingMethod: state.checkoutState.shippingMethod,
                    paymentMethod: state.checkoutState.payment.paymentMethod.description,
                    total: state.cartState.total()
                )
                
                state.checkoutSuccessState.generateOrderNumber()
                
                // Clear the cart
                state.cartState.items = []
                state.mainMenuState.cart = state.cartState
                
                state.routeIDs.goBackTo(where: { route in route.id == .mainMenu })
                state.routeIDs.push(.checkoutSuccess)
                return .none
            case .routeAction(_, action: .checkoutSuccess(.orderAgainPressed)):
                state.routeIDs.goBack(1)
                return .none
            case .routeAction(_, action: .productAddToCart(.alertDismissed)):
                state.routeIDs.goBack(1)
                return .none
            case .routeAction(_, action: .productAddToCart(.cancelled)):
                state.routeIDs.goBack(1)
                return .none
            case .routeAction(_, action: .productAddToCart(.cartAdded(let cartItem))):
          
                // Add the cart item to the cart
                state.cartState.items.append(CartItemModel.State(id: cartItem.id,
                                                                 product: cartItem.product,
                                                                 quantity: cartItem.quantity)
                )
                
                // Update the main menu state's cart
                state.mainMenuState.cart = state.cartState
                return .none
            default:
                return .none
            }
        }.forEachRoute {
            AppScreen(environment: .init(
                userService: .init(),
                productsService: .init()
            )
            )
        }
    }
}

struct OrderingSystemAppCoordinatorView: View {
    let store: StoreOf<OrderingSystemAppCoordinator>
    
    var body: some View {
        TCARouter(store) {
            screen in
            SwitchStore(screen) {
                CaseLet(state: /AppScreen.State.login, action: AppScreen.Action.login, then: LoginView.init(store:))
                
                CaseLet(state: /AppScreen.State.mainMenu,
                        action: AppScreen.Action.mainMenu,
                        then: MainMenuView.init(store:))
                CaseLet(state: /AppScreen.State.categoryDetail,
                        action: AppScreen.Action.categoryDetail,
                        then: CategoryDetailView.init(store:))
                CaseLet(state: /AppScreen.State.productAddToCart,
                        action: AppScreen.Action.productAddToCart,
                        then: ProductAddToCartView.init(store:))
                CaseLet(state: /AppScreen.State.cart,
                        action: AppScreen.Action.cart,
                        then: CartView.init(store:))
                
                CaseLet(state: /AppScreen.State.checkout,
                        action: AppScreen.Action.checkout,
                        then: CheckoutView.init(store:))
                
                CaseLet(state: /AppScreen.State.checkoutSuccess,
                        action: AppScreen.Action.checkoutSuccess,
                        then: CheckoutSuccessView.init(store:))
            }
        }
    }
}
