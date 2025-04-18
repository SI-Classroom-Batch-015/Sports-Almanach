//
//  Season.swift
//  Sports-Almanach
//
//  Created by Michael Fleps on 27.09.24.
//

import Foundation

/// Jahreszahlenbereiche (Saison)
enum Season: String, Identifiable, CaseIterable, CustomStringConvertible {
    case season20202021 = "2020-2021"
    case season20212022 = "2021-2022"
    case season20222023 = "2022-2023"
    case season20232024 = "2023-2024"
    case season20242025 = "2024-2025"
    
    var id: String { rawValue }
    
    // CustomStringConvertible Konformität
    var description: String { year }
    var year: String { rawValue }
    
    static var defaultSeason: Season { return .season20202021 }
}
