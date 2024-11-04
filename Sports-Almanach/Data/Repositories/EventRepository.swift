//
//  EventRepository.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 14.10.24.
//

import Foundation
import SwiftUI

/// Kümmert sich um die Kommunikation mit der API und die Datenverarbeitung
class EventRepository {
    
    private let useMockData = false // Umschalten zwischen API und Mock-Daten
    
    func fetchEvents(for season: Season) async throws -> [Event] {
        if useMockData {
            return fetchMockEvents(for: season)
        } else {
            return try await fetchApiEvents(for: season)
        }
    }
    
    // API-Call
    private func fetchApiEvents(for season: Season) async throws -> [Event] {
        let urlString = "https://www.thesportsdb.com/api/v1/json/3/eventsseason.php?id=4328&s=\(season.rawValue)"
        
        guard let url = URL(string: urlString) else {
            throw ApiError.invalidURL
        }
        print("URL-String: \(urlString)")
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            /// Fehlermanagement: Rohe Daten ausgeben
            //  print("------- Rohe Daten: \(data)")
            
            if let dataString = String(data: data, encoding: .utf8) {
            // print("------- Daten empfangen: \(dataString)")
            } else {
                print("Fehler beim Konvertieren der Daten in einen String.")
            }
            
            // JSONDecoder konfigurieren
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            let response = try decoder.decode(EventResponse.self, from: data)
            
            /// Fehlermanagement:  Werte der Properties ausgeben
            // for event in response.events {
//                print("------- Werte der Properties")
//                print("Event: \(event.name)")
//                print("  id: \(event.id)")
//                print("  sport: \(event.sport)")
//                print("  leagueName: \(event.leagueName)")
//                print("  leagueImage: \(event.leagueImage)")
//                print("  season: \(event.season)")
//                print("  homeTeam: \(event.homeTeam)")
//                print("  awayTeam: \(event.awayTeam)")
//                print("  homeScore: \(event.homeScore ?? "0")") // Wenn nil
//                print("  awayScore: \(event.awayScore ?? "0")")
//                print("  videoURL: \(event.videoURL ?? "Kein Video")")
//                print("  homeTeamBadge: \(event.homeTeamBadge ?? "Kein Heimteam Wappen")")
//                print("  awayTeamBadge: \(event.awayTeamBadge ?? "Kein Auswärtsteam Wappen")")
//                print("  statusString: \(event.statusString)")
//            }
            
            return response.events
        } catch let decodingError as DecodingError {
            print("Fehler beim Dekodieren der Daten: \(decodingError.localizedDescription)")
            throw ApiError.decodingFailed
        } catch {
            print("Anfrage an den Server ist fehlgeschlagen: \(error.localizedDescription)")
            throw ApiError.requestFailed
        }
    }
    
    // Mock-Daten
    private func fetchMockEvents(for season: Season) -> [Event] {
        return MockEvents.events.filter { $0.season == season.rawValue }
    }
}
