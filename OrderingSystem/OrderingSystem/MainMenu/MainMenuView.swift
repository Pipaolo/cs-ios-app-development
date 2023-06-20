//
//  MainMenuView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import SwiftUI

struct MainMenuView: View {
    let store: StoreOf<MainMenuModel>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(alignment: .top) {
                VStack {
                    HStack {
                        Text("RYL Eatery")
                            .font(.title3)
                            .fontWeight(.bold)
                            .frame(
                                maxWidth: .infinity, alignment: .leading
                            )

                    }.padding()

                    if viewStore.isLoading {
                        VStack(spacing: 12) {
                            Spacer()
                            ProgressView()
                            Text("Loading...")
                                .fontWeight(.bold)
                                .font(.system(size: 12))
                            Spacer()
                        }
                    } else {
                        MainMenuCategoryFilters(store: store)
                        MainMenuProductList(store: store)
                    }
                    Button {
                        viewStore.send(.logoutPressed)
                    } label: {
                        Text("Logout")
                            .foregroundColor(Color.red)
                    }
                }
            }
            .toolbar {
                Button {
                    viewStore.send(.cartViewed)
                } label: {
                    HStack {
                        Image(systemName: "cart")
                        if viewStore.cart.items.isEmpty {
                            Text("Cart")
                        } else {
                            Text("Cart (\(viewStore.cart.items.count))")
                        }
                    }
                    .fontWeight(.bold)
                }
            }
            .onAppear {
                viewStore.send(.categoriesFetched)
            }
            .navigationTitle("Main Menu")
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView(
            store: .init(
                initialState: .init(
                    user: .init(),
                    cart: .init()
                ),
                reducer: MainMenuModel(
                    productsService: .init()
                )
            )
        )
    }
}
