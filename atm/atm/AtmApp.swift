//
//  atmApp.swift
//  atm
//
//  Created by Paolo Matthew on 5/29/23.
//

import SwiftUI
import ComposableArchitecture

@main
struct AtmApp: App {
    var body: some Scene {
        WindowGroup {
            AtmAppCoordinatorView(
                store: .init(
                    initialState: .initialState,
                    reducer: AtmAppCoordinator()
                )
            )
        }
    }
}
