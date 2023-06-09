//
//  ProductAddToCartView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import SwiftUI

struct ProductAddToCartView: View {
    let store: StoreOf<ProductAddToCartModel>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 24) {
                Text("Add To Cart")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                VStack(alignment: .leading) {
                    Text("Quantity").fontWeight(.bold)
                    TextField(text: viewStore.binding(\.$quantity)) {
                        Text("Quantity")
                    }
                    .keyboardType(.numberPad)
                    .padding(.all, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                }
                HStack {
                    Button {
                        viewStore.send(.cancelled)
                    }
                    label: {
                        Text("Cancel")
                            .frame(maxWidth: .infinity)
                    }.buttonStyle(.bordered)
                    .foregroundColor(Color.red)
                    Button {
                        let cartItem = CartItem(product: viewStore.product, quantity: Int(viewStore.quantity) ?? 1)

                        viewStore.send(.cartAdded(cartItem))
                    } label: {
                        Text("Confirm")
                            .frame(maxWidth: .infinity)
                    }.buttonStyle(.bordered)
                }
                Spacer()
            }
            .navigationTitle("Add to cart")
            .padding(.all, 12)
        }
    }
}

struct ProductAddToCartView_Previews: PreviewProvider {
    static var previews: some View {
        ProductAddToCartView(
            store: .init(
                initialState: .init(),
                reducer: ProductAddToCartModel()
            )
        )
    }
}
