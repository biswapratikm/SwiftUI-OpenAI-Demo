//
//  RequestBodyBuilder.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 14/11/24.
//

import Foundation
import UIKit

struct RequestBodyBuilder {
    
    // Builds the request body for a chat request
    static func buildChatRequestBody(messages: [[String: Any]], maxTokens: Int, temperature: Double) -> [String: Any] {
        return [
            "model": AIModels.gpt,
            "messages": messages,
            "max_tokens": maxTokens,
            "temperature": temperature
        ]
    }
    
    // Builds the request body for a Text-to-Speech request
    static func buildTextToSpeechRequestBody(inputText: String) -> [String: Any] {
        return [
            "model": AIModels.tts,
            "input": inputText,
            "voice": "alloy"
        ]
    }
    
    // Builds the request body for an image generation request
    static func buildImageGenerationRequestBody(prompt: String) -> [String: Any] {
        return [
            "model": AIModels.dalle,
            "prompt": prompt,
            "n": 1,
            "size": "1024x1024"
        ]
    }
    
    // Builds the request body for an image analysis request
    static func buildImageAnalysisRequestBody(imageData: Data, prompt: String) -> [String: Any] {
        let base64Image = imageData.base64EncodedString()
        return [
            "model": AIModels.gpt,
            "messages": [
                [
                    "role": ChatRole.user.rawValue,
                    "content": [
                        [
                            "type": "text",
                            "text": prompt
                        ],
                        [
                            "type": "image_url",
                            "image_url": [
                                "url": "data:image/jpeg;base64,\(base64Image)",
                                "detail": "low"
                            ]
                        ]
                    ]
                ]
            ],
            "max_tokens": 300
        ]
    }
    
    // Builds the request body for an audio generation request
    static func buildAudioGenerationRequestBody(message: String) -> [String: Any] {
        return [
            "model": AIModels.gptAudioPreview,
            "modalities": [
                "text",
                "audio"
            ],
            "audio": [
                "voice": "alloy",
                "format": "wav"
            ],
            "messages": [
                [
                    "role": ChatRole.user.rawValue,
                    "content": message
                ]
            ]
        ]
    }
    
    // Builds the request body for a speech sentiment analysis request
    static func buildSpeechSentimentRequestBody(audioData: Data, prompt: String) -> [String: Any] {
        let base64Audio = audioData.base64EncodedString()
        return [
            "model": AIModels.gptAudioPreview,
            "modalities": [
                "text"
            ],
            "messages": [
                [
                    "role": ChatRole.user.rawValue,
                    "content": [
                        [
                            "type": "text",
                            "text": prompt
                        ],
                        [
                            "type": "input_audio",
                            "input_audio": [
                                "data": base64Audio,
                                "format": "wav"
                            ]
                        ]
                    ]
                ]
            ]
        ]
    }
}
