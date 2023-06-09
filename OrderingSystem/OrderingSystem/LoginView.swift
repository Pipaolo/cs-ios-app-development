//
//  LoginView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/6/23.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = "Username"
    @State private var password: String = ""
    @State private var isPasswordHidden: Bool = true
    @State private var isLoginSuccess: Bool = false
    
    var body: some View {
        VStack {
            Text("Login your account")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 50)
            
            TextField("Username", text: $username)
                .padding()
                .background(Color.gray)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            
            HStack {
                if isPasswordHidden {
                    SecureField("Password", text: $password)
                } else {
                    TextField("Password", text: $password)
                }
                Button(action: {
                    isPasswordHidden.toggle()
                }) {
                    Image(systemName: isPasswordHidden ? "eye.slash.fill" : "eye.fill")
                }
            }
            .padding()
            .background(Color.gray)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
            
            Button("Login") {
                isLoginSuccess.toggle()
            }
            .padding()
            .foregroundColor(.blue)
            .background(Color.gray)
            .cornerRadius(10)
            .padding()
        }.padding(.all,14)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
