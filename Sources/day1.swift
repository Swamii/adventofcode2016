import Foundation

struct Day1 {

    struct Position: Hashable {
        var vertical: Int
        var horizontal: Int

        var fromStart: Int {
            return abs(horizontal) + abs(vertical)
        }

        var hashValue: Int {
            return (31 &* vertical.hashValue) &+ vertical.hashValue
        }

    }

    class Actor {
        var position = Position(vertical: 0, horizontal: 0)
        var facing = CompassPoint.north
        var history: Set<Position> = Set()
        var firstVisitedTwice: Position?

        func move(path: String) {
            let index = path.index(path.startIndex, offsetBy: 1)
            guard let side = Side(rawValue: path.substring(to: index)) else {
                print("Direction not found in path: \(path)")
                return
            }
            guard let steps = Int(path.substring(from: index)) else {
                print("Number of steps not found in path: \(path)")
                return
            }
            // print("New instructions: \(side) \(steps)" )

            setDirection(side: side)
            // print("Now facing \(facing)")
            setPosition(steps: steps)
            // print("New position \(position)")
        }

        func setDirection(side: Side) {
            switch side {
            case .left:
                facing = CompassPoint(rawValue: facing.rawValue - 1) ?? CompassPoint.last
            case .right:
                facing = CompassPoint(rawValue: facing.rawValue + 1) ?? CompassPoint.first
            }
        }

        func setPosition(steps: Int) {
            for _ in 1...steps {
                history.insert(position)

                switch facing {
                case .north:
                    position.vertical += 1
                case .east:
                    position.horizontal += 1
                case .south:
                    position.vertical -= 1
                case .west:
                    position.horizontal -= 1
                }

                if firstVisitedTwice == nil && history.contains(position) {
                    firstVisitedTwice = position
                }
            }
        }
    }

    public static func run(input: String) {
        let actor = Actor()

        for movement in input.components(separatedBy: ", ") {
            actor.move(path: movement)
        }

        print("Done. Moved \(actor.position.fromStart) blocks away from startpoint")

        if let visitedTwice = actor.firstVisitedTwice {
            print(
                "First position visited twice was \(visitedTwice).",
                "\(visitedTwice.fromStart) blocks away"
            )
        }

    }
}

func == (lhs: Day1.Position, rhs: Day1.Position) -> Bool {
    return lhs.vertical == rhs.vertical && lhs.horizontal == rhs.horizontal
}
