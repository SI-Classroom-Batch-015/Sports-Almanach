//
//  BetRow.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 23.10.24.
//

import SwiftUI

struct BetRow: View {
    
    @EnvironmentObject var betViewModel: BetViewModel
    @EnvironmentObject var eventViewModel: EventViewModel
    @State private var showAlert = false
    @State private var selectedTip: UserTip?
    let event: Event
    
    /// Ob eine Wette ausgewählt wurde
    private var isButtonActive: Bool {
        selectedTip != nil
    }
    
    /// Fügt Wette hinzu und entfernt Event aus der Liste
    private func addBetAndRemoveEvent() {
        let odds = SportEventUtils.calculateOdds(for: event)
        guard let userTip = selectedTip else { return }
        
        // Quote basierend auf User-Tipp ermitteln
        let currentOdds = switch userTip {
        case .homeWin: odds.homeWinOdds
        case .draw: odds.drawOdds
        case .awayWin: odds.awayWinOdds
        }
        let bet = Bet(
            id: UUID(),
            event: event,
            userTip: userTip,
            odds: currentOdds,
            winAmount: nil,
            timestamp: Date()
        )
        if !betViewModel.bets.contains(where: { $0.event.id == event.id }) {
            // 1. Wette zum Wettschein hinzufügen
            betViewModel.addBet(bet)
            
            // 2. Event aus UI und Firestore entfernen
            Task {
                await eventViewModel.removeFromSelectedEvents(event)
            }
            selectedTip = nil
        } else {
            showAlert = true
        }
    }
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.name)
                .font(.headline)
                .padding(.horizontal, 16)
            HStack {
                Text("\(event.date) um \(event.time)")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            .padding(.horizontal, 16)
            
            // Wettquoten
            let odds = SportEventUtils.calculateOdds(for: event)
            oddsGrid(odds: odds)
                .padding(.horizontal, 12)
            HStack {
                Spacer()
                PrimaryActionButton(
                    title: "Zum Wettschein",
                    action: addBetAndRemoveEvent,
                    isActive: isButtonActive
                )
                .frame(width: 200, height: 40)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.orange, lineWidth: 2)
        )
        .padding(.horizontal, 16)
        .alert("Wette existiert bereits!", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
    
    // MARK: - Grid für die Quotenanzeige
    private func oddsGrid(odds: (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double)) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            QuoteRow(title: "1 (Heimsieg)",
                     odds: odds.homeWinOdds,
                     isSelected: selectedTip == .homeWin) {
                selectedTip = (selectedTip == .homeWin) ? nil : .homeWin
            }
            QuoteRow(title: "0 (Unentschieden)",
                     odds: odds.drawOdds,
                     isSelected: selectedTip == .draw) {
                selectedTip = (selectedTip == .draw) ? nil : .draw
            }
            QuoteRow(title: "2 (Auswärtssieg)",
                     odds: odds.awayWinOdds,
                     isSelected: selectedTip == .awayWin) {
                selectedTip = (selectedTip == .awayWin) ? nil : .awayWin
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - QuoteRow
private struct QuoteRow: View {
    let title: String
    let odds: Double
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(String(format: "%.2f", odds))
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .foregroundColor(.orange)
                .onTapGesture(perform: action)
        }
    }
}

// MARK: - Preview
#Preview {
    let mockEvent = Mocks.events.first!
    return BetRow(event: mockEvent)
        .environmentObject(BetViewModel())
        .environmentObject(EventViewModel())
}
