//
//  AtmFeatureModel.swift
//  atm
//
//  Created by Paolo Matthew on 5/29/23.
//

import Foundation
import ComposableArchitecture


struct UserBalance:Equatable {
    var amount: Double = 1000.0
}

struct User: Equatable{
    var name: String = ""
    var pin: String = ""
    var balance: UserBalance = UserBalance()
}

struct AppModel: ReducerProtocol {
    
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .loginFormPinChanged(let pin):
                state.error = ""
                if pin.count != 4{
                    return .none
                }
                
                if(pin != state.user.pin) {
                    state.error = "Invalid Pin"
                }
                
                    
                return .none
            case .loggedInSuccessfully:
                return .none
            case .mainMenuReached:
                return .none
        }
        
    }
    
    enum Action: Equatable {
        case loginFormPinChanged(String)
        case loggedInSuccessfully(User)
        case mainMenuReached
    }
    

    
    struct State: Equatable {
        var user: User = User(name: "Paolo Tolentino", pin:"1234", balance: UserBalance(amount: 1000))
        var isLoading: Bool = false
        var error: String = ""
    }
    
}
