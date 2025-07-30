#!/usr/bin/env swift
import Foundation

print("🧪 Testing Water Level Visualization")
print("This test simulates the visualization from the 'Voice of the Lighthouse' puzzle")
print("It should show a single, clean plot that updates in place...")
print()

// Simulate the visualization logic from BeaconPuzzleTask
var waterLevelHistory: [Double] = []
var lastVisualizationLines = 0

func displayWaterLevel(_ level: Double) {
    // Add to history
    waterLevelHistory.append(level)

    // Keep only last 10 readings for visualization
    if waterLevelHistory.count > 10 {
        waterLevelHistory.removeFirst()
    }

    let formattedLevel = String(format: "%.2f", level)

    // Create time-series visualization
    var visualization = "🌊 Water Level: \(formattedLevel) m (Time Series)\n"
    visualization += "┌─────────────────────────────────────────────────────────┐\n"

    // Y-axis with meter markers (top to bottom) - adjusted range
    let meters = Array(stride(from: 4.5, through: 1.5, by: 0.5)).reversed()

    for meter in meters {
        let meterLabel = String(format: "%.1f", meter)
        var line = "│ \(meterLabel)m │ "

        for (index, histLevel) in waterLevelHistory.enumerated() {
            let isCurrentLevel = abs(histLevel - meter) < 0.25
            let isBelowLevel = histLevel > meter

            if isCurrentLevel {
                line += "🌊"
            } else if isBelowLevel {
                line += "█"
            } else {
                line += " "
            }

            if index < waterLevelHistory.count - 1 {
                line += "  "  // Consistent spacing
            }
        }

        line += " │"
        visualization += line + "\n"
    }

    visualization += "└─────────────────────────────────────────────────────────┘\n"

    // X-axis time labels
    var timeLabels = "     "
    for (index, _) in waterLevelHistory.enumerated() {
        let secondsAgo = waterLevelHistory.count - 1 - index
        if secondsAgo == 0 {
            timeLabels += "now"
        } else if secondsAgo < 60 {
            timeLabels += "\(secondsAgo)s"
        } else {
            let minutes = secondsAgo / 60
            let remainingSeconds = secondsAgo % 60
            timeLabels += "\(minutes)m\(remainingSeconds)s"
        }

        if index < waterLevelHistory.count - 1 {
            timeLabels += "  "  // Consistent spacing
        }
    }
    visualization += timeLabels + "\n"

    // Clear previous visualization if not first time
    if lastVisualizationLines > 0 {
        // Move cursor up and clear lines
        for _ in 0..<lastVisualizationLines {
            print("\u{001B}[1A\u{001B}[K", terminator: "")
        }
    }

    // Print new visualization
    print(visualization, terminator: "")

    // Count lines for next clear operation
    lastVisualizationLines = visualization.components(separatedBy: "\n").count - 1
}

// Simulate rising water levels
print("Starting simulation...")
print("You should see a single plot that updates in place:")
print()

var waterLevel: Double = 1.5  // Start at the bottom of the chart
for _ in 0..<10 {
    displayWaterLevel(waterLevel)
    waterLevel += 0.25 + Double.random(in: 0...0.05)  // Gradual rise
    Thread.sleep(forTimeInterval: 0.5)
}

print("\n✅ Test completed!")
print(
    "If you saw a single plot updating in place without extra lines, the visualization is working correctly!"
)
