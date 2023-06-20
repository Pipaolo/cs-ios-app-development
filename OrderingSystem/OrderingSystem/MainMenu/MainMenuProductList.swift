//
//  MainMenuProductCategory.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/19/23.
//
import ComposableArchitecture
import SwiftUI

struct MainMenuProductList: View {
    var store: StoreOf<MainMenuModel>

    private let columns = [
        GridItem(.adaptive(minimum: 100), spacing: 12),
        GridItem(.adaptive(minimum: 100), spacing: 12),
    ]

    var body: some View {
        WithViewStore(store, observe: { $0 }) { _ in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEachStore(store.scope(state: \.products, action: MainMenuModel.Action.product(id: action:))) {
                        productStore in MainMenuProductItem(store: productStore)
                    }
                }.padding(.all, 12)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct MainMenuProductItemModel: ReducerProtocol {
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .addedToCart:
            state.cartItem = .init(id: state.data.id, product: state.data, quantity: 1)
            state.cartAddedAlert = .init(
                title: TextState("Added \(state.data.name) to cart"),
                dismissButton: .default(TextState("OK"))
            )

        case .removedFromCart:
            state.cartItem = nil
        case .quantityChanged(let quantity):
            state.cartItem?.quantity += quantity
        case .cartAddedAlertDismissed:
            state.cartAddedAlert = nil
        }

        return .none
    }

    struct State: Equatable, Identifiable {
        var id: UUID = .init()
        var data: Product
        var cartItem: CartItemModel.State?
        var cartAddedAlert: AlertState<Action>? = nil
    }

    enum Action: Equatable {
        case addedToCart
        case removedFromCart
        case quantityChanged(Int)
        case cartAddedAlertDismissed
    }
}

struct MainMenuProductItem: View {
    var store: StoreOf<MainMenuProductItemModel>

    var body: some View {
        WithViewStore(store, observe: { $0 }) {
            viewStore in
            let product = viewStore.data
            let cartItem = viewStore.cartItem

            VStack(alignment: .center, spacing: 12) {
                AsyncImage(
                    url: URL(string: product.imageUrl)
                )
                .frame(maxWidth: 100, maxHeight: 100)
                .aspectRatio(contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading) {
                    Text(product.name)
                        .font(.system(size: 14))
                        .foregroundColor(.black)

                    Text("₱\(product.price, specifier: "%.2f")")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }.frame(maxWidth: .infinity,
                        alignment: .leading)

                Spacer()

                if cartItem == nil {
                    Button {
                        viewStore.send(.addedToCart)
                    } label: {
                        Text("Add to cart")
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                    }
                    .foregroundColor(.white)
                    .background(Color.purple)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 12)
                    )
                }

                // Quantity Button
                if cartItem != nil {
                    HStack(spacing: 12) {
                        Button {
                            let quantity = cartItem!.quantity - 1
                            if quantity <= 0 {
                                viewStore.send(.removedFromCart)
                                return
                            }
                            viewStore.send(.quantityChanged(-1))
                        } label: {
                            Image(systemName: "minus")

                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )

                        Text("\(cartItem!.quantity)")
                            .font(.system(size: 14))
                            .foregroundColor(.black)

                        Button {
                            viewStore.send(.quantityChanged(1))
                        } label: {
                            Image(systemName: "plus")

                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                        }
                        .foregroundColor(.white)
                        .background(Color.purple)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )
                    }
                }
            }
            .padding(.all, 12)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
            .background(.white)
            .cornerRadius(12)
            .shadow(radius: 4)
            .alert(
                self.store.scope(state: \.cartAddedAlert, action: { $0 }),
                dismiss: .cartAddedAlertDismissed
            )
        }
    }
}

struct MainMenuProductCategory_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuProductList(
            store: .init(
                initialState: .init(
                    user: .init(), cart: .init()
                ),
                reducer: MainMenuModel(
                    productsService: .init()
                )
            )
        )
    }
}
