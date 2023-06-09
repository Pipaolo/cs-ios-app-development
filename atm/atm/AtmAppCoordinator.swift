//
//  AtmAppFormCoordinator.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct AtmAppCoordinator: ReducerProtocol {
    struct State: IdentifiedRouterState, Equatable {
        static let initialState = Self(routeIDs: [.root(.login, embedInNavigationView: true)])
        
        var appState = AppModel.State()
        
        var mainMenuState = MainMenuModel.State()
        var mainMenuChangePinState = MainMenuChangePinModel.State(
        )
        
        var mainMenuPayBillsState = MainMenuPayBillsModel.State()
        var loginState = LoginModel.State()
        
        var routeIDs: IdentifiedArrayOf<Route<AppScreen.State.ID>>
        var routes: IdentifiedArrayOf<Route<AppScreen.State>> {
            get {
                let routes = routeIDs.map { route -> Route<AppScreen.State> in
                    route.map { id in
                        switch id {
                        case .login:
                            return .login(loginState)
                        case .mainMenu:
                            return .mainMenu(mainMenuState)
                        case .balanceInquiry:
                            return .balanceInquiry(mainMenuState)
                        case .withdraw:
                            return .withdraw(mainMenuState)
                        case .transfer:
                            return .transfer(mainMenuState)
                        case .changePin:
                            return .changePin(mainMenuChangePinState)
                        case .payBills:
                            return .payBills(mainMenuPayBillsState)
                        case .payBillsSelected:
                            return .payBillsSelected(mainMenuPayBillsState)
                        case .deposit:
                            return .deposit(mainMenuState)
                        case .alertError:
                            return .alertError(mainMenuState)
                        }
                    }
                }
                return IdentifiedArray(uniqueElements: routes)
            }
            set {
                let routeIDs = newValue.map { route -> Route<AppScreen.State.ID> in
                    route.map { id in
                        switch id {
                        case .login(let loginState):
                            self.loginState = loginState
                            return .login
                        case .mainMenu(let mainMenuState):
                            self.mainMenuState = mainMenuState
                            return .mainMenu
                        case .balanceInquiry(let mainMenuState):
                            self.mainMenuState = mainMenuState
                            return .balanceInquiry
                        case .withdraw(let mainMenuState):
                            self.mainMenuState = mainMenuState
                            return .withdraw
                        case .transfer(let mainMenuState):
                            self.mainMenuState = mainMenuState
                            return .transfer
                        case .changePin(let changePinState):
                            self.mainMenuChangePinState = changePinState
                            return .changePin
                        case .payBills(let mainMenuPayBillsState):
                            self.mainMenuPayBillsState = mainMenuPayBillsState
                            return .payBills
                        case .payBillsSelected(let mainMenuPayBillsState):
                            self.mainMenuPayBillsState = mainMenuPayBillsState
                            return .payBillsSelected
                        case .deposit(let mainMenuState):
                            self.mainMenuState = mainMenuState
                            return .deposit
                        case .alertError(let mainMenuState):
                            self.mainMenuState = mainMenuState
                            return .alertError
                        }
                    }
                }
                self.routeIDs = IdentifiedArray(uniqueElements: routeIDs)
            }
        }
        
        mutating func clear() {
            mainMenuPayBillsState = .init()
        }
    }
    
    enum Action: IdentifiedRouterAction {
        case updateRoutes(IdentifiedArrayOf<Route<AppScreen.State>>)
        case routeAction(AppScreen.State.ID, action: AppScreen.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
        
            switch action {
            case .routeAction(_, action: .login(.submitted)):
                let user = state.appState.user
                
                if user.password != state.loginState.password {
                    state.loginState.error = "Invalid password"
                    return .none
                }
                
                if user.username != state.loginState.username {
                    state.loginState.error = "Invalid username"
                    return .none
                }
                
                state.mainMenuState.user = user
                
                state.routes = [.root(.mainMenu(state.mainMenuState), embedInNavigationView: true)]
                return .none
            case .routeAction(_, action: .mainMenu(.balanceRequested)):
                state.routeIDs.push(.balanceInquiry)
                return .none
            case .routeAction(_, action: .mainMenu(.withdrawRequested)):
                state.routeIDs.push(.withdraw)
                return .none
            case .routeAction(_, action: .mainMenu(.transferRequested)):
                state.routeIDs.push(.transfer)
                return .none
            case .routeAction(_, action: .mainMenu(.changePinRequested)):
                state.mainMenuChangePinState.user = state.mainMenuState.user
                state.routeIDs.push(.changePin)
                return .none
            case .routeAction(_, action: .mainMenu(.payBillsRequested)):
                state.mainMenuPayBillsState.balance = state.mainMenuState.user.balance
                state.routeIDs.push(.payBills)
                return .none
            case .routeAction(_, action: .mainMenu(.depositRequested)):
                state.routeIDs.push(.deposit)
                return .none
            case .routeAction(_, action: .transfer(.balanceDeducted)):
                if state.mainMenuState.error != "" {
                    return .none
                }
                state.routeIDs.pop()
                return .none
            case .routeAction(_, action: .withdraw(.balanceDeducted)):
                if state.mainMenuState.error != "" {
                    return .none
                }
                state.routeIDs.pop()
                return .none
            case .routeAction(_, action: .deposit(.balanceAdded)):
                state.routeIDs.pop()
                return .none
            case .routeAction(_, action: .changePin(.submitted)):
                
                if state.mainMenuChangePinState.error != "" {
                    return .none
                }

                state.appState.user = state.mainMenuChangePinState.user
                state.routes = [.root(.login(state.loginState), embedInNavigationView: true)]
                return .none
            case .routeAction(_, action: .mainMenu(.exitRequested)):
                state.routes = [.root(.login(state.loginState), embedInNavigationView: true)]
                return .none
            case .routeAction(_, action: .payBills(.billerSelected)):
                state.routeIDs.push(.payBillsSelected)
                return .none
            case .routeAction(_, action: .payBillsSelected(.submitted)):
                if state.mainMenuPayBillsState.error != "" {
                    return .none
                }
                
                // Update the main menu model's balance
                state.mainMenuState.user.balance = state.mainMenuPayBillsState.balance
                state.mainMenuPayBillsState.clear()
                state.routeIDs.goBackTo(id: .mainMenu)
                return .none
            default:
                return .none
            }
            
        }.forEachRoute {
            AppScreen(environment: .init())
        }
    }
}

