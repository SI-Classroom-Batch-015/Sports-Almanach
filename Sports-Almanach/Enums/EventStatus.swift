//
//  EventStatus.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 10.09.24.
//

import Foundation
import SwiftUI

enum EventStatus: String, Codable, Identifiable, CaseIterable {
    case matchFinished = "Match Finished"
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case soonFinished = "Finished Soon"
    case unknown = "Unknown"  // Fallback
    
    var id: String { rawValue }
    
    var currentStatusGerman: String {
        switch self {
        case .matchFinished:
            return "Beendet"
        case .notStarted:
            return "Geplant"
        case .inProgress:
            return "Live"
        case .soonFinished:
            return "Endet bald"
        case .unknown: 
            return "Unbekannt"
        }
    }
    
    var color: Color {
        switch self {
        case .matchFinished:
            return .gray
        case .notStarted:
            return .green
        case .inProgress:
            return .yellow
        case .soonFinished:
            return .orange
        case .unknown:
            return .black
        }
    }
}
