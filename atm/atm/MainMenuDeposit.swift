//
//  MainMenuBalanceInquiry.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct MainMenuDeposit: View {
    let store: StoreOf<MainMenuModel>
    @State private var depositAmount = "0"
    
    var body: some View {
        WithViewStore(store, observe: {$0}) {
            viewStore in
            VStack(alignment: .center) {
                Text("Current Balance: \(viewStore.user.balance.amount.currencyFormat())")
                    .font(.title)
                    .padding(.bottom, 12)
                
                VStack(alignment: .leading) {
                    TextField(text: $depositAmount){
                        Text("Enter amount")
                    }
                        .keyboardType(.numberPad)
                        .onReceive(Just(depositAmount)) { newValue in
                                     let filtered = newValue.filter { "0123456789".contains($0) }
                                     if filtered != newValue {
                                         self.depositAmount = filtered
                                         
                                     }
                                 }
                        .textFieldStyle(.roundedBorder)
                }
                Button("Deposit"){
                    let amount = Double(depositAmount)!
                    viewStore.send(.balanceAdded(amount))
                   
                }
                .disabled(depositAmount.isEmpty)
                .buttonStyle(.borderedProminent)
            }
            .padding(.all, 12)
            .navigationTitle("Deposit")
        }
    }
}
