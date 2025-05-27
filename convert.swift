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

output += """
extension UIColor {
    fileprivate convenience init(dark: String, light: String) {
#if os(iOS) || os(tvOS)
        self.init { traits -> UIColor in
            if traits.userInterfaceStyle == .dark {
                return UIColor(hex: dark)
            } else {
                return UIColor(hex: light)
            }
        }
#else
        self.init(hex: dark)
#endif
    }

    fileprivate convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let a, r, g, b: UInt64
        switch hexSanitized.count {
        case 8: (a, r, g, b) = (rgb >> 24, (rgb >> 16) & 0xff, (rgb >> 8) & 0xff, rgb & 0xff)
        case 6: (a, r, g, b) = (255, rgb >> 16, (rgb >> 8) & 0xff, rgb & 0xff)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

"""

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
    output += "    public enum \(type.prefix(1).uppercased() + type.dropFirst()): CGFloat {\n"
    for (caseName, value) in values.sorted(by: { $0.1 < $1.1 }) {
        output += "        case \(caseName) = \(value)\n"
    }
    output += "    }\n"
}
output += "}\n"

// MARK: - Write File

let outputPath = FileManager.default.currentDirectoryPath + "/Sources/DesignTokens/DesignTokens.swift"
try output.write(toFile: outputPath, atomically: true, encoding: .utf8)
print("✅ Generated Swift tokens to \(outputPath)")
