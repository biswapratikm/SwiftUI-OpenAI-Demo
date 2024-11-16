//
//  APIEndpoints.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 29/10/24.
//

import Foundation

struct APIEndpoints {
    private static let baseURL = "https://api.openai.com/v1"
    
    static let chatCompletions = "\(baseURL)/chat/completions"
    static let audioTranscriptions = "\(baseURL)/audio/transcriptions"
    static let audioTranslations = "\(baseURL)/audio/translations"
    static let audioSpeech = "\(baseURL)/audio/speech"
    static let imageGenerations = "\(baseURL)/images/generations"
    static let imageVariations = "\(baseURL)/images/variations"
}
