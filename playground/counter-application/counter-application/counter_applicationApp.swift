//
//  counter_applicationApp.swift
//  counter-application
//
//  Created by Paolo Matthew on 5/29/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct counter_applicationApp: App {
    static let store = Store(initialState: CounterFeature.State()){
        CounterFeature()
    }
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: counter_applicationApp.store
            )
        }
    }
}
