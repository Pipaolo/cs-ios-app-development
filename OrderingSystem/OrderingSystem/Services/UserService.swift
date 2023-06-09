//
//  UserService.swift
//  OrderingSystem
//
//  Created by Paolo Matthew on 6/9/23.
//

import Foundation

struct User: Equatable {
    var firstName: String = "Paolo Matthew"
    var middleName: String = "Garcia"
    var lastName: String = "Tolentino"
    var username: String = "user"
    var password: String = "1234"

    func fullName() -> String {
        "\(firstName) \(middleName) \(lastName)"
    }
}

enum LoginError: Error {
    case invalidCredentials
}

class UserService {
    private let defaultUser = User()
    var currentUser: User?

    func login(username: String, password: String) throws {
        print("Login: \(username) \(password)")
        if username == defaultUser.username, password == defaultUser.password {
            currentUser = defaultUser
            return
        }

        currentUser = nil
        throw LoginError.invalidCredentials
    }
}
