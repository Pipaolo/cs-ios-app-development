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
    var category: String = "Sample"
}

class ProductsService {
    let defaultCategories: [ProductCategory] = [
        .init(name: "Burgers", products: [
            .init(name: "Cheeseburger", price: 50),
            .init(name: "Bacon Cheeseburger", price: 60),
            .init(name: "Double Cheeseburger", price: 80),
            .init(name: "Double Bacon Cheeseburger", price: 90),
            .init(name: "Double Quarter Pounder", price: 100)
        ]),
        .init(name: "Fries", products: [
            .init(name: "Regular Fries", price: 30),
            .init(name: "Large Fries", price: 40),
            .init(name: "Mega Fries", price: 50),
            .init(name: "Ultra Mega Fries", price: 60),
            .init(name: "Ultra Ultra Fries", price: 70)
        ]),
        .init(name: "Drinks", products: [
            .init(name: "Regular Drink", price: 30),
            .init(name: "Large Drink", price: 40),
            .init(name: "Mega Drink", price: 50),
            .init(name: "Ultra Mega Drink", price: 60),
            .init(name: "Ultra Ultra Drink", price: 70)
        ])
    ]

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
