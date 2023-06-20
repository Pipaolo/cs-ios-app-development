//
//  MainMenuCategoryFilters.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/19/23.
//

import ComposableArchitecture
import SwiftUI

struct MainMenuCategoryFilters: View {
    var store: StoreOf<MainMenuModel>

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading) {
                Text("Category")
                    .font(.title)
                    .fontWeight(.bold)
                if viewStore.isLoading {
                    HStack {
                        RoundedRectangularLoader()
                        RoundedRectangularLoader()
                        RoundedRectangularLoader()
                    }
                } else {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewStore.categories) { category in
                                MainMenuCategoryFilterItem(category: category, isSelected: category.id == viewStore.selectedCategory?.id) {
                                    viewStore.send(.categoryFiltered(category))
                                }
                            }.padding(.all, 12)
                        }
                    }
                }
            }
            .padding(.all, 12)
        }
    }
}

struct MainMenuCategoryFilterItem: View {
    var category: ProductCategory = .init()
    var isSelected: Bool = false

    var onTapped: () -> Void = {}
    var body: some View {
        VStack(alignment: .center) {
            AsyncImage(url: URL(string: category.imageUrl))
                .aspectRatio(
                    contentMode: .fill
                ).frame(
                    width: 80,
                    height: 80,
                    alignment: .center
                )
                .cornerRadius(12)
                .shadow(radius: 2)
                .clipShape(Circle())

            Text(category.name).fontWeight(.bold)
                .font(.system(size: 18))
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(isSelected ? .purple : .black)
        }
        .onTapGesture {
            onTapped()
        }
    }
}

struct MainMenuCategoryFilters_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuCategoryFilters(
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
