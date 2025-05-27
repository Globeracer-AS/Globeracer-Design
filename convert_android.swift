#!/usr/bin/swift

import Foundation

struct ColorToken: Codable {
    let light: String
    let dark: String
}

struct ResponsiveToken: Codable {
    let mobile: Double
}

func sanitizeColor(_ hex: String) -> String {
    let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
    if hex.count == 8 {
        // Convert ARGB to AARRGGBB
        return "#" + hex
    } else if hex.count == 6 {
        return "#FF" + hex
    } else if hex.count == 4 {
        // Convert shorthand #RGBA
        return "#\(hex.map { "\($0)\($0)" }.joined())"
    } else {
        return "#FFFFFFFF" // fallback to white
    }
}

func enumName(for key: String) -> (String, String)? {
    let pattern = #"^([a-z]+)([A-Z].+)$"#
    let regex = try! NSRegularExpression(pattern: pattern)
    guard let match = regex.firstMatch(in: key, range: NSRange(key.startIndex..., in: key)) else {
        return nil
    }
    let nsKey = key as NSString
    let enumType = nsKey.substring(with: match.range(at: 1))
    let enumCase = nsKey.substring(with: match.range(at: 2))
    return (enumType, enumCase.prefix(1).lowercased() + enumCase.dropFirst())
}

// MARK: - Read JSON
let inputURL = URL(fileURLWithPath: "tokens.json")
let data = try Data(contentsOf: inputURL)
let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

guard let mapped = json["mapped"] as? [String: [String: String]],
      let responsive = json["responsive"] as? [String: [String: Any]] else {
    fatalError("Invalid JSON structure")
}

// MARK: - Generate colors.xml
var colorsXML = """
<?xml version="1.0" encoding="utf-8"?>
<resources>

"""

for (name, val) in mapped {
    let light = sanitizeColor(val["light"] ?? "#FFFFFF")
    let dark = sanitizeColor(val["dark"] ?? "#000000")
    
    colorsXML += """
    <color name="\(name)">\(light)</color>
    <!-- Dark variant: \(dark) -->
"""
}
colorsXML += "\n</resources>\n"

// MARK: - Generate dimens.xml
var dimensXML = """
<?xml version="1.0" encoding="utf-8"?>
<resources>

"""

for (key, val) in responsive {
    guard let mobile = val["mobile"] else { continue }

    // Convert keys to kebab-case
    let androidKey = key.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1_$2", options: .regularExpression).lowercased()
    dimensXML += "    <dimen name=\"\(androidKey)\">\(mobile)dp</dimen>\n"
}

dimensXML += "</resources>\n"

// MARK: - Write Files
let fileManager = FileManager.default
let base = fileManager.currentDirectoryPath

try colorsXML.write(toFile: base + "/android/colors.xml", atomically: true, encoding: .utf8)
try dimensXML.write(toFile: base + "/android/dimens.xml", atomically: true, encoding: .utf8)

print("✅ Android XML files created: android/colors.xml and android/dimens.xml")
