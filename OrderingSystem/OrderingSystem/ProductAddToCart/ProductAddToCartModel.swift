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
        var alert: AlertState<Action>?
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case cartAdded(CartItem)
        case cancelled
        case alertDismissed
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .alertDismissed:
                state.alert = nil
                return .none
            case .cartAdded(let item):
                state.alert = AlertState {
                    TextState("\(item.product.name) added to cart!")
                }
                return .none
            default:
                return .none
            }
        }
    }
}
