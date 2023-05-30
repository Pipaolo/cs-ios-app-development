//
//  AppScreen.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import Foundation
import ComposableArchitecture

struct AppScreenEnvironment {
    let user: User = User()
}

struct AppScreen: ReducerProtocol {
    let environment: AppScreenEnvironment
    
    enum State: Equatable, Identifiable {
        case login(AppModel.State)
        case mainMenu(MainMenuModel.State)
        case balanceInquiry(MainMenuModel.State)
        case withdraw(MainMenuModel.State)
        case transfer(MainMenuModel.State)
        case changePin(MainMenuModel.State)
        case payBills(MainMenuPayBillsModel.State)
        case payBillsSelected(MainMenuPayBillsModel.State)
        case deposit(MainMenuModel.State)
        case alertError(MainMenuModel.State)
        
        var id: ID {
            switch self {
            case .login:
                return .login
            case .mainMenu:
                return .mainMenu
            case .balanceInquiry:
                return .balanceInquiry
            case .withdraw:
                return .withdraw
            case .transfer:
                return .transfer
            case .changePin:
                return .changePin
            case .payBills:
                return .payBills
            case .payBillsSelected:
                return .payBillsSelected
            case .deposit:
                return .deposit
            case .alertError:
                return .alertError
            }
        }
        
        enum ID: Identifiable {
            case login
            case mainMenu
            case balanceInquiry
            case withdraw
            case transfer
            case changePin
            case payBills
            case payBillsSelected
            case deposit
            case alertError
            
            var id: ID {
                self
            }
        }
    }
    
    enum Action: Equatable {
        case login(AppModel.Action)
        case mainMenu(MainMenuModel.Action)
        case balanceInquiry(MainMenuModel.Action)
        case withdraw(MainMenuModel.Action)
        case transfer(MainMenuModel.Action)
        case changePin(MainMenuModel.Action)
        case payBills(MainMenuPayBillsModel.Action)
        case payBillsSelected(MainMenuPayBillsModel.Action)
        case deposit(MainMenuModel.Action)
        case alertError(MainMenuModel.Action)
    }
    
    var body: some ReducerProtocol<State,Action>{

        let mainMenuModel = MainMenuModel()
        let mainMenuPayBillsModel = MainMenuPayBillsModel()
        Scope(state: /State.login, action: /Action.login) {
            AppModel()
        }
        
        Scope(state: /State.mainMenu, action: /Action.mainMenu){
            mainMenuModel
        }
        
        Scope(state: /State.balanceInquiry, action: /Action.balanceInquiry){
            mainMenuModel
        }
        
        Scope(state: /State.withdraw, action: /Action.withdraw){
            mainMenuModel
        }
        
        Scope(state: /State.transfer, action: /Action.transfer){
            mainMenuModel
        }
        
        Scope(state: /State.changePin, action: /Action.changePin){
            mainMenuModel
        }
        
        Scope(state: /State.payBills, action: /Action.payBills){
            mainMenuPayBillsModel
        }
        Scope(state: /State.payBillsSelected, action: /Action.payBillsSelected) {
            mainMenuPayBillsModel
        }
        Scope(state: /State.deposit, action: /Action.deposit){
            mainMenuModel
        }
        Scope(state: /State.alertError, action: /Action.alertError) {
            mainMenuModel
        }
    }
    
    
}
