//
//  AlertError.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import SwiftUI

struct AlertError: View {
    let error: String = "[TEMPLATE] ERROR MESSAGE"
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Error ❌")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.red)
            Text(error)
        }
    }
}

struct AlertError_Previews: PreviewProvider {
    static var previews: some View {
        AlertError()
    }
}
