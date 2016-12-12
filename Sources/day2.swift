let keypad: [[String?]] = [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]
let keypad2: [[String?]] = [
    [nil, nil, "1", nil, nil],
    [nil, "2", "3", "4", nil],
    ["5", "6", "7", "8", "9"],
    [nil, "A", "B", "C", nil],
    [nil, nil, "D", nil, nil]
]

struct Day2 {
    struct Position {
        var vertical: Int
        var horizontal: Int
    }

    struct Keypad {
        let layout: [[String?]]
        let bounds: Int
        let startPoint: Position

        static var small: Keypad {
            return Keypad(
                layout: keypad,
                bounds: 2,
                startPoint: Position(vertical: 1, horizontal: 1)
            )
        }

        static var big: Keypad {
            return Keypad(
                layout: keypad2,
                bounds: 4,
                startPoint: Position(vertical: 2, horizontal: 0)
            )
        }

        subscript(position: Position) -> String? {
            return layout[position.vertical][position.horizontal]
        }
    }

    class Actor {
        let keypad: Keypad

        var position: Position

        var digit: String? {
            return keypad[position]
        }

        init(keypad: Keypad) {
            self.keypad = keypad
            self.position = keypad.startPoint
        }

        func move(to: Direction) {
            var position = self.position

            switch to {
            case .up:
                position.vertical = max(position.vertical - 1, 0)
            case .right:
                position.horizontal = min(position.horizontal + 1, keypad.bounds)
            case .down:
                position.vertical = min(position.vertical + 1, keypad.bounds)
            case .left:
                position.horizontal = max(position.horizontal - 1, 0)
            }
            
            if keypad[position] != nil {
                self.position = position
            }
        }
    }

    public static func run(input: String) {
        var digits = ""
        var digits2 = ""

        for movements in input.components(separatedBy: .newlines) {
            let actor = Actor(keypad: Keypad.small)
            let actor2 = Actor(keypad: Keypad.big)
            for movement in movements.characters {
                guard let direction = Direction(rawValue: movement) else {
                    fatalError("Dont know this direction: \(movement)")
                }
                actor.move(to: direction)
                actor2.move(to: direction)
            }
            digits += actor.digit ?? ""
            digits2 += actor2.digit ?? ""
        }

        print("Digits = \(digits)")
        print("2nd Keypad Digits = \(digits2)")
    }
}
