//
//  MainMenuBalanceInquiry.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import SwiftUI
import ComposableArchitecture

struct MainMenuPayBillsModel: ReducerProtocol {
    struct State: Equatable {
        var biller: String = ""
        var balance: UserBalance = UserBalance(amount: 0)
        var error: String = ""
        
        @BindingState var accountNumber: String = ""
        @BindingState var amount:String = "0"
        
        mutating func clear() {
            self.biller = ""
            self.balance = UserBalance(amount: 0)
            self.error = ""
        }
    }
    
    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case billerSelected(String)
        case submitted
    }
    
    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .billerSelected(let biller):
                state.biller = biller
                return .none
            case .submitted:
                state.error  = ""
                let amount = Double(state.amount) ?? 0
                
                if(amount > state.balance.amount){
                    state.error = "Insufficient Funds"
                    return .none
                }
                
                state.balance.amount -= amount
                return .none
            case .binding(_):
                return .none
            }
        }
    }
}

struct MainMenuPayBills: View {
    let store: StoreOf<MainMenuPayBillsModel>
    
    var body: some View {
        WithViewStore(store, observe: {$0}) {
            viewStore in
            VStack {
                List {
                    Button("Meralco") {
                        viewStore.send(.billerSelected("Meralco"))
                    }
                    Button("Maynilad") {
                        viewStore.send(.billerSelected("Maynilad"))
                    }
                }
            }.navigationTitle("Pay Bills")
        }
    }
}

struct MainMenuPayBills_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuPayBills(
            store: .init(
                initialState: .init(
                    biller:"",
                    accountNumber: "",
                    amount:""
                ),
                reducer: MainMenuPayBillsModel()
            )
        )
    }
}
