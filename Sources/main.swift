import Foundation


let dayMapping: [String: (String) -> Void] = [
    "day1": Day1.run,
    "day2": Day2.run,
    "day3": Day3.run,
    "day4": Day4.run,
    "day5": Day5.run,
    "day6": Day6.run,
    "day7": Day7.run,
    "day8": Day8.run,
    "day9": Day9.run
]

func main() {
    if CommandLine.arguments.count < 2 {
        print("Usage .build/debug/aoc dayN.")
        exit(0)
    }

    let dayChosen = CommandLine.arguments[1]
    guard let entrypoint = dayMapping[dayChosen] else {
        print("Invalid day chosen. Possible days: \(dayMapping.keys.joined(separator: ", "))")
        exit(1)
    }

    let input: String
    do {
        input = try String(contentsOfFile: "input/\(dayChosen).txt", encoding: String.Encoding.utf8)
    } catch let error {
        print("Could not open file: \(error)")
        return
    }

    entrypoint(input)
}

main()
