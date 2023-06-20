//
//  SwiftUIView.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/19/23.
//

import SwiftUI

/**
 A rounded rectangular loader that resemblance a skeleton loader.
 */
struct RoundedRectangularLoader: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(maxWidth: .infinity, maxHeight: 100, alignment: .center)
            .shadow(radius: 2)
            .padding(.all, 12)
        
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangularLoader()
    }
}
