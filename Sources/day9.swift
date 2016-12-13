
struct Day9 {

    static let repeaterStart = "("
    static let repeaterRegex = Regex(pattern: "(\\d+)x(\\d+)\\)")

    static func expand(input: String, recurse: Bool = false) -> Int {
        var remainder = input
        var count = 0

        while !remainder.isEmpty {
            let current = String(remainder.characters.removeFirst())

            if current != repeaterStart {
                count += 1
                continue
            }

            guard let match = repeaterRegex.firstMatch(input: remainder) else {
                fatalError("Could not match parens")
            }

            // Pop off repeater
            let timesXLength = remainder.popTo(length: match.range.length)
                .replacingOccurrences(of: ")", with: "")
                .components(separatedBy: "x")

            let times = Int(timesXLength[1])!
            let length = Int(timesXLength[0])!

            if recurse {
                let toRepeatEndIndex = remainder.index(remainder.startIndex, offsetBy: length, limitedBy: remainder.endIndex) ?? remainder.endIndex
                let toRepeat = remainder.substring(to: toRepeatEndIndex)
                let repeatedCount = expand(input: toRepeat, recurse: true)
                _ = remainder.popTo(length: length)
                count += repeatedCount * times
            } else {
                let charsToRepeat = remainder.popTo(length: length)
                count += charsToRepeat.characters.count * times
            }

        }

        return count
    }

    static func run(input: String) {
        print("Count = \(expand(input: input))")
        print("Count 2nd pass = \(expand(input: input, recurse: true))")
    }

}
