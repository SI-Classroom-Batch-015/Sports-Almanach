//
//  LogInView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Anmelden")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 64)
                    
                    // E-Mail
                    ZStack(alignment: .leading) {
                        if email.isEmpty {
                            Text("Email eingeben ...")
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.leading, 12)
                        }
                        TextField("", text: $email)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.white.opacity(0.8))
                            .cornerRadius(10)
                            .frame(width: 300, height: 50)
                            .textInputAutocapitalization(.never)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange, lineWidth: 2)
                            )
                    }
                    .padding(.bottom, 42)
                    
                    // Passwort mit Sichtbarkeit Toggle
                    HStack {
                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("Passwort")
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.leading, 12)
                            }
                            if isPasswordVisible {
                                TextField("", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(10)
                                    .frame(width: 300, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange, lineWidth: 2)
                                    )
                            } else {
                                SecureField("", text: $password)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(10)
                                    .frame(width: 300, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.orange, lineWidth: 2)
                                    )
                            }
                            
                            // Passwort Sichtbar Button
                            Button(action: {
                                isPasswordVisible.toggle()
                            }) {
                                Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                    .foregroundColor(isPasswordVisible ? .green : .red)
                            }
                            .padding(.leading, 248)
                        }
                    }
                    .padding(.bottom, 64)
                    
                    // Login
                    Button(action: {
                        attemptSignIn()
                    }) {
                        Text("LOGIN")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.orange.opacity(0.9))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 64)
                    
                    // Zur Registrierung
                    HStack {
                        Text("Noch keinen Account?")
                            .foregroundColor(.white)
                        
                        NavigationLink(destination: RegisterView()) {
                            Text("Hier Registrieren!")
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                    .padding(.bottom, 120)
                    
                    HStack(spacing: 36) {
                        Button(action: {
                            // Platzhalter Logik
                        }) {
                            Text("Google")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 140, height: 50)
                                .background(Color.orange.opacity(0.9))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Platzhalter Logik
                        }) {
                            Text("Facebook")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 140, height: 50)
                                .background(Color.orange.opacity(0.9))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $userViewModel.showError) {
                Alert(
                    title: Text("Fehler"),
                    message: Text(userViewModel.errorMessage ?? "Unbekannter Fehler"),
                    dismissButton: .default(Text("OK")) {
                        // Reset der Eingabefelder
                        email = ""
                        password = ""
                    }
                )
            }
        }
    }
    
    // Funktion zum Anmelden des Benutzers
    private func attemptSignIn() {
        // Überprüfen der Eingaben vor der Anmeldung
        if email.isEmpty || password.isEmpty {
            userViewModel.errorMessage = UserError.emailOrPasswordInvalid.errorDescriptionGerman
            userViewModel.showError = true
            return
        }
        
        Task {
            do {
                // Versuch, den Benutzer anzumelden
                try await FirebaseAuthManager.shared.signIn(email: email, password: password)
            } catch let error as UserError {
                // Spezifische Fehler
                userViewModel.errorMessage = error.errorDescriptionGerman
                userViewModel.showError = true
            } catch {
                // Unbekannter Fehler
                userViewModel.errorMessage = UserError.unknownError.errorDescriptionGerman
                userViewModel.showError = true
            }
        }
    }
}




#Preview {
    LoginView()
        .environmentObject(UserViewModel())
}
