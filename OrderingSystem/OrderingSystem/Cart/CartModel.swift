//
//  File.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import Foundation
struct CartItem: Equatable, Identifiable {
    var id: UUID = .init()
    var product: Product = .init()
    var quantity: Int = 1
}

struct Cart: Equatable {
    var items: [CartItem] = []
}

struct CartModel: ReducerProtocol {
    struct State: Equatable {
        var cart: Cart = .init()
    }

    enum Actions: Equatable {
        case itemAdded(Product)
        case itemRemoved(Product)
        case itemQuantityChanged(Product, Int)
    }

    var body: some ReducerProtocol<State, Actions> {
        Reduce { state, action in
            switch action {
            case .itemAdded(let product):
                state.cart.items.append(.init(product: product))
                return .none
            case .itemRemoved(let product):
                state.cart.items.removeAll { $0.product == product }
                return .none
            case .itemQuantityChanged(let product, let quantity):
                if let index = state.cart.items.firstIndex(where: { $0.product == product }) {
                    state.cart.items[index].quantity = quantity
                }
                return .none
            }
        }
    }
}
