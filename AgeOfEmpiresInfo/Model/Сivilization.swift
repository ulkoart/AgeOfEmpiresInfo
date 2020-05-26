//
//  Сivilization.swift
//  AgeOfEmpiresInfo
//
//  Created by user on 25/05/2020.
//  Copyright © 2020 Artem Ulko. All rights reserved.
//

import Foundation

struct Civilization: Decodable {
    let name: String
    let expansion: Expansion
    let armyType: String
    let civilizationBonus: [String]
    
    enum Expansion: Decodable {
        case all
        case theConquerors
        case ageOfKings
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case expansion
        case armyType = "army_type"
        case civilizationBonus = "civilization_bonus"
    }
}

extension Civilization.Expansion: CaseIterable { }

extension Civilization.Expansion: RawRepresentable {
    
    init?(rawValue: String) {
        switch rawValue {
        case "All": self = .all
        case "The Conquerors": self = .theConquerors
        case "Age of Kings": self = .ageOfKings
        default: return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .all: return "All"
        case .theConquerors: return "The Conquerors"
        case .ageOfKings: return "Age of Kings"
        }
    }
}

struct СivilizationList: Decodable {
    let civilizations: [Civilization]
}

extension СivilizationList {
    static func civilizations() -> [Civilization] {
        guard
            let url = Bundle.main.url(forResource: "civilizations", withExtension: "json"),
            let data = try? Data(contentsOf: url)
            else { return [] }
        do {
            let decoder = JSONDecoder()
            let civilizationList = try decoder.decode(СivilizationList.self, from: data)
            return civilizationList.civilizations
        } catch { return [] }
    }
    
}
