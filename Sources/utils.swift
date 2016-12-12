import Foundation

enum Side: String {
    case left = "L"
    case right = "R"
}

enum CompassPoint: Int {
    case north = 1
    case east = 2
    case south = 3
    case west = 4

    static var first = CompassPoint.north
    static var last = CompassPoint.west
}

enum Direction: Character {
    case up = "U"
    case right = "R"
    case down = "D"
    case left = "L"
}


/// Regex wrapper
/// from NSHipster - http://nshipster.com/swift-literal-convertible/
struct Regex {
    let pattern: String
    let options: NSRegularExpression.Options
    let matcher: NSRegularExpression

    init(pattern: String, options: NSRegularExpression.Options = NSRegularExpression.Options()) {
        self.pattern = pattern
        self.options = options
        self.matcher = try! NSRegularExpression(pattern: self.pattern, options: self.options)
    }

    func match(_ string: String, options: NSRegularExpression.MatchingOptions = NSRegularExpression.MatchingOptions()) -> Bool {
        let numberOfMatches = matcher.numberOfMatches(
            in: string,
            options: options,
            range: NSRange(location: 0, length: string.utf16.count)
        )
        return numberOfMatches != 0
    }

    func search(input: String,
                options: NSRegularExpression.MatchingOptions = NSRegularExpression.MatchingOptions()) -> [String] {
        let matches = matcher.matches(in: input,
                                      options: options,
                                      range: NSRange(location: 0, length: input.utf16.count))

        var groups = [String]()
        for match in matches as [NSTextCheckingResult] {
            // range at index 0: full match, skip that and add all groups to list
            for index in 1..<match.numberOfRanges {
                let substring = (input as NSString).substring(with: match.rangeAt(index))
                groups.append(substring)
            }
        }
        
        return groups
    }
}
