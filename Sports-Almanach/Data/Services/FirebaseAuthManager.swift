//
//  FirebaseAuthManager.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 08.10.24.
//

import Foundation
import FirebaseAuth

@Observable
class FirebaseAuthManager {
    
    static let shared = FirebaseAuthManager()
    
    var user: User?
    
    var isUserSignedIn: Bool {
        user != nil
    }
    
    var userID: String? {
        user?.uid
    }
    
    func signUp(email: String, password: String) async throws {
        let authResult = try await auth.createUser(withEmail: email, password: password)
        guard let email = authResult.user.email else { throw AuthError.noEmail }
        print("User with email '\(email)' is registered with id '\(authResult.user.uid)'")
        // CreateProfile
        try await self.signIn(email: email, password: password)
    }

    func signIn(email: String, password: String) async throws {
        let authResult = try await auth.signIn(withEmail: email, password: password)
        guard let email = authResult.user.email else { throw AuthError.noEmail }
        print("User with email '\(email)' signed in with id '\(authResult.user.uid)'")
        self.user = authResult.user
    }
    
    func signOut() {
        do {
            try auth.signOut()
            user = nil
            print("Sign out succeeded.")
        } catch {
            print("Sign out failed.")
        }
    }
    
    private init() {
        checkAuth()
    }
    
    private func checkAuth() {
        guard let currentUser = auth.currentUser else {
            print("Not logged in")
            return
        }
        self.user = currentUser
    }
    
    private let auth = Auth.auth()
}
