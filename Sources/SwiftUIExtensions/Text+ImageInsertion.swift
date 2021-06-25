// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//  Created by Sam Deane on 21/05/21.
//  All code (c) 2021 - present day, Elegant Chaos Limited.
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

import SwiftUI

@available(iOS 14.0, tvOS 14.0, macOS 11.0, *) public extension Text {
    static let defaultImagePattern = try! NSRegularExpression(pattern: "\\<(.*)\\>", options: [])

    static func text(insertingImagesIn string: String, pattern: NSRegularExpression = defaultImagePattern, baselineOffset: CGFloat = -4.0) -> Text {
        
        let matches = pattern.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
        if matches.count == 0 {
            return Text(string)
        } else {
            var buffer = Text("")
            var position = string.startIndex
            for match in matches {
                let range = match.range(at: 1)
                let from = string.index(string.startIndex, offsetBy: range.location)
                let to = string.index(from, offsetBy: range.length)
                let name = String(string[from..<to])
                let range2 = match.range(at: 0)
                let from2 = string.index(string.startIndex, offsetBy: range2.location)
                let to2 = string.index(from2, offsetBy: range2.length)
                let fragment = String(string[position..<from2])
                buffer = buffer + Text(fragment) + Text(Image(name)).baselineOffset(baselineOffset)
                position = to2
            }
            buffer = buffer + Text(string[position...])
            return buffer
        }
    }

}
