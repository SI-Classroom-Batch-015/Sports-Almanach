//
//  OddsRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 28.09.24.
//

import SwiftUI

struct OddsRow: View {
    
    @State private var selectedOdd: BetOutcome? 
    let event: Event
    
    var body: some View {
        
        // Wettquoten-Anzeige
        VStack(alignment: .leading, spacing: 10) {
            
            let odds = OddsCalculator.calculateOdds(for: event)
            
            HStack {
                Text("Heimsieg:")
                Spacer()
                Text("\(String(format: "%.2f", odds.homeWinOdds))")
                Image(systemName: selectedOdd == .homeWin ? "checkmark.square.fill" : "square")
                    .foregroundColor(.orange)
                    .onTapGesture {
                        selectOdd(.homeWin)
                    }
            }
            
            HStack {
                Text("Unentschieden:")
                Spacer()
                Text("\(String(format: "%.2f", odds.drawOdds))")
                Image(systemName: selectedOdd == .draw ? "checkmark.square.fill" : "square")
                    .foregroundColor(.orange)
                    .onTapGesture {
                        selectOdd(.draw)
                    }
            }
            
            HStack {
                Text("Auswärtssieg:")
                Spacer()
                Text("\(String(format: "%.2f", odds.awayWinOdds))")
                Image(systemName: selectedOdd == .awayWin ? "checkmark.square.fill" : "square")
                    .foregroundColor(.orange)
                    .onTapGesture {
                        selectOdd(.awayWin)
                    }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .center)
        
        Spacer()
    }

    // Zur Auswahl einer Quote
    func selectOdd(_ oddType: BetOutcome) {
        if selectedOdd == oddType {
            selectedOdd = nil  // Wenn bereits ausgewählt
        } else {
            selectedOdd = oddType
        }
    }
}

#Preview {
    let mockEvent = MockEvents.events.first!
    return OddsRow(event: mockEvent)
}
