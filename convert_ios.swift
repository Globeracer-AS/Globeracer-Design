#!/usr/bin/swift

import Foundation

// MARK: - Input & Helpers

struct ColorToken: Codable {
    let light: String
    let dark: String
}

struct ResponsiveToken: Codable {
    let mobile: Double
}

typealias ColorMap = [String: ColorToken]
typealias ResponsiveMap = [String: ResponsiveToken]

func camelToEnumCase(_ key: String) -> String {
    let pattern = "([a-z])([A-Z])"
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    let range = NSRange(location: 0, length: key.count)
    return regex.stringByReplacingMatches(in: key, options: [], range: range, withTemplate: "$1_$2").lowercased()
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

// MARK: - Main

let inputURL = URL(fileURLWithPath: "tokens.json")
let data = try Data(contentsOf: inputURL)
let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

guard let mapped = json["mapped"] as? [String: [String: String]],
      let responsive = json["responsive"] as? [String: [String: Any]] else {
    fatalError("Invalid JSON structure")
}

// MARK: - Output Swift Code

var output = "import SwiftUI\n\n"

output += "\nextension Color {\n"
for (name, color) in mapped.sorted(by: { a, b in a.0 < b.0 }) {
    output += """
    public static var \(name): Color {
        Color(UIColor(dark: "\(color["dark"] ?? "#000000")", light: "\(color["light"] ?? "#FFFFFF")"))
    }

"""
}
output += "}\n\n"

var groupedEnums: [String: [(String, Double)]] = [:]
for (key, values) in responsive.sorted(by: { a, b in a.0 < b.0 }) {
    guard let mobile = values["mobile"] as? Double else { continue }
    if let (enumType, enumCase) = enumName(for: key) {
        groupedEnums[enumType, default: []].append((enumCase, mobile))
    }
}

output += "public enum Design {\n"
for (type, values) in groupedEnums.sorted(by: { a, b in a.0 < b.0 }) {
    output += """
    public struct \(type.prefix(1).uppercased() + type.dropFirst()): Hashable, Sendable {
        public let value: CGFloat
        private init(_ value: CGFloat) { self.value = value }

"""
    for (caseName, value) in values.sorted(by: { $0.1 < $1.1 }) {
        output += "        // \(value)\n"
        output += "        public static let \(caseName) = Self(\(value))\n"
    }
    output += "    }\n"
}
output += "}\n"

// MARK: - Write File

let outputPath = FileManager.default.currentDirectoryPath + "/Sources/DesignTokens/DesignTokens.swift"
try output.write(toFile: outputPath, atomically: true, encoding: .utf8)
print("✅ Generated Swift tokens to \(outputPath)")
