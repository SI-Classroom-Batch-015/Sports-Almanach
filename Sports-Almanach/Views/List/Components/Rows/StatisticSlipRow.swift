//
//  LogoutButton.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 23.3.2025
//

import SwiftUI

/// Anzeigen der Wettscheinnummer und Status in der StatisticView
struct StatisticSlipRow: View {
    let betSlip: BetSlip
    
    var body: some View {
        
        HStack(spacing: 4) {
            Text("#\(betSlip.slipNumber)")
                .font(.system(.body, design: .monospaced))
                .bold()
            Text(betSlip.isWon ? "Won" : "Fail")
                .font(.caption)
                .bold()
                .padding(.horizontal, 4)
                .background(
                    Capsule()
                        .fill(betSlip.isWon ? .green : .red)
                )
        }
        .foregroundColor(.white)
        .padding(12)
        .frame(height: 40)
        .background(.gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 1)
        )
    }
}


// MARK: - Preview
#Preview {
    VStack {
        StatisticSlipRow(
            betSlip: BetSlip(
                userId: "test",
                slipNumber: 1,
                bets: [],
                isWon: true
            )
        )
        StatisticSlipRow(
            betSlip: BetSlip(
                userId: "test",
                slipNumber: 2,
                bets: [],
                isWon: false
            )
        )
    }
    .padding()
    .background(.black)
}
