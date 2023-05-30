//
//  MainMenuBalanceInquiry.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct MainMenuChangePin: View {
    let store: StoreOf<MainMenuModel>
    @State private var pin = ""
    
    var body: some View {
        WithViewStore(store, observe: {$0}) {
            viewStore in
            VStack {
                Form {
                    VStack(alignment:.center, spacing: 24) {
                        VStack(alignment: .leading) {
                            Text("Enter PIN").multilineTextAlignment(.leading)
                            TextField("Enter pin", text: $pin)
                                .onReceive(Just(pin)) {
                                    _ in
                                    pin = Utils.limitText(input: pin, upper: 4)
                                }
                                .textFieldStyle(.roundedBorder)
                            if(viewStore.error != ""){
                                Text(viewStore.error)
                                    .foregroundColor(.red)
                            
                            }
                        }
                        Button("Submit") {
                            viewStore.send(.pinChanged(pin))
                        }
                        .disabled(pin.isEmpty || pin.count < 4)
                        .buttonStyle(.borderedProminent)
                    }
                }
                
          
            }.navigationTitle("Change Pin")
        }
    }
}

struct MainMenuChangePin_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuChangePin(
            store: .init(
                initialState: .init(
                    user: User(name: "Paolo Tolentino", pin:"1234")
                ),
                reducer: MainMenuModel()
            )
        )
    }
}

