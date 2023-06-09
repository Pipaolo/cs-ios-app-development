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
                Text("Cart")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                List {
                    ForEach(viewStore.cart.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.product.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("\(item.product.price)")
                                    .font(.callout)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            Stepper("\(item.quantity)", value: .constant(1))
                        }
                    }
                }
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView(
            store: .init(initialState: .init(), reducer: CartModel())
        )
    }
}
