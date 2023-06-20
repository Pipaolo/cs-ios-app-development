//
//  ProductsService.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import Foundation

struct ProductCategory: Equatable, Identifiable {
    var id: UUID = .init()
    var name: String = "Sample"
    var imageUrl: String = "https://via.placeholder.com/150"
    var products: [Product] = [
        .init(),
        .init(),
        .init(),
        .init(),
        .init()
    ]
}

struct Product: Equatable, Identifiable {
    var id: UUID = .init()
    var name: String = "Sample Product"
    var price: Double = 100
    var imageUrl: String = "https://via.placeholder.com/150"
    var category: String = "Sample"
}

let defaultCategories: [ProductCategory] = [
    .init(name: "Filo Dishes",
          imageUrl: "https://www.seriouseats.com/thmb/BBksd7FXnrkxFa8Dipf_LmgP9HA=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/Filipino-Features-Hero-Final-2-b785e627967843b0aa631c6a977adabe.jpg",
          products: [
              .init(name: "Adobong Baboy",
                    price: 50,
                    imageUrl: "https://yummyfood.ph/wp-content/uploads/2023/04/coke-pork-adobo-recipe.jpg"),
              .init(name: "Sinigang na Manok", price: 60, imageUrl: "https://www.lutongbahayrecipe.com/wp-content/uploads/2019/04/lutong-bahay-sinigang-na-manok-1200x1200.jpg"),
              .init(name: "Dinakdakan", price: 80, imageUrl: "https://panlasangpinoy.com/wp-content/uploads/2018/08/pork-dinakdakan.jpg"),
              .init(name: "Pork Sisig", price: 90, imageUrl: "https://cdn.i-scmp.com/sites/default/files/styles/square/public/d8/images/2019/09/18/scmp_16apr15_fe_foodshoot7_jonw6710.jpg?itok=MuawcWNK"),
              .init(name: "Bulalo", price: 100, imageUrl: "https://i0.wp.com/www.angsarap.net/wp-content/uploads/2015/11/Bulalo-Wide.jpg?fit=1080%2C720&ssl=1")
          ]),
    .init(name: "Desserts",
          imageUrl: "https://assets.bonappetit.com/photos/60e46c6701084801b06de2a3/1:1/w_2560%2Cc_limit/Halo-Halo-Recipe-2021.jpg",
          products: [
              .init(name: "Halo-Halo", price: 30, imageUrl: "https://assets.bonappetit.com/photos/60e46c6701084801b06de2a3/1:1/w_2560%2Cc_limit/Halo-Halo-Recipe-2021.jpg"),
              .init(name: "Mais Con-Yelo", price: 40, imageUrl: "https://hicaps.com.ph/wp-content/uploads/2023/03/mais-con-yelo.jpg"),
              .init(name: "Ginataang Bilo-Bilo", price: 50, imageUrl: "https://www.createwithnestle.ph/sites/default/files/srh_recipes/b2b064d0bb4ca1fbc7b22cd07b306b83.jpeg"),
              .init(name: "Scramble", price: 60, imageUrl: "https://www.createwithnestle.ph/sites/default/files/srh_recipes/33c05454264a9244fa8218690122c6af.jpg"),
              .init(name: "Lecheflan", price: 70, imageUrl: "https://amiablefoods.com/wp-content/uploads/leche-flan-recipe-card.jpg")
          ]),
    .init(name: "Drinks",
          imageUrl: "https://www.eatthis.com/wp-content/uploads/sites/4/2020/06/Unhealthiest-Drinks.jpg?quality=82&strip=1",
          products: [
              .init(name: "Coke(250ml)", price: 30, imageUrl: "https://d2t3trus7wwxyy.cloudfront.net/catalog/product/cache/d166c7ea81ddc4172de536322110c911/c/o/coke-regular-in-can-330ml_3.jpg"),
              .init(name: "Royal(250ml)", price: 40, imageUrl: "https://cdn.shopify.com/s/files/1/0286/5417/4340/products/Royal-tru-orange-by-feta_grande.jpg?v=1620435965"),
              .init(name: "Sprite(250ml)", price: 50, imageUrl: "https://d2t3trus7wwxyy.cloudfront.net/catalog/product/s/p/spite-in-can-330325ml_2.jpg"),
              .init(name: "Mountain Dew(250ml)", price: 60, imageUrl: "https://fishersupermarket.ph/wp-content/uploads/2020/10/4803925033148.jpg"),
              .init(name: "Ryl Iced Tea(250ml)", price: 70, imageUrl: "https://assets.bonappetit.com/photos/57aca9caf1c801a1038bc6aa/1:1/w_3731,h_3731,c_limit/cold-brew-plum-iced-tea.jpg")
          ]),
    .init(name: "Drinks (2)", products: [
        .init(name: "Coke(250ml)", price: 30),
        .init(name: "Royal(250ml)", price: 40),
        .init(name: "Sprite(250ml)", price: 50),
        .init(name: "Mountain Dew(250ml)", price: 60),
        .init(name: "Ryl Iced Tea(250ml)", price: 70)
    ])
]

class ProductsService {
    /**
        Fetches all categories of products along with their products

        - Returns: An array of ProductCategory
     */
    func fetchCategories() async throws -> [ProductCategory] {
        try await Task.sleep(nanoseconds: 1_000_000_000)

        return defaultCategories
    }

    func fetchProducts(category: ProductCategory) async throws -> [Product] {
        try await Task.sleep(nanoseconds: 1_000_000_000)

        return category.products
    }
}
