//
//  Utils.swift
//  atm
//
//  Created by Paolo Matthew on 5/30/23.
//

import Foundation

class Utils {
    //Function to keep text length in limits
    static public func limitText(input: String, upper: Int) -> String {
        if input.count > upper {
            return String(input.prefix(upper))
        }
        return input
    }
}
