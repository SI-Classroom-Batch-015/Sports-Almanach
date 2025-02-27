//
//  RegisterView.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 20.09.24.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var passwordRepeat: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var isRepeatPasswordVisible: Bool = false
    @State private var birthday: Date = Date()
    @State private var navigateToContentView: Bool = false
    @State private var animationOffset: CGFloat = 300
    @State private var showErrorAlert: Bool = false
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Image("hintergrund")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        Title(title: "Registrieren")
                            .padding(.bottom, 40)
                            .offset(y: animationOffset)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.8)) {
                                    animationOffset = 0
                                }
                            }
                        
                        // Eingabefelder
                        Group {
                            InputField(
                                placeholder: "Benutzername",
                                isSecure: false,
                                icon: "person",
                                text: $username,
                                isPasswordVisible: .constant(false)
                            )
                            
                            InputField(
                                placeholder: "Email",
                                isSecure: false,
                                icon: "envelope",
                                text: $email,
                                isPasswordVisible: $isPasswordVisible
                            )
                            
                            InputField(
                                placeholder: "Passwort",
                                isSecure: true,
                                icon: "lock",
                                text: $password,
                                isPasswordVisible: $isPasswordVisible
                            )
                            
                            InputField(
                                placeholder: "Passwort wiederholen",
                                isSecure: true,
                                icon: "lock",
                                text: $passwordRepeat,
                                isPasswordVisible: $isRepeatPasswordVisible
                            )
                        }
                        .padding(.horizontal, 10)
                        
                        // Mindestalter und DatePicker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mindestalter 18 Jahre")
                                .font(.footnote)
                                .foregroundColor(.blue)
                            
                            ZStack {
                                HStack {
                                    Text("Geburtsdatum:")
                                        .foregroundColor(.white.opacity(0.8))
                                    Spacer()
                                    
                                    DatePicker("", selection: $birthday, displayedComponents: .date)
                                        .datePickerStyle(CompactDatePickerStyle())
                                }
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(.gray.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.orange, lineWidth: 1)
                                )
                            }
                        }
                        .padding(.bottom, 24)
                        
                        // Registrieren
                        PrimaryActionButton(
                            title: "REGISTRIEREN",
                            action: {
                                attemptSignUp()
                            },
                            isActive: true 
                        )
                        .padding(.bottom, 16)
                        
                        // Navigation zur ContentView nach erfolgreicher Registrierung
                        .navigationDestination(isPresented: $navigateToContentView) {
                            ContentView()
                        }
                        
                        // Zur LoginView zurück
                        NavigationLink(destination: LoginView()) {
                            Text("Zurück zur Anmeldung")
                                .foregroundColor(.blue)
                                .underline()
                                .padding(.top, 16)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .scrollDismissesKeyboard(.immediately)
                .ignoresSafeArea(.keyboard)
                .navigationBarBackButtonHidden(true)
                // Alert mit AuthState
                .alert("Fehler", isPresented: $showErrorAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    ForEach(userViewModel.authState.errorMessages, id: \.self) { error in
                        Text(error.errorDescriptionGerman ?? "")
                    }
                }
            }
        }
    }
    
    private func attemptSignUp() {
        Task {
            await userViewModel.register(
                username: username,
                email: email,
                password: password,
                passwordRepeat: passwordRepeat,
                birthday: birthday
            )
            
            // Update UI auf dem Main Actor
            await MainActor.run {
                if userViewModel.authState.errorMessages.isEmpty {
                    // Navigation zur HomeView nach erfolgreicher Registrierung
                    navigateToContentView = true
                } else {
                    showErrorAlert = true
                }
            }
        }
    }
}

#Preview {
    RegisterView()
        .environmentObject(UserViewModel())
}
