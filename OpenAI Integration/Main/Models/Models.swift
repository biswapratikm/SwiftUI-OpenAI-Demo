//
//  Setting.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/10/24.
//

import Foundation

/// Represents a configurable setting with a range of values.
struct Setting {
    let name: String                // Setting name
    let apiParameter: String        // Associated API parameter name
    let description: String         // Description of the setting
    let minValue: Double            // Minimum allowed value
    let maxValue: Double            // Maximum allowed value
    var value: Double               // Current value
}

/// Types of interfaces supported by the app.
enum InterfaceType {
    case imageGeneration            // Image generation interface
    case imageVariation             // Image variation interface
    case imageAnalysis              // Image analysis interface
    case singlePrompt               // Single prompt interface
    case speechToText               // Speech-to-text interface
    case speechSentiment            // Speech sentiment analysis
    case textToSpeech               // Text-to-speech interface
    case audioGeneration            // Audio generation interface
    case chat                       // Chat interface
}

/// Represents a capability of a model.
struct Capability {
    let name: String                // Capability name
    let description: String         // Description of the capability
    let prefix: String              // Prefix to append to content
    let type: InterfaceType         // Associated interface type
    let display: String             // Display text for UI
}

/// Represents an OpenAI model and its associated capabilities.
struct OpenAIModel {
    let name: String                // Model name
    let description: String         // Description of the model
    let capabilities: [Capability]  // List of supported capabilities
}

/// Represents a message in a conversation.
struct Message: Identifiable, Equatable {
    let id = UUID()                 // Unique identifier for the message
    let role: ChatRole              // Role (e.g., user or assistant)
    let content: String             // Message content
}

