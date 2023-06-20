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
    .init(name: "Filo Dishes", products: [
        .init(name: "Adobong Baboy", price: 50),
        .init(name: "Sinigang na Manok", price: 60),
        .init(name: "Dinakdakan", price: 80),
        .init(name: "Pork Sisig", price: 90),
        .init(name: "Bulalo", price: 100)
    ]),
    .init(name: "Desserts", products: [
        .init(name: "Halo-Halo", price: 30),
        .init(name: "Mais Con-Yelo", price: 40),
        .init(name: "Ginataang Bilo-Bilo", price: 50),
        .init(name: "Scramble", price: 60),
        .init(name: "Lecheflan", price: 70)
    ]),
    .init(name: "Drinks", products: [
        .init(name: "Coke(250ml)", price: 30),
        .init(name: "Royal(250ml)", price: 40),
        .init(name: "Sprite(250ml)", price: 50),
        .init(name: "Mountain Dew(250ml)", price: 60),
        .init(name: "Ryl Iced Tea(250ml)", price: 70)
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
