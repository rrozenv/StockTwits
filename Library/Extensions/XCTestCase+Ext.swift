//
//  XCTestCase+Ext.swift
//  Library
//
//  Created by Robert Rozenvasser on 3/31/19.
//

import Foundation
import XCTest
import Domain
import Library

extension XCTestCase {
    
    /// Pushes an environment onto the stack, executes a closure, and then pops the environment from the stack.
    func withEnvironment(_ env: Environment, body: () -> Void) {
        App.pushEnvironment(env)
        body()
        App.popEnvironment()
    }
    
    /// Pushes an environment onto the stack, executes a closure, and then pops the environment from the stack.
    func withEnvironment(
        apiService: ServiceType = App.current.apiService,
        storage: StorageType = App.current.storage,
        currentUser: User? = App.current.currentUser,
        body: () -> Void
    ) {
        let newEnv = Environment(
            apiService: apiService,
            storage: storage,
            currentUser: currentUser
        )
        withEnvironment(newEnv, body: body)
    }
    
}
