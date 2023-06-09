//
//  MainMenu.swift
//  atm
//
//  Created by Paolo Matthew on 5/29/23.
//

import ComposableArchitecture
import SwiftUI

struct MainMenuModel: ReducerProtocol {
    struct State: Equatable {
        var user: User = .init()
        var error: String = ""
    }

    enum Action: Equatable {
        case loggedIn(User)
        case balanceRequested
        case withdrawRequested
        case transferRequested
        case changePinRequested
        case payBillsRequested
        case depositRequested
        case exitRequested
        case errorShowed(String)
        case balanceDeducted(Double)
        case balanceAdded(Double)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loggedIn:
            return .none
        case .balanceRequested:
            return .none
        case .withdrawRequested:
            return .none
        case .transferRequested:
            return .none
        case .changePinRequested:
            return .none
        case .payBillsRequested:
            return .none
        case .depositRequested:
            return .none
        case .exitRequested:
            return .none
        case .balanceAdded(let amount):
            state.user.balance.amount += amount
            return .none
        case .errorShowed:
            return .none
        case .balanceDeducted(let amount):
            state.error = ""
            if amount > state.user.balance.amount {
                state.error = "Insufficient funds!"
                return .none
            }
            state.user.balance = UserBalance(amount: state.user.balance.amount - amount)
            return .none
        }
    }
}

struct MainMenuView: View {
    let store: StoreOf<MainMenuModel>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Text("Welcome \(viewStore.user.name)!")
                    .font(.headline)

                List {
                    Button("Balance Inquiry") {
                        print("Balance!")
                        viewStore.send(.balanceRequested)
                    }
                    Button("Withdraw Cash") {
                        viewStore.send(.withdrawRequested)
                    }
                    Button("Transfer Money") {
                        viewStore.send(.transferRequested)
                    }
                    Button("Change Password") {
                        viewStore.send(.changePinRequested)
                    }
                    Button("Pay Bills") {
                        viewStore.send(.payBillsRequested)
                    }
                    Button("Deposit") {
                        viewStore.send(.depositRequested)
                    }
                    Button("Exit") {
                        viewStore.send(.exitRequested)
                    }
                }.cornerRadius(12)
            }
            .padding(.all, 12)
            .navigationTitle("Main Menu")
        }
    }
}
