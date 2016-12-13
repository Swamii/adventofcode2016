
struct Day8 {
    class Display: CustomStringConvertible {
        static let shared = Display()
        static let size = Size(width: 50, height: 6)
        static let emptyToken = "."
        static let filledToken = "#"

        lazy private var layout: [[String]] = {
            return [[String]](
                repeating: [String](repeating: Display.emptyToken, count: Display.size.width),
                count: Display.size.height
            )
        }()

        var tokensLit: Int {
            return layout.reduce(0, { result, row in
                return result + row.filter({ $0 == Display.filledToken }).count
            })
        }

        private init() {}

        func draw(size: Size) {
            // print("Drawing \(size.width)x\(size.height)")
            for row in 0..<size.height {
                for col in 0..<size.width {
                    layout[row][col] = Display.filledToken
                }
            }
        }

        func moveCol(col: Int, steps: Int) {
            // Flatten column
            var column = layout.map { $0[col] }

            for _ in 0..<steps {
                column.insert(column.popLast()!, at: 0)
            }

            for i in 0..<layout.count {
                layout[i][col] = column[i]
            }
        }

        func moveRow(row: Int, steps: Int) {
            for _ in 0..<steps {
                layout[row].insert(layout[row].popLast()!, at: 0)
            }
        }

        // MARK: CustomStringConvertible

        var description: String {
            var desc = [String]()
            for row in layout {
                desc.append(row.joined())
            }
            return desc.joined(separator: "\n")
        }
    }

    struct Parser {
        static var rectRegex = Regex(pattern: "rect (\\d+)x(\\d+)")
        static var rotateColRegex = Regex(pattern: "rotate column x=(\\d+) by (\\d+)")
        static var rotateRowRegex = Regex(pattern: "rotate row y=(\\d+) by (\\d+)")

        enum Move {
            case rect(Size)
            case rotateCol(col: Int, steps: Int)
            case rotateRow(row: Int, steps: Int)
        }

        static func move(input: String) -> Move? {
            let rectPos = rectRegex.search(input: input)
            if rectPos.count == 2 {
                return Move.rect(Size(width: Int(rectPos[0])!, height: Int(rectPos[1])!))
            }

            let rotateCol = rotateColRegex.search(input: input)
            if rotateCol.count == 2 {
                return Move.rotateCol(col: Int(rotateCol[0])!, steps: Int(rotateCol[1])!)
            }

            let rotateRow = rotateRowRegex.search(input: input)
            if rotateRow.count == 2 {
                return Move.rotateRow(row: Int(rotateRow[0])!, steps: Int(rotateRow[1])!)
            }

            return nil
        }
    }

    static func run(input: String) {

        for line in input.components(separatedBy: .newlines) {
            guard let move = Parser.move(input: line) else {
                print("Invalid command: '\(line)'")
                continue
            }

            // print("Handling parsed input: '\(line)'")
            switch move {
            case .rect(let size):
                Display.shared.draw(size: size)
            case .rotateCol(let (col, steps)):
                Display.shared.moveCol(col: col, steps: steps)
            case .rotateRow(let (row, steps)):
                Display.shared.moveRow(row: row, steps: steps)
            }

            // print(Display.shared, "\n")
        }

        print("Number of pixels lit: \(Display.shared.tokensLit)")

        print("\nHidden code:")
        print(Display.shared, "\n")
    }
}
