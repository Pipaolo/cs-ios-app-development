//
//  MainMenuBalanceInquiry.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import SwiftUI
import ComposableArchitecture
import Combine


struct MainMenuPayBillsSelected: View {
    let store: StoreOf<MainMenuPayBillsModel>
    
    var body: some View {
        WithViewStore(store, observe: {$0}) {
            viewStore in
            VStack(alignment: .center) {
                Form {
                    Text("\(viewStore.biller)")
                        .font(.title)
                        .padding(.bottom, 12)
                    VStack(alignment:.center, spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("Account Number")
                            TextField(
                                "Enter account number",
                                 text: viewStore.binding(\.$accountNumber)
                            )
                                .textFieldStyle(.roundedBorder)
                        }
                        VStack(alignment: .leading) {
                            Text("Amount")
                            TextField("Enter amount", text: viewStore.binding(\.$amount))
                                    .keyboardType(.numberPad)
                                    .onReceive(Just(viewStore.amount)) { newValue in
                                                 let filtered = newValue.filter { "0123456789".contains($0) }
                                                 if filtered != newValue {
                                                     viewStore.binding(\.$amount).wrappedValue = filtered
                                                 }
                                        }
                                    .textFieldStyle(.roundedBorder)
                            
                            if(viewStore.error != ""){
                                Text(viewStore.error)
                                    .foregroundColor(.red)
                            }
                        }
                    
                        Button("Submit") {
                            viewStore.send(.submitted)
                        }
                        .disabled(viewStore.amount.isEmpty || viewStore.accountNumber.isEmpty)
                        .buttonStyle(.borderedProminent)
                    }
                }
            }.navigationTitle("Pay Bill")
        }
    }
}

struct MainMenuPayBillsSelected_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuPayBillsSelected(
            store: .init(
                initialState: .init(
                    biller:"Meralco",
                    balance: UserBalance(amount: 1000),
                    accountNumber: "",
                    amount:"0"
                ),
                reducer: MainMenuPayBillsModel()
            )
        )
    }
}
