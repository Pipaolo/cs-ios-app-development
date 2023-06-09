//
//  LoginModel.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/9/23.
//

import ComposableArchitecture
import Foundation

struct LoginModel: ReducerProtocol {
    let userService: UserService

    struct State: Equatable {
        @BindingState var username: String = "user"
        @BindingState var password: String = "1234"
        var user: User?
        var alert: AlertState<Action>?
        var error: String = ""
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case alertDismissed
        case submitted
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .alertDismissed:
                return .none
            case .binding:
                return .none
            case .submitted:
                do {
                    try userService.login(username: state.username,
                                          password: state.password)

                    state.user = userService.currentUser

                    return .none
                } catch LoginError.invalidCredentials {
                    state.error = "Invalid username/password"
                } catch {
                    state.error = "Unknown Error"
                }

                state.alert = AlertState {
                    TextState(state.error)
                } actions: {
                    ButtonState(role: .cancel) {
                        TextState("Confirm")
                    }
                }

                return .none
            }
        }
    }
}
