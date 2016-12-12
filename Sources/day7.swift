struct Day7 {
    static var groupedIPAddr = Regex(pattern: "([a-z]+)(\\[?[a-z]*\\]?)")

    struct IPAddress {
        let address: String
        private let parts: [String]

        var supportsTLS: Bool {
            var validABBA = false

            for part in parts {
                let innerValidABBA = isABBA(part: part)

                if part.hasPrefix("[") && innerValidABBA {
                    // short curcuit
                    validABBA = false
                    break
                }

                validABBA = validABBA || innerValidABBA
            }

            return validABBA
        }

        var supportsSSL: Bool {
            var abas = [String]()
            var babs = [String]()

            for part in parts {
                let moreAbasOrBabs = getABASOrBABS(part: part)
                if part.hasPrefix("[") {
                    // These are clearly BABs
                    babs.append(contentsOf: moreAbasOrBabs)
                } else {
                    abas.append(contentsOf: moreAbasOrBabs)
                }
            }

            var valid = false
            for aba in abas {
                for bab in babs {
                    if aba == String(bab.characters.reversed()) {
                        valid = true
                        break
                    }
                }
            }

            return valid
        }

        init(address: String) {
            self.address = address
            self.parts = Day7.groupedIPAddr.search(input: address).filter { $0 != "" }
        }

        /// Make a list of chunks of `n` size from string `sequence`
        /// charChunks(sequence: "abcde", n: 3) -> ["abc", "bcd", "cde"]
        private func charChunks(sequence: String, n: Int) -> [String] {
            var startIndex = sequence.startIndex
            var endIndex = sequence.index(
                startIndex,
                offsetBy: n,
                limitedBy: sequence.endIndex
            )

            var chunks = [String]()

            while true {
                guard let existantEndIndex = endIndex else {
                    // We dont have another 4 characters to read
                    break
                }
                let chunk = sequence[startIndex..<existantEndIndex]
                assert(chunk.characters.count == n)
                chunks.append(chunk)

                startIndex = sequence.index(after: startIndex)
                endIndex = sequence.index(
                    existantEndIndex,
                    offsetBy: 1,
                    limitedBy: sequence.endIndex
                )
            }

            return chunks
        }

        private func isABBA(part: String) -> Bool {
            let stripped = part
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")

            var valid = false

            for chunk in charChunks(sequence: stripped, n: 4) {
                let middleIndex = chunk.index(chunk.startIndex, offsetBy: 2)
                let first = chunk.substring(to: middleIndex)
                let second = chunk.substring(from: middleIndex)

                // The two characters matched must be unique
                if Set(first.characters).count != 1 &&
                    first == String(second.characters.reversed()) {
                        valid = true
                        break
                }
            }

            return valid
        }

        private func getABASOrBABS(part: String) -> [String] {
            let stripped = part
                .replacingOccurrences(of: "[", with: "")
                .replacingOccurrences(of: "]", with: "")

            var abas = [String]()

            for chunk in charChunks(sequence: stripped, n: 3) {
                let first = chunk[chunk.startIndex]
                let middle = chunk[chunk.index(after: chunk.startIndex)]
                let last = chunk[chunk.index(before: chunk.endIndex)]

                if first == last && first != middle {
                    abas.append(String([first, middle]))
                }
            }
            
            return abas
        }

    }

    static func run(input: String) {
        let addresses = input.components(separatedBy: .newlines).map { IPAddress(address: $0) }

        print("Number of addresses supporting TLS: \(addresses.filter({ $0.supportsTLS }).count)")
        print("Number of addresses supporting SLL: \(addresses.filter({ $0.supportsSSL }).count)")
    }
}
