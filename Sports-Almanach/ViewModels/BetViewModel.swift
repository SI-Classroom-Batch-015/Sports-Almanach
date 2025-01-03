//
//  BetViewModel.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation
import SwiftUICore
import FirebaseFirestore

class BetViewModel: ObservableObject {
    
    @EnvironmentObject var userViewModel: UserViewModel
    @Published var selectedBetEvent: Event?
    @Published var betAmount: Double = 0.0 {
        didSet {
            potentialWinAmount = calculatePossibleWin()
        }
    }
    @Published var betOutcomeResult: BetOutcome?
    @Published var totalOdds: Double = 0.0
    @Published var potentialWinAmount: Double = 0.0
    @Published var bets: [Bet] = []
    
    /// Bestimmt den Spielausgang basierend auf den Toren
    func theWinnerIs(homeGoals: Int, awayGoals: Int) -> BetOutcome {
        if homeGoals > awayGoals {
            return .homeWin
        } else if homeGoals < awayGoals {
            return .awayWin
        } else {
            return .draw
        }
    }
    
    /// Aktualisiert die Gesamtquote aller Wetten
    func updateTotalOdds() {
        if bets.isEmpty {
            // Keine Wette
            totalOdds = 0.0
            betAmount = 0.0
        } else {
            // Multipliziert minimum mit 1
            totalOdds = bets.reduce(1) { result, bet in
                result * bet.odds
            }
        }
        // Möglichen Gewinn neu, auf Basis der aktualisierten Gesamtquote
           potentialWinAmount = calculatePossibleWin()
    }
    
    /// Möglicher Gewinn
    func calculatePossibleWin() -> Double {
        return betAmount * totalOdds
    }
    
    /// Kontostand zurückzusetzen
    func resetBalance() {
        userViewModel.balance = userViewModel.startMoney
        print("Kontostand wurde zurückgesetzt auf: \(userViewModel.startMoney)")
    }
    
    /// Überprüfe, ob bereits eine Wette für das gleiche Event existiert
    func isBetAlreadyExists(for event: Event) -> Bool {
        return bets.contains(where: { $0.event.id == event.id })
    }
    
    /// Führt die Wette aus
    func placeBet(on event: Event, outcome: BetOutcome, betAmount: Double) {
        
        // Wetteinsatz größer als Kontostand -> Fehler
        guard betAmount <= userViewModel.balance else {
            print("Fehler: Nicht genügend Guthaben.")
            return
        }
        
        // Berechnet die Quoten
        let odds = OddsCalculator.calculateOdds(for: event)
        // Ergebnis basierend auf der Auswahl und den Quoten
        var winAmount: Double = 0.0
        switch outcome {
        case .homeWin:
            winAmount = betAmount * odds.homeWinOdds
        case .draw:
            winAmount = betAmount * odds.drawOdds
        case .awayWin:
            winAmount = betAmount * odds.awayWinOdds
        }
        
        // Aktualisiert den Kontostand
        let newBalance = userViewModel.balance - betAmount + winAmount
        userViewModel.balance = newBalance
        
        // In Firestore aktualisieren (über UserViewModel)
        userViewModel.updateProfile(newBalance: newBalance)
        
        // Wette in Firestore speichern
        guard let userId = FirebaseAuthManager.shared.userID else {
            print("Fehler: Benutzer-ID nicht gefunden.")
            return
        }
        
        let dataB = Firestore.firestore()
        let betData: [String: Any] = [
            "userId": userId,
            "eventId": event.id,
            "betAmount": betAmount,
            "outcome": outcome.rawValue, // Enum als String
            "winAmount": winAmount,
            "timestamp": Timestamp()
        ]
        
        // Speichern in der "Bets"-Collection
        dataB.collection("Bets").addDocument(data: betData) { error in
            if let error = error {
                print("Fehler beim Speichern der Wette: \(error)")
            } else {
                print("Wette erfolgreich gespeichert.")
            }
        }
        
        // Event und Ergebnis der Wette speichern und GesamtQu. aktual.
        selectedBetEvent = event
        betOutcomeResult = outcome
        updateTotalOdds()
    }
}
