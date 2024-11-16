//
//  SettingsModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/10/24.
//

import Foundation

/// A singleton model for managing configurable settings in the app.
/// These settings are tied to API parameters and influence the behavior of OpenAI models.

class SettingsModel: ObservableObject {
    
    static let shared = SettingsModel()
    
    @Published var temperature = Setting(
        name: "Temperature",
        apiParameter: "temperature",
        description: "Controls output randomness; higher values increase creativity, while lower values make results more deterministic.",
        minValue: 0.0,
        maxValue: 1.0,
        value: 0.7
    )

    @Published var topP = Setting(
        name: "Top P",
        apiParameter: "top_p",
        description: "Selects probable tokens; higher values offer diverse outputs, while lower values lead to predictable responses.",
        minValue: 0.0,
        maxValue: 1.0,
        value: 0.9
    )

    @Published var maxTokens = Setting(
        name: "Max Tokens",
        apiParameter: "max_tokens",
        description: "Limits the length of the response.",
        minValue: 1.0,
        maxValue: 500,
        value: 100
    )

    @Published var presencePenalty = Setting(
        name: "Presence Penalty",
        apiParameter: "presence_penalty",
        description: "Affects new topic introduction; higher values promote diversity, while lower values allow repetition.",
        minValue: -2.0,
        maxValue: 2.0,
        value: 0.0
    )

    @Published var frequencyPenalty = Setting(
        name: "Frequency Penalty",
        apiParameter: "frequency_penalty",
        description: "Discourages token repetition; higher values reduce repetitions, while lower values allow them.",
        minValue: -2.0,
        maxValue: 2.0,
        value: 0.0
    )

}
