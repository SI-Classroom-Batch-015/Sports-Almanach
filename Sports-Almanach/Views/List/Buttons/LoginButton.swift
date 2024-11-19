//
//  LoginButton.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 18.11.24.
//

import SwiftUI

struct LoginButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(
                    LinearGradient(
                        colors: [.black, .orange.opacity(0.8)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .cornerRadius(10)
                .shadow(color: .orange, radius: 4, x: -2, y: -2)
        }
    }
}
