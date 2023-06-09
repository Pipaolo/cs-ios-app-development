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
        var categories: [ProductCategory] = []
    }

    enum Action: Equatable {
        case categoriesFetched
        case categoriesLoaded([ProductCategory])
        case categorySelected(ProductCategory)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .categorySelected:
                return .none
            case .categoriesFetched:
                return .run { send in
                    // Get the categories from the service
                    do {
                        let categories = try await productsService.fetchCategories()
                        await send(.categoriesLoaded(categories))
                    } catch {}
                }
            case .categoriesLoaded(let categories):
                state.isLoading = false
                state.categories = categories
                return .none
            }
        }
    }
}
