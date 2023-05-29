//
//  CounterFeature.swift
//  counter-application
//
//  Created by Paolo Matthew on 5/29/23.
//

import Foundation
import ComposableArchitecture


struct CounterFeature: ReducerProtocol {
    func reduce(into state: inout State, action: Action) -> ComposableArchitecture.EffectTask<Action> {
        switch action {
            
        case .decrementButtonTapped:
            state.count -= 1;
            return .none
        case .incrementButtonTapped:
            state.count += 1;
            return .none
        }
    }
    
    
    struct State: Equatable {
        var count = 0
    }
    
    enum Action: Equatable {
        case incrementButtonTapped
        case decrementButtonTapped
    }
    
}
