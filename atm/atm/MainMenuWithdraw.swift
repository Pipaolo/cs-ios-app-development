//
//  MainMenuBalanceInquiry.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct MainMenuWithdraw: View {
    let store: StoreOf<MainMenuModel>
    
    
    @State private var withdrawAmount: String = "0"
  
    var body: some View {
        WithViewStore(store, observe: { $0 }) {
            viewStore in
            VStack(alignment: .center) {
                Text("Current Balance: \(viewStore.user.balance.amount.currencyFormat())")
                    .font(.title)
                    .padding(.bottom, 12)
                
                VStack(alignment: .leading) {
                    TextField(text: $withdrawAmount){
                        Text("Enter amount")
                    }
                        .keyboardType(.numberPad)
                        .onReceive(Just(withdrawAmount)) { newValue in
                                     let filtered = newValue.filter { "0123456789".contains($0) }
                                     if filtered != newValue {
                                         self.withdrawAmount = filtered
                                         
                                     }
                                 }
                        .textFieldStyle(.roundedBorder)
                }
                Button("Withdraw"){
                    let amount = Double(withdrawAmount)!
                    viewStore.send(.balanceDeducted(amount))
                   
                }
                .disabled(withdrawAmount.isEmpty)
                .buttonStyle(.borderedProminent)
                
                if(viewStore.error != ""){
                    Text(viewStore.error)
                        .foregroundColor(.red)
                
                }
                
                
            }
            .padding(.all, 12)
            .navigationTitle("Withdraw")
        }
    }
}
