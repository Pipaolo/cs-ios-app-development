//
//  CategoryDetailView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import SwiftUI

struct CategoryDetailView: View {
    let store: StoreOf<CategoryDetailModel>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                VStack(alignment: .leading) {
                    Text("Please choose category: ").font(.callout)
                    ScrollView {
                        ForEach(viewStore.products) { product in
                            HStack {
                                Text(product.name).fontWeight(.bold)
                                    .font(.system(size: 18))
                                    .padding(.all, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                Text("P\(product.price, specifier: "%.2f")")
                                    .fontWeight(.bold)
                                    .font(.system(size: 18))
                                    .padding(.horizontal, 12)
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onTapGesture {
                                viewStore.send(.productSelected(product))
                            }

                        }.padding(.all, 12)
                    }
                }.padding(.all, 12)
            }
            .navigationTitle(viewStore.category.name)
            .onAppear {
                viewStore.send(.productsFetched)
            }
        }
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailView(
            store: .init(
                initialState: .init(category: .init()
                ),
                reducer: CategoryDetailModel(
                    productsService: .init()
                )
            )
        )
    }
}
