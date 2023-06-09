//
//  AtmFeatureModel.swift
//  atm
//
//  Created by Paolo Matthew on 5/29/23.
//

import ComposableArchitecture
import Foundation

struct UserBalance: Equatable {
    var amount: Double = 1000.0
}

struct User: Equatable {
    var name: String = ""
    var username: String = "user"
    var password: String = "password"
    var balance: UserBalance = .init()
}

struct AppModel: ReducerProtocol {
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .mainMenuReached:
            return .none
        }
    }

    enum Action: Equatable {
        case mainMenuReached
    }

    struct State: Equatable {
        var user: User = .init(name: "Paolo Tolentino", username: "user", password: "password", balance: UserBalance(amount: 1000))
        var isLoading: Bool = false
        var error: String = ""
    }
}
