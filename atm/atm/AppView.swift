//
//  ContentView.swift
//  atm
//
//  Created by Paolo Matthew on 5/29/23.
//

import SwiftUI
import FlowStacks
import ComposableArchitecture


enum Screen {
    case login
    case mainMenu
}

struct AppView: View {
    let store: StoreOf<AppModel>
    @State var routes: Routes<Screen> = [.root(.login)]
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) {
            viewStore in
            Router($routes){
                screen, _ in
                switch(screen){
                    case .login:
                        LoginView()
                    case .mainMenu:
                        MainMenuView()
                default:
                    EmptyView()
                }
            }
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AtmAppCoordinatorView(
            store: .init(
                initialState: .initialState,
                reducer: AtmAppCoordinator()
            )
        )
    }
}
