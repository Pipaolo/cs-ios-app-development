//
//  ContentView.swift
//  LoginSample
//
//  Created by Paolo Matthew on 6/19/23.
//

import SwiftUI

struct ContentView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isValid: Bool = false
    @State private var validationMessages: [String: String] = [:]

    private func onSubmit() {
        if username == "test" && password == "test" {
            isValid = true
            validationMessages.removeAll()
            return
        }
        isValid = false
        validationMessages["username"] = "Invalid username"
        validationMessages["password"] = "Invalid password"
    }

    var body: some View {
        NavigationStack {
            VStack {
                VStack {
                    TextField("Username", text: $username)
                        .textInputAutocapitalization(.never)
                    if validationMessages["username"] != nil {
                        Text(validationMessages["username"]!)
                    }
                }
                VStack {
                    SecureField("Password", text: $password)

                    if validationMessages["password"] != nil {
                        Text(validationMessages["password"]!)
                    }
                }

                Button {
                    onSubmit()
                } label: {
                    Text("Login")
                }
            }
            .navigationTitle("Login")
            .navigationDestination(isPresented: $isValid) {
                MainMenuView()
                    .navigationBarBackButtonHidden()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
