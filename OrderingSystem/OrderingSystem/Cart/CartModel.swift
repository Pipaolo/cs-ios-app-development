//
//  File.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct CartModel: ReducerProtocol {
    struct State: Equatable {
        var items: IdentifiedArrayOf<CartItemModel.State> = []

        var confirmationDialog: ConfirmationDialogState<Action>?

        func total() -> Double {
            items.reduce(0) { total, item in
                total + item.product.price * Double(item.quantity)
            }
        }

        func totalItemCount() -> Int {
            items.reduce(0) { total, item in
                total + item.quantity
            }
        }
    }

    enum Actions: Equatable {
        case cartItem(id: CartItemModel.State.ID, action: CartItemModel.Action)
        case checkoutPressed
        case clearCartRequested
        case clearCartConfirmed
        case clearCartDismissed
    }

    var body: some ReducerProtocol<State, Actions> {
        Reduce { state, action in
            switch action {
            case .clearCartConfirmed:
                state.items = []
                return .none
            case .clearCartDismissed:
                state.confirmationDialog = nil
                return .none
            case .clearCartRequested:
                let items = state.items

                state.confirmationDialog = ConfirmationDialogState {
                    TextState("Clear Cart?")
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Cancel")
                    }
                    ButtonState(action: .clearCartConfirmed) {
                        TextState("Confirm")
                            .fontWeight(.bold)
                    }

                } message: {
                    TextState("You are about to delete \(items.count) products in cart. \n Do you wish to continue?")
                }

                return .none
            case .cartItem(let id, .binding(\.$quantity)):
                guard var item = state.items[id: id] else {
                    return .none
                }
                if item.quantity == 0 {
                    state.items.remove(id: id)
                }
                return .none
            default:
                return .none
            }
        }.forEach(\.items, action: /Action.cartItem(id:action:)) {
            CartItemModel()
        }
    }
}
