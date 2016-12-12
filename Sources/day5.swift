import CryptoSwift

struct Day5 {
    static func run(input: String) {
        var keyCode = ""
        var keyCode2 = [String](repeating: "", count: 8)
        var nextSequence = input
        var i: UInt64 = 0

        while true {
            let hashed = nextSequence.md5()

            if hashed.hasPrefix("00000") {
                let sixth = hashed[hashed.index(hashed.startIndex, offsetBy: 5)]
                if keyCode.characters.count != 8 {
                    keyCode.append(sixth)
                }

                if let position = Int(String(sixth)),
                    position >= 0 && position < 8 && keyCode2[position] == "" {
                        let seventh = hashed[hashed.index(hashed.startIndex, offsetBy: 6)]
                        keyCode2[position] = String(seventh)
                }

                if keyCode.characters.count == 8 && keyCode2.filter({ $0 == "" }).count == 0 {
                    break
                }
            }

            i += 1
            nextSequence = input + String(i)
        }

        print("keyCode = \(keyCode)")
        print("keyCode2 = \(keyCode2.joined())")
    }
}
