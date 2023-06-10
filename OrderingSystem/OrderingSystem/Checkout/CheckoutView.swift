//
//  SwiftUIView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import SwiftUI

struct CheckoutModel: ReducerProtocol {
    struct State: Equatable {
        var cart: CartModel.State
        var payment: PaymentDetailsModel.State = .init()

        @BindingState var shippingMethod: String = "Pick-Up"
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case orderPlaced
        case payment(PaymentDetailsModel.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Scope(
            state: \.payment,
            action: /Action.payment
        ) {
            PaymentDetailsModel()
        }

        Reduce { state, action in
            switch action {
            case .payment(.binding(\.$paymentMethod)):
                print("Printing from parent: ", state.payment.paymentMethod)
                return .none
            default:
                return .none
            }
        }
    }
}

struct CheckoutView: View {
    let store: StoreOf<CheckoutModel>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text("Summary")
                        .font(.title)
                        .fontWeight(.semibold)

                    List {
                        ForEach(viewStore.cart.items) { item in
                            HStack(alignment: .top) {
                                VStack(alignment: .leading) {
                                    Text(item.product.name)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text("P\(item.product.price, specifier: "%.2f")")
                                        .font(.subheadline)
                                }
                                Spacer()
                                Text("x1")
                                Spacer()
                                Text("P\(item.product.price * Double(item.quantity), specifier: "%.2f")"
                                )
                                .font(.subheadline)
                                .fontWeight(.bold)
                            }
                        }
                    }
                    .cornerRadius(12)
                }
                VStack(spacing: 12) {
                    HStack {
                        Text("Shipping Method")
                            .fontWeight(.semibold)
                        Spacer()
                        Text(viewStore.shippingMethod)
                    }
                    HStack {
                        Text("Payment Method")
                            .fontWeight(.semibold)
                        Spacer()
                        PaymentDetailsView(
                            store: self.store.scope(state: \.payment, action: CheckoutModel.Action.payment)
                        )
                    }
                    HStack {
                        Text("Total:")
                            .font(.title)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("P\(viewStore.cart.total(), specifier: "%.2f")")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    Button {
                        viewStore.send(.orderPlaced)
                    } label: {
                        Text("Place Order")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.all, 12)
            .navigationTitle("Checkout")
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(
            store: .init(
                initialState: .init(cart: .init()),
                reducer: CheckoutModel()
            )
        )
    }
}
