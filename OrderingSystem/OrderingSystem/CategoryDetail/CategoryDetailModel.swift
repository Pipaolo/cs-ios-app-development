//
//  CategoryDetailModel.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct CategoryDetailModel: ReducerProtocol {
    let productsService: ProductsService

    struct State: Equatable {
        var category: ProductCategory
        var isLoading: Bool = true
        var products: [Product] = []
    }

    enum Action: Equatable {
        case productsFetched
        case productsLoaded([Product])
        case productSelected(Product)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .productsFetched:
                return .run { [state] send in
                    // Get the categories from the service
                    do {
                        try await Task.sleep(nanoseconds: 0)
                        print(state.category)

                        await send(.productsLoaded(state.category.products))
                    } catch {}
                }
            case .productsLoaded(let products):
                state.isLoading = false
                state.products = products
                return .none
            default:
                return .none
            }
        }
    }
}
