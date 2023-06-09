//
//  Login.swift
//  atm
//
//  Created by Paolo Matthew on 5/29/23.
//

import ComposableArchitecture
import SwiftUI

struct LoginModel: ReducerProtocol {
    struct State: Equatable {
        @BindingState var username: String = ""
        @BindingState var password: String = ""
        var error: String = ""
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case submitted
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { _, action in
            switch action {
                case .binding:
                    return .none
                case .submitted:
                    return .none
            }
        }
    }
}

struct LoginView: View {
    let store: StoreOf<LoginModel>
    @State private var username: String = ""

    var body: some View {
        WithViewStore(store, observe: { $0 }) {
            viewStore in
            VStack(alignment: .center) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                VStack {
                    TextField("Username", text: viewStore.binding(\.$username))
                        .padding(.all, 20)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue,
                                        lineWidth: 2))
                    SecureField("Password", text: viewStore.binding(\.$password))
                        .padding(.all, 20)
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue,
                                        lineWidth: 2))
                    Button {
                        viewStore.send(.submitted)
                    } label: {
                        Text("Submit")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    if viewStore.error != "" {
                        Text(viewStore.error)
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                    }
                }
                .navigationTitle("RYL Banking")
            }.padding(.all, 12)
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: .init(initialState: .init(),
                         reducer: LoginModel())
        )
    }
}
