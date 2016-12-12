struct Day6 {

    static func run(input: String) {
        let lines = input.components(separatedBy: .newlines)
        let peeked = lines[0]
        var columns = [[String: Int]](repeating: [:], count: peeked.characters.count)

        // Measure popularity
        for line in lines {
            for (i, character) in line.characters.enumerated() {
                let charString = String(character)
                columns[i][charString] = (columns[i][charString] ?? 0) + 1
            }
        }

        // Sort by popularity and build the corrected names
        var errorCorrectedName = [String]()
        var errorCorrectedName2 = [String]()
        for column in columns {
            let sortedColumn = column.sorted(by: { kv1, kv2 in
                return kv1.value > kv2.value
            })

            let mostPopularCharacter = sortedColumn[0]
            errorCorrectedName.append(mostPopularCharacter.key)

            let leastPopularCharacher = sortedColumn.last!
            errorCorrectedName2.append(leastPopularCharacher.key)
        }

        print("The error-corrected name is \(errorCorrectedName.joined())")
        print("The 2nd error-corrected name is \(errorCorrectedName2.joined())")
    }

}
