//
//  LoginView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/6/23.
//

import ComposableArchitecture
import SwiftUI

struct LoginView: View {
    let store: StoreOf<LoginModel>

    @State private var isPasswordHidden: Bool = true

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("RYL Eatery")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 38)

                VStack(alignment: .leading, spacing: 8) {
                    TextField("Username", text: viewStore.binding(\.$username))
                        .padding(.all, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .textInputAutocapitalization(.never)

                    HStack {
                        if isPasswordHidden {
                            SecureField("Password", text: viewStore.binding(\.$password))
                        } else {
                            TextField("Password", text: viewStore.binding(\.$password))
                                .textInputAutocapitalization(.never)
                        }
                        Button(action: {
                            isPasswordHidden.toggle()
                        }) {
                            Image(systemName: isPasswordHidden ? "eye.slash.fill" : "eye.fill")
                        }
                    }
                    .padding(.all, 12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.blue, lineWidth: 2)
                    )

                    Button {
                        viewStore.send(.submitted)
                    } label: {
                        Text("Login")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding(.all, 14)
        }
        .navigationTitle("Login")
        .alert(
            self.store.scope(state: \.alert, action: { $0 }),
            dismiss: .alertDismissed
        )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            store: .init(
                initialState: .init(),
                reducer: LoginModel(
                    userService: .init()
                )
            )
        )
    }
}
