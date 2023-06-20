//
//  MainMenuModel.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import Foundation
import TCACoordinators

struct MainMenuModel: ReducerProtocol {
    let productsService: ProductsService

    struct State: Equatable {
        var user: User
        var isLoading: Bool = true
        var cart: CartModel.State
        var selectedCategory: ProductCategory?
        var products: IdentifiedArrayOf<MainMenuProductItemModel.State> = []
        var categories: [ProductCategory] = []
    }

    enum Action: Equatable {
        case categoriesFetched
        case cartViewed
        case logoutPressed
        case categoriesLoaded([ProductCategory])
        case categorySelected(ProductCategory)
        case categoryFiltered(ProductCategory)
        case product(id: MainMenuProductItemModel.State.ID, action: MainMenuProductItemModel.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .categorySelected:
                return .none
            case .categoryFiltered(let category):
                let cartItems = state.cart.items

                state.selectedCategory = category
                state.products = IdentifiedArray(uniqueElements: category.products.map { product in
                    let cartItem = cartItems.first {
                        $0.product.id == product.id
                    }

                    return MainMenuProductItemModel.State(id: product.id, data: product, cartItem: cartItem)
                })
                return .none
            case .categoriesFetched:
                state.isLoading = true
                return .run { send in
                    // Get the categories from the service
                    do {
                        let categories = try await productsService.fetchCategories()
                        await send(.categoriesLoaded(categories))
                        await send(.categoryFiltered(categories.first!))
                    } catch {}
                }
            case .categoriesLoaded(let categories):
                state.isLoading = false
                state.categories = categories

                return .none
            case .product(let id, action: /.addedToCart):
                guard let product = state.products[id: id] else {
                    return .none
                }

                state.cart.items.append(
                    .init(
                        id: product.id,
                        product: product.data,
                        quantity: 1
                    )
                )
                return .none
            case .product(let id, action: .removedFromCart):
                state.cart.items.remove(id: id)
                return .none
            case .product(let id, action: .quantityChanged(let quantity)):
                state.cart.items[id: id]?.quantity += quantity
                return .none
            default:
                return .none
            }
        }.forEach(\.products, action: /Action.product(id:action:)) {
            MainMenuProductItemModel()
        }
    }
}
