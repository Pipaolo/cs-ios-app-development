//
//  MainMenuBalanceInquiry.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct MainMenuTransfer: View {
    let store: StoreOf<MainMenuModel>
    @State private var accountNumber: String = ""
    @State private var amount:String = ""
    
    var body: some View {
        WithViewStore(store, observe: {$0}) {
            viewStore in
            VStack(alignment: .center) {
                Form {
                    VStack(alignment:.center, spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("Account Number").multilineTextAlignment(.leading)
                            TextField("Enter account number", text: $accountNumber)
                                .textFieldStyle(.roundedBorder)
                        }
                        VStack(alignment: .leading) {
                            Text("Amount")
                            TextField("Enter account number", text: $amount)                       .keyboardType(.numberPad)
                                    .onReceive(Just(amount)) { newValue in
                                                 let filtered = newValue.filter { "0123456789".contains($0) }
                                                 if filtered != newValue {
                                                     self.amount = filtered
                                                 }
                                        }
                                    .textFieldStyle(.roundedBorder)
                            if(viewStore.error != ""){
                                Text(viewStore.error)
                                    .foregroundColor(.red)
                            
                            }
                        }
                        
                        Button("Submit") {
                            let amount = Double(self.amount)!
                            viewStore.send(.balanceDeducted(amount))
                        }
                        .disabled(amount.isEmpty || accountNumber.isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                }
                
          
            }.navigationTitle("Transfer")
        }
    }
}

struct MainMenuTransfer_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuTransfer(
            store: .init(
                initialState: .init(),
                reducer: MainMenuModel()
            )
        )
    }
}
