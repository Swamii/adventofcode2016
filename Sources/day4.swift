
struct Day4 {

    static func rotN(c: UnicodeScalar, n: UInt32) -> UnicodeScalar {
        var reversed = Int(UInt32(c) + (n % 26))
        let remainder = reversed - 122
        if remainder > 0 {
            reversed = 96 + remainder
        }

        return UnicodeScalar(UInt32(reversed)) ?? c
    }

    class Room {
        let name: String
        let sectorId: Int
        let checksum: String
        private var _valid: Bool?

        init(name: String, sectorId: Int, checksum: String) {
            self.name = name
            self.sectorId = sectorId
            self.checksum = checksum
        }

        var valid: Bool {
            if _valid == nil {
                _valid = validate()
            }

            return _valid!
        }

        var isNorthPoleRoom: Bool = false

        var secretName: String {
            let pieces = name.characters.split(separator: "-").map { String($0) }
            var finalPieces = [String]()

            for piece in pieces {
                let chars = piece.unicodeScalars.map { c in
                    Character(Day4.rotN(c: c, n: UInt32(sectorId)))
                }
                finalPieces.append(String(chars).capitalized)
            }

            return finalPieces.joined(separator: " ")
        }

        private func validate() -> Bool {
            var charInstances = [Character: Int]()

            for character in name.replacingOccurrences(of: "-", with: "").characters {
                charInstances[character] = (charInstances[character] ?? 0) + 1
            }

            let topCharacters = charInstances
                .sorted { (kv1, kv2) in
                    if kv1.value == kv2.value {
                        return kv1.key < kv2.key
                    }
                    return kv1.value > kv2.value
                }
                .map { String($0.key) }
                .prefix(upTo: 5)
                .joined(separator: "")

            return topCharacters == checksum
        }
    }

    public static func run(input: String) {
        let regex = Regex(pattern: "([a-z\\-]+)-(\\d+)\\[([a-z]{5})\\]")

        var rooms = [Room]()

        for line in input.components(separatedBy: .newlines) {
            let matches = regex.search(input: line)
            guard matches.count == 3 else {
                fatalError("Expected 3 matches to be found for line: \(line)")
            }

            let name = matches[0]
            let sectorId = Int(matches[1])!
            let checksum = matches[2]

            let room = Room(name: name, sectorId: sectorId, checksum: checksum)
            rooms.append(room)
        }

        let sectorSum = rooms.reduce(0, { result, room in
            result + (room.valid ? room.sectorId : 0)
        })
        print("Sum of valid sectors: \(sectorSum)")

        if let specialRoom = rooms.filter({ $0.secretName.hasPrefix("North") }).first {
            print("The secret room was \(specialRoom.secretName) with sector id \(specialRoom.sectorId)")
        }
    }
}
