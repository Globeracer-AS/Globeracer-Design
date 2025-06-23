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

// MARK: - Generate light-colors.xml
var lightColorsXML = """
<?xml version="1.0" encoding="utf-8"?>
<resources>\n
"""

for (name, val) in mapped.sorted(by: { a, b in a.0 < b.0 }) {
    let light = sanitizeColor(val["light"] ?? "#FFFFFF")
    lightColorsXML += """
    <color name="\(name)">\(light)</color>\n
"""
}
lightColorsXML += "\n</resources>\n"

// MARK: - Generate dark-colors.xml
var darkColorsXML = """
<?xml version="1.0" encoding="utf-8"?>
<resources>\n
"""

for (name, val) in mapped.sorted(by: { a, b in a.0 < b.0 }) {
    let dark = sanitizeColor(val["dark"] ?? "#000000")
    darkColorsXML += """
    <color name="\(name)">\(dark)</color>\n
"""
}
darkColorsXML += "\n</resources>\n"

// MARK: - Generate dimens.xml
var dimensXML = """
<?xml version="1.0" encoding="utf-8"?>
<resources>

"""

for (key, val) in responsive.sorted(by: { a, b in a.0 < b.0 }) {
    guard let mobile = val["mobile"] else { continue }

    // Convert keys to kebab-case
    let androidKey = key.replacingOccurrences(of: "([a-z])([A-Z])", with: "$1_$2", options: .regularExpression).lowercased()
    dimensXML += "    <dimen name=\"\(androidKey)\">\(mobile)dp</dimen>\n"
}

dimensXML += "</resources>\n"

// MARK: - Write Files
let fileManager = FileManager.default
let base = fileManager.currentDirectoryPath

try lightColorsXML.write(toFile: base + "/android/light-colors.xml", atomically: true, encoding: .utf8)
try darkColorsXML.write(toFile: base + "/android/dark-colors.xml", atomically: true, encoding: .utf8)
try dimensXML.write(toFile: base + "/android/dimens.xml", atomically: true, encoding: .utf8)

print("✅ Android XML files created: android/light-colors.xml, android/dark-colors.xml and android/dimens.xml")
