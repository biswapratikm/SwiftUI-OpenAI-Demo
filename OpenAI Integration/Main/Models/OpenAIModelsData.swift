//
//  OpenAIModelsData.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/10/24.
//

import Foundation

let gptModel = OpenAIModel(
    name: "GPT-4o-mini",
    description: "A powerful language model capable of generating human-like text.",
    capabilities: [
        Capability(
            name: "Text Generation",
            description: "Generate creative text based on user input.",
            prefix: "Generate the following text under 80 words: ",
            type: .singlePrompt,
            display: "Type in your prompt, and GPT-4o-mini will generate a short text response based on it."
        ),
        Capability(
            name: "Text Summarization",
            description: "Summarize long pieces of text into concise summaries.",
            prefix: "Please summarize the following text as short as possible: ",
            type: .singlePrompt,
            display: "Enter a longer text, and GPT-4o-mini will summarize it for you."
        ),
        Capability(
            name: "Text Translation",
            description: "Translate user-inputted text into different languages.",
            prefix: "Translate the following text to English: ",
            type: .singlePrompt,
            display: "Provide text in a foreign language, and GPT-4o-mini will translate it into English."
        ),
        Capability(
            name: "Sentiment Analysis",
            description: "Analyze the sentiment of a given text (positive, negative, neutral).",
            prefix: "Analyze the sentiment of the following text, give brief answer: ",
            type: .singlePrompt,
            display: "Enter a text, and GPT-4o-mini will identify the sentiment as positive, negative, or neutral."
        ),
        Capability(
            name: "Text Editing",
            description: "Improve grammar, clarity, and overall quality of user-inputted text.",
            prefix: "Edit the following text for grammar and clarity: ",
            type: .singlePrompt,
            display: "Input your text, and GPT-4o-mini will improve its grammar and clarity."
        ),
        Capability(
            name: "Question and Answer",
            description: "Provide answers to user-submitted questions based on context.",
            prefix: "Answer the following question as short as possible: ",
            type: .singlePrompt,
            display: "Ask a question, and GPT-4o-mini will answer it concisely."
        ),
        Capability(
            name: "Creative Writing",
            description: "Generate stories, poems, or other creative content based on prompts.",
            prefix: "Create a story or poem under 80 words: ",
            type: .singlePrompt,
            display: "Enter a theme or prompt, and GPT-4o-mini will create a short story or poem."
        ),
        Capability(
            name: "Chat Functionality",
            description: "Implement a chatbot experience for conversational interactions.",
            prefix: "",
            type: .chat,
            display: "Start a conversation, and GPT-4o-mini will respond in a conversational style."
        ),
        Capability(
            name: "Image Analysis",
            description: "Analyze and describe the content of a given image.",
            prefix: "Analyze the image and describe it in brief.",
            type: .imageAnalysis,
            display: "Upload an image, and GPT-4o-mini will analyze and describe its contents."
        )
    ]
)

let dalleModel = OpenAIModel(
    name: "DALL-E",
    description: "An image generation model that creates images from text descriptions.",
    capabilities: [
        Capability(
            name: "Image Generation",
            description: "Create images from text descriptions.",
            prefix: "",
            type: .imageGeneration,
            display: "Enter a description, and DALL-E will generate an image based on it."
        ),
        Capability(
            name: "Image Variations",
            description: "Generate variations of an existing image (creative reinterpretation).",
            prefix: "",
            type: .imageVariation,
            display: "Upload an image, and DALL-E will create unique variations based on it."
        )
    ]
)


let whisperModel = OpenAIModel(
    name: "Whisper",
    description: "A speech recognition model for converting spoken audio into text.",
    capabilities: [
        Capability(
            name: "Speech Transcription",
            description: "Convert spoken audio into text.",
            prefix: "",
            type: .speechToText,
            display: "Record audio, and Whisper will transcribe it into text."
        ),
        Capability(
            name: "Speech Translation",
            description: "Translate spoken audio into English.",
            prefix: "",
            type: .speechToText,
            display: "Record audio in another language, and Whisper will translate it to English."
        )
    ]
)


let ttsModel = OpenAIModel(
    name: "TTS-1",
    description: "A text-to-speech model that converts text into spoken audio.",
    capabilities: [
        Capability(name: "Text-to-Speech",
                   description: "Convert text into speech output.",
                   prefix: "",
                   type: .textToSpeech,
                   display: "Enter text, and TTS-1 will convert it into spoken audio that you can play."
                  )
    ]
)

let gptAudioPreviewModel = OpenAIModel(
    name: "GPT-4o-Audio-Preview",
    description: "An advanced model for audio analysis, synthesis, and interactions.",
    capabilities: [
        Capability(
            name: "Audio Response",
            description: "Generate audio response based on text.",
            prefix: "Generate a spoken audio in under 20 words:  ",
            type: .audioGeneration,
            display: "Type in your prompt, and GPT-4o-Audio-Preview will generate a audio response based on it."
        ),
        Capability(
            name: "Sentiment Analysis on Speech",
            description: "Analyze sentiment in a recorded audio.",
            prefix: "Analyze the sentiment of this recording.",
            type: .speechSentiment,
            display: "Record your speech, and GPT-4o-Audio-Preview will determine its sentiment."
        ),
    ]
)

/// Collection of OpenAI models and their capabilities.
let openAIModels = [gptModel, dalleModel, whisperModel, ttsModel, gptAudioPreviewModel]

/// Predefined identifiers for OpenAI models.
struct AIModels {
    static let gpt = "gpt-4o-mini"         // Identifier for GPT model
    static let tts = "tts-1"               // Identifier for TTS model
    static let dalle = "dall-e-2"          // Identifier for DALL-E model
    static let whisper = "whisper-1"       // Identifier for Whisper model
    static let gptAudioPreview = "gpt-4o-audio-preview" // Identifier for GPT Audio Preview model
}

/// Defines the role of a participant in a chat.
enum ChatRole: String {
    case system = "system"                // System-generated messages
    case user = "user"                    // User input messages
    case assistant = "assistant"          // Assistant responses
    case function = "function"            // Function-based system interactions
}



