//
//  CartView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import SwiftUI

struct CartView: View {
    let store: StoreOf<CartModel>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                if viewStore.items.isEmpty {
                    Text("Please add items to your cart")
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                        .padding(.all, 12)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.all, 12)
                        .foregroundColor(.black)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.center)
                }

                if !viewStore.items.isEmpty {
                    VStack(alignment: .listRowSeparatorTrailing) {
                        Button {
                            viewStore.send(.clearCartRequested)
                        } label: {
                            Text("Clear Items")
                        }

                        .foregroundColor(Color.red)
                    }
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity,
                           alignment: .trailing)

                    List {
                        ForEachStore(self.store.scope(state: \.items, action: CartModel.Action.cartItem(id:action:))
                        ) { cartItemStore in
                            CartItemView(store: cartItemStore)
                        }
                    }
                }

                Spacer()
                VStack {
                    VStack(spacing: 12) {
                        HStack {
                            Text("Total Items:")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(viewStore.state.totalItemCount())pcs")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        HStack {
                            Text("Total:")
                                .font(.headline)
                                .fontWeight(.bold)
                            Spacer()
                            Text("P\(viewStore.state.total(), specifier: "%.2f")")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                    }
                    Button {
                        viewStore.send(.checkoutPressed)
                    } label: {
                        Text("Checkout")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                    .disabled(viewStore.items.isEmpty)
                    .buttonStyle(.borderedProminent)
                }.padding(.all, 12)
            }
        }
        .navigationTitle("Cart")
        .confirmationDialog(self.store.scope(state: \.confirmationDialog, action: { $0 }), dismiss: .clearCartDismissed)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(
            store: .init(initialState: .init(), reducer: CartModel())
        )
    }
}
