//
//  ShippingMethodView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/10/23.
//

import ComposableArchitecture
import SwiftUI

enum PaymentMethod: CaseIterable, Equatable {
    case cod
    case gcash
    case paymaya
    case creditCard

    var description: String {
        switch self {
        case .cod:
            return "Cash on Delivery"
        case .creditCard:
            return "Credit Card"
        case .gcash:
            return "GCash"
        case .paymaya:
            return "Paymaya"
        }
    }
}

struct PaymentDetailsModel: ReducerProtocol {
    struct State: Equatable {
        @BindingState var paymentMethod = PaymentMethod.cod
    }

    enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }

    var body: some ReducerProtocol<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding(\.$paymentMethod):
                print("Payment Method", state.paymentMethod)
                return .none
            default:
                return .none
            }
        }
    }
}

struct PaymentDetailsView: View {
    let store: StoreOf<PaymentDetailsModel>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Picker("Payment Method", selection: viewStore.binding(\.$paymentMethod)) {
                ForEach(PaymentMethod.allCases, id: \.self) { method in
                    Text(method.description).tag(method)
                }
            }
        }
    }
}

struct PaymentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailsView(
            store: .init(initialState: .init(), reducer: PaymentDetailsModel())
        )
    }
}
