//
//  MainMenuBalanceInquiry.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import Combine
import ComposableArchitecture
import SwiftUI

struct MainMenuChangePinModel: ReducerProtocol {
    struct State: Equatable {
        var user: User = .init()

        @BindingState var password: String = ""
        var error: String = ""
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case submitted
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                case .binding:
                    return .none
                case .submitted:
                    var user = state.user
                    state.error = ""

                    if user.password == state.password {
                        state.error = "New password cannot be the same as the old password!"
                        return .none
                    }
                    user.password = state.password
                    state.user = user

                    return .none
            }
        }
    }
}

struct MainMenuChangePin: View {
    let store: StoreOf<MainMenuChangePinModel>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) {
            viewStore in
            VStack {
                VStack(alignment: .leading) {
                    Text("Password")
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                    SecureField("Enter password",
                                text: viewStore.binding(\.$password))
                        .padding(.all, 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue,
                                        lineWidth: 2)
                        )

                    if viewStore.error != "" {
                        Text(viewStore.error)
                            .foregroundColor(.red)
                    }
                }
                Button {
                    viewStore.send(.submitted)
                } label: {
                    Text("Submit")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                }
                .disabled(viewStore.password == "")
                .buttonStyle(.borderedProminent)

            }.padding(.all, 12)
                .navigationTitle("Change Pin")
        }
    }
}

struct MainMenuChangePin_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuChangePin(
            store: .init(
                initialState: .init(),
                reducer: MainMenuChangePinModel()
            )
        )
    }
}
