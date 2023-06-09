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
                        Text("\(viewStore.user.firstName)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(
                                maxWidth: .infinity, alignment: .leading
                            )

                        Button {} label: {
                            if viewStore.cart.cart.items.isEmpty {
                                Text("Cart")
                            } else {
                                Text("Cart (\(viewStore.cart.cart.items.count))")
                            }
                        }
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
                        VStack(alignment: .leading) {
                            Text("Please choose category: ").font(.callout)
                            ScrollView {
                                ForEach(viewStore.categories) { category in
                                    VStack(alignment: .leading) {
                                        Text(category.name).fontWeight(.bold)
                                            .font(.system(size: 18))
                                            .padding(.all, 12)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .onTapGesture {
                                        viewStore.send(.categorySelected(category))
                                    }

                                }.padding(.all, 12)
                            }
                        }.padding(.all, 12)
                    }
                }
            }
            .navigationTitle("Main Menu")
            .onAppear {
                viewStore.send(.categoriesFetched)
            }
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
