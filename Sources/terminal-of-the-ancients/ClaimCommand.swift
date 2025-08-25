import ArgumentParser

enum Prize: String, CaseIterable, ExpressibleByArgument {
    case powerbank = "powerbank"
    case techpouch = "techpouch"
}

struct ClaimCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "claim"
    )

    @Option(help: "Your reward: powerbank or techpouch")
    var prize: Prize

    func run() throws {
        print("✨ Your relic request has been received: \(prize)\n")
        print("🎯 Please send me the following:")
        print("1. A screenshot of your `@main` implementation")
        print("2. A screenshot of your terminal calls:")
        print("   tota claim --prize \(prize)")
        print("3. Your workshop slot number (1, 2 or 3)\n")
        print("📬 Send it to me in slack\n")
        print("Your reward will await you. Well done, Summoner.")
    }
}
