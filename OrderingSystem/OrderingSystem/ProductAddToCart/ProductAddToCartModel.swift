//
//  ProductAddToCartModel.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import Foundation

struct ProductAddToCartModel: ReducerProtocol {
    struct State: Equatable {
        @BindingState var quantity: String = "1"
        var product: Product = .init()
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case cartAdded(CartItem)
        case cancelled
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { _, action in
            switch action {
            case .binding:
                return .none
            case .cartAdded:
                return .none
            default:
                return .none
            }
        }
    }
}
