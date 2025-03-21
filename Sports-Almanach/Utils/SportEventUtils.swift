//
//  SportEventUtils.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 24.09.24.
//

import Foundation

/// Zentrale Utility-Klasse für Basis-Berechnungen im Wettsystem
struct SportEventUtils {
    // MARK: - Konstanten für Basisquoten
    private static let minimumOdds: Double = 1.2
    private static let baseHomeOdds: Double = 2.0
    private static let baseAwayOdds: Double = 2.5
    private static let baseDrawOdds: Double = 3.0
    
    // MARK: - Basis-Berechnungen, Quoten für ein Event
    static func calculateOdds(for event: Event) -> (homeWinOdds: Double, drawOdds: Double, awayWinOdds: Double) {
        let homeScore = Int(event.homeScore ?? "") ?? 0
        let awayScore = Int(event.awayScore ?? "") ?? 0
        let totalGoals = homeScore + awayScore
        if totalGoals == 0 {
            return (baseHomeOdds, baseDrawOdds, baseAwayOdds)
        }
        let homeWinOdds = max(minimumOdds, Double(awayScore + 1) / Double(homeScore + 1))
        let awayWinOdds = max(minimumOdds, Double(homeScore + 1) / Double(awayScore + 1))
        let drawOdds = abs(homeScore - awayScore) <= 1 ? 3.0 : 5.0
        return (homeWinOdds, drawOdds, awayWinOdds)
    }
}
