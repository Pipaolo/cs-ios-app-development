//
//  MainMenuBalanceInquiry.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import SwiftUI
import ComposableArchitecture

struct MainMenuBalanceInquiry: View {
    let store: StoreOf<MainMenuModel>
    
    var body: some View {
        WithViewStore(store, observe: {$0}) {
            viewStore in
            VStack {
                Text("You current balance is \(viewStore.user.balance.amount.currencyFormat())")
            }.navigationTitle("Balance Inquiry")
        }
    }
}

extension Double {
    func currencyFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_PH")
        return formatter.string(from: NSNumber(value: self))!
    }
}

