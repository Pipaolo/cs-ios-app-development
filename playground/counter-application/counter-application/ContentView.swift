//
//  ContentView.swift
//  counter-application
//
//  Created by Paolo Matthew on 5/29/23.
//

import SwiftUI
import ComposableArchitecture


struct ContentView: View {
    @State var desination: Int?
    
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) {viewStore in
            VStack {
                Text("Count: \(viewStore.count)")
                Button("Increment") {
                    viewStore.send(.incrementButtonTapped)
                }
                Button("Decrement") {
                    viewStore.send(.decrementButtonTapped)
                }
                NavigationLink(unwrapping: self.$desination) { isActive in
                    self.desination = isActive ? 42 : nil
                } destination: { $number in
                    CounterView(number: $number)
                } label {
                    Text("Go to counter")
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(initialState: CounterFeature.State()){
                CounterFeature()
            }
        )
    }
}
