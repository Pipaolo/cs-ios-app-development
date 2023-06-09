//
//  OrderingSystemApp.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/5/23.
//
import SwiftUI

@main
struct OrderingSystemApp: App {
    var body: some Scene {
        WindowGroup {
            OrderingSystemAppCoordinatorView(
                store: .init(initialState: .initialState,
                             reducer: OrderingSystemAppCoordinator())
            )
        }
    }
}

struct OrderingSystemApp_Previews: PreviewProvider {
    static var previews: some View {
        OrderingSystemAppCoordinatorView(
            store: .init(initialState: .initialState,
                         reducer: OrderingSystemAppCoordinator())
        )
    }
}