struct AtmAppCoordinatorView: View {
    let store: StoreOf<AtmAppCoordinator>
    
    var body: some View {
        TCARouter(store) { screen in
            SwitchStore(screen) {
                CaseLet(state: /AppScreen.State.login, action: AppScreen.Action.login, then: LoginView.init(store:))
                CaseLet(state: /AppScreen.State.mainMenu, action: AppScreen.Action.mainMenu, then: MainMenuView.init(store:))
                CaseLet(state: /AppScreen.State.balanceInquiry, action: AppScreen.Action.balanceInquiry, then: MainMenuBalanceInquiry.init(store:))
                CaseLet(state: /AppScreen.State.withdraw, action: AppScreen.Action.withdraw, then: MainMenuWithdraw.init(store:))
                CaseLet(state: /AppScreen.State.transfer, action: AppScreen.Action.transfer, then: MainMenuTransfer.init(store:))
                CaseLet(state: /AppScreen.State.changePin, action: AppScreen.Action.changePin, then: MainMenuChangePin.init(store:))
                CaseLet(state: /AppScreen.State.payBills, action: AppScreen.Action.payBills, then: MainMenuPayBills.init(store:))
                CaseLet(state: /AppScreen.State.payBillsSelected, action: AppScreen.Action.payBillsSelected, then: MainMenuPayBillsSelected.init(store:))
                CaseLet(state: /AppScreen.State.deposit, action: AppScreen.Action.deposit, then: MainMenuDeposit.init(store:))
            }
        }
    }
}

struct AtmAppCoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        AtmAppCoordinatorView(
            store: .init(
                initialState: .initialState,
                reducer: AtmAppCoordinator()
            )
        )
    }
}
