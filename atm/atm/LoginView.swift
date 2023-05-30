//
//  Login.swift
//  atm
//
//  Created by Paolo Matthew on 5/29/23.
//

import SwiftUI
import SwiftUINavigation
import ComposableArchitecture
import Foundation
import Combine

struct LoginView: View {
    let store: StoreOf<AppModel>
    
    @State private var pin: String = ""
    

    var body: some View {
        WithViewStore(store, observe: { $0 }) {
            viewStore in
            VStack(alignment: .leading) {
                Text("Enter PIN:")
                VStack {
                    SecureField(
                        text: $pin){
                            Text("Enter your pin:")
                        }
                        .padding(.all, 20)
                        .onReceive(Just(pin)) {
                            _ in
                            pin = Utils.limitText(input: pin, upper: 4)
                        }
                        .onChange(of: pin, perform: { pin in
                            viewStore.send(.loginFormPinChanged(pin))
                            
                            if(pin.count != 4){
                                return
                            }
                            
                            let error = viewStore.error
                            
                            if(error.isEmpty){
                                viewStore.send(
                                    .loggedInSuccessfully(viewStore.user)
                                )
                            }
                        })
                        .border(.blue, width: 2)
                        .cornerRadius(5.0)
                }
                
                if viewStore.error != "" {
                    Text(viewStore.error)
                        .font(.system(size: 12))
                        .foregroundColor(.red)
                }
                
                
            }
            .navigationTitle("RYL Banking")
            .padding(.all, 12.0)
        }
    }
    
 
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        AtmAppCoordinatorView(
            store: .init(
                initialState: .initialState,
                reducer: AtmAppCoordinator()
            )
        )
    }
}
