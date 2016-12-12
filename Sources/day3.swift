struct Day3 {

    static func validTriangle(one: Int, two: Int, three: Int) -> Bool {
        if !(one + two > three) {
            return false
        }
        if !(two + three > one) {
            return false
        }
        if !(three + one > two) {
            return false
        }
        return true
    }

    static func run(input: String) {
        var possible = 0
        var columns = [[Int]](repeating: [Int](), count: 3)

        for row in input.components(separatedBy: "\n") {
            let values = row.components(separatedBy: .whitespaces)
                .filter { $0 != "" }
                .flatMap { Int($0) }
            guard values.count == 3 else {
                fatalError("Expected three ints in row: \(row)")
            }

            columns[0].append(values[0])
            columns[1].append(values[1])
            columns[2].append(values[2])

            if validTriangle(one: values[0], two: values[1], three: values[2]) {
                possible += 1
            }
        }

        print("\(possible) triangles are possible")

        // 2nd pass
        possible = 0

        for column in columns {
            var i = 0
            while i < columns[0].count {
                if validTriangle(one: column[i], two: column[i + 1], three: column[i + 2]) {
                    possible += 1
                }
                i += 3
            }
        }

        print("2nd pass: \(possible) triangles are possible")
    }
}
