#!/usr/bin/swift

import Foundation

enum Discrepancy: String, Hashable, CaseIterable {
    case missingLight = "Colors missing light mode variant"
    case missingDark = "Colors missing dark mode variant"
    case sameValueForLightAndDark = "Colors with same value for light and dark"
}

let inputURL = URL(fileURLWithPath: "tokens.json")
let data = try Data(contentsOf: inputURL)
let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

var discrepancies: [Discrepancy: [String]] = [:]
Discrepancy.allCases.forEach { discrepancy in
    discrepancies[discrepancy] = []
}

guard let mapped = json["mapped"] as? [String: [String: String]] else {
    fatalError("Invalid JSON structure")
}

for (name, color) in mapped {
    let light = color["light"]
    let dark = color["dark"]

    if light == nil {
        discrepancies[.missingLight]!.append(name)
    }
    if dark == nil {
        discrepancies[.missingDark]!.append(name)
    }
    if let light, let dark, light == dark {
        discrepancies[.sameValueForLightAndDark]!.append("\(name) (\(light))")
    }
}

var anyIssues = false
for discrepancy in Discrepancy.allCases {
    let issues = discrepancies[discrepancy]!.sorted()
    if !issues.isEmpty {
        if !anyIssues {
            print("❌ Found issues in 'tokens.json'\n")
        }

        anyIssues = true

        print("\(discrepancy.rawValue):")
        for issue in issues {
            print(" - \(issue)")
        }
    }
}

if !anyIssues {
    print("✅ No issues found")
}
