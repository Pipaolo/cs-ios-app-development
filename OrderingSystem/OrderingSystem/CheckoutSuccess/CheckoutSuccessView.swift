//
//  CheckoutSuccessView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import SwiftUI

struct CheckoutSuccessModel: ReducerProtocol {
    struct State: Equatable {
        var items: IdentifiedArrayOf<CartItemModel.State> = [
            .init(id: .init()),
            .init(id: .init()),
        ]
        var shippingMethod: String = "Pick-up"
        var paymentMethod: String = "Cash on Delivery"
        var total: Double = 0.0

        var orderNumber: String = ""
        var receiptNumber: String = ""

        mutating func generateOrderNumber() {
            // Generate a random order number
            orderNumber = String(Int.random(in: 100000000 ..< 1000000000))

            // Generate a random receipt number
            receiptNumber = String(Int.random(in: 100000000 ..< 1000000000))
        }
    }

    enum Action: Equatable {
        case orderAgainPressed
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { _, action in
            switch action {
            default:
                return .none
            }
        }
    }
}

struct CheckoutSuccessView: View {
    let store: StoreOf<CheckoutSuccessModel>
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 12) {
                Text("Ryl Incorporation").font(.title)
                    .fontWeight(.bold)
                Text("Order #: \(viewStore.orderNumber)")
                    .font(.headline)
                    .fontWeight(.semibold)
                Text("Receipt #: \(viewStore.receiptNumber)")
                    .font(.headline)
                    .fontWeight(.semibold)

                List {
                    ForEach(viewStore.items) { item in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(item.product.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("P\(item.product.price, specifier: "%.2f")")
                                    .font(.subheadline)
                                Text("Quantity: \(item.quantity)")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Text("P\(item.product.price * Double(item.quantity), specifier: "%.2f")")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                }
                .cornerRadius(12)
                VStack(spacing: 12) {
                    HStack {
                        Text("Shipping Method:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(viewStore.shippingMethod)
                            .font(.headline)
                    }

                    HStack {
                        Text("Payment Method:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(viewStore.paymentMethod)
                            .font(.headline)
                    }

                    HStack {
                        Text("Total:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Spacer()
                        Text("P\(viewStore.total, specifier: "%.2f")")
                            .font(.headline)
                    }

                    Button {
                        viewStore.send(.orderAgainPressed)
                    } label: {
                        Text("Order Again")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .tint(.accentColor)
                }
                .padding(.top, 12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.all, 12)
            .navigationTitle("Order placed!")
        }
    }
}

struct CheckoutSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutSuccessView(
            store: .init(
                initialState: .init(),
                reducer: CheckoutSuccessModel()
            )
        )
    }
}
