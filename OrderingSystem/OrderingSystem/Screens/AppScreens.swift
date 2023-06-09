import ComposableArchitecture
import Foundation
import SwiftUI

struct AppScreenEnvironment {
    let userService: UserService
    let productsService: ProductsService
}

struct AppScreen: ReducerProtocol {
    let environment: AppScreenEnvironment

    enum State: Equatable, Identifiable {
        case login(LoginModel.State)
        case mainMenu(MainMenuModel.State)
        case categoryDetail(CategoryDetailModel.State)
        case productAddToCart(ProductAddToCartModel.State)
        case cart(CartModel.State)

        var id: ID {
            switch self {
                case .login:
                    return .login
                case .mainMenu:
                    return .mainMenu
                case .categoryDetail:
                    return .categoryDetail
                case .productAddToCart:
                    return .productAddToCart
                case .cart:
                    return .cart
            }
        }

        enum ID: Identifiable {
            case login
            case mainMenu
            case categoryDetail
            case productAddToCart
            case cart

            var id: ID {
                self
            }
        }
    }

    enum Action: Equatable {
        case login(LoginModel.Action)
        case mainMenu(MainMenuModel.Action)
        case categoryDetail(CategoryDetailModel.Action)
        case productAddToCart(ProductAddToCartModel.Action)
        case cart(CartModel.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Scope(state: /State.login, action: /Action.login) {
            LoginModel(userService: environment.userService)
        }

        Scope(state: /State.mainMenu, action: /Action.mainMenu) {
            MainMenuModel(
                productsService: environment.productsService
            )
        }

        Scope(state: /State.categoryDetail, action: /Action.categoryDetail) {
            CategoryDetailModel(
                productsService: environment.productsService
            )
        }

        Scope(state: /State.productAddToCart, action: /Action.productAddToCart) {
            ProductAddToCartModel()
        }

        Scope(state: /State.cart, action: /Action.cart) {
            CartModel()
        }
    }
}
