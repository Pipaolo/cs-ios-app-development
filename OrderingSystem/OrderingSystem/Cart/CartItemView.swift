//
//  CartItemView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import SwiftUI

struct CartItem: Equatable, Identifiable {
    var id: UUID = .init()
    var product: Product = .init()
    var quantity: Int = 1
}

struct CartItemModel: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id: UUID
        var product: Product = .init()
        @BindingState var quantity: Int = 1
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce {
            _, action in
            switch action {
            case .binding(\.$quantity):
                // TODO: Remove the item from the cart
                return .none
            default:
                return .none
            }
        }
    }
}

struct CartItemView: View {
    let store: StoreOf<CartItemModel>
    private let range = 0 ... 99

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Stepper(value: viewStore.binding(\.$quantity),
                    in: range)
            {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(viewStore.product.name)
                                .font(.headline)
                                .fontWeight(.bold)
                            Text("P\(viewStore.product.price, specifier: "%.2f")")
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        VStack {
                            Text("x\(viewStore.quantity)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .padding(.all, 8)
                        }
                        .background(Color.gray)
                        .cornerRadius(8)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct CartItemView_Previews: PreviewProvider {
    static var previews: some View {
        CartItemView(
            store: .init(initialState: .init(id: .init()
            ), reducer: CartItemModel())
        )
    }
}
