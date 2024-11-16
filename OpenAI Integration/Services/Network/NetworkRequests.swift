//
//  NetworkRequests.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 31/10/24.
//

import Foundation
import UIKit

class NetworkRequests {
    
    static let shared = NetworkRequests() // Singleton instance

    private init() {}

    // Sends a text request to GPT for completion
    func sendTextRequest(
        messages: [[String: Any]],
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let url = URL(string: APIEndpoints.chatCompletions) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // Build parameters for the request body
        let parameters = RequestBodyBuilder.buildChatRequestBody(
            messages: messages,
            maxTokens: Int(SettingsModel.shared.maxTokens.value),
            temperature: SettingsModel.shared.temperature.value
        )
        
        // Serialize parameters to JSON
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(.failure(NetworkError.jsonSerializationFailed))
            return
        }

        // Perform the network request
        let headers = NetworkManager.shared.createHeaders(contentType: "application/json")
        NetworkManager.shared.performRequest(
            to: url,
            headers: headers,
            body: body,
            parse: NetworkResponseHandler.parseGPTResponse,
            completion: completion
        )
    }

    // Sends a Whisper request for transcription or translation
    func sendWhisperRequest(
        audioFileURL: URL,
        isTranscription: Bool,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let url = isTranscription
            ? URL(string: APIEndpoints.audioTranscriptions)
            : URL(string: APIEndpoints.audioTranslations) else {
                completion(.failure(NetworkError.invalidURL))
                return
        }

        let boundary = "Boundary-\(UUID().uuidString)"

        // Build multipart body for the audio file
        guard let body = MultipartBodyBuilder.createAudioBody(
            audioFileURL: audioFileURL,
            boundary: boundary,
            model: AIModels.whisper
        ) else {
            completion(.failure(NetworkError.multipartBodyBuilderFailed))
            return
        }

        // Perform the network request
        let headers = NetworkManager.shared.createHeaders(contentType: "multipart/form-data; boundary=\(boundary)")
        NetworkManager.shared.performRequest(
            to: url,
            headers: headers,
            body: body,
            parse: NetworkResponseHandler.parseWhisperResponse,
            completion: completion
        )
    }

    // Sends a request to generate speech from text
    func sendTextToSpeechRequest(
        inputText: String,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        guard let url = URL(string: APIEndpoints.audioSpeech) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        // Build parameters for the request body
        let parameters = RequestBodyBuilder.buildTextToSpeechRequestBody(
            inputText: inputText
        )
        
        // Serialize parameters to JSON
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(.failure(NetworkError.jsonSerializationFailed))
            return
        }

        // Perform the network request
        let headers = NetworkManager.shared.createHeaders(contentType: "application/json")
        NetworkManager.shared.performRequest(
            to: url,
            headers: headers,
            body: body,
            parse: NetworkResponseHandler.parseTtsResponse,
            completion: completion
        )
    }

    // Sends a request to generate an image from a prompt
    func sendImageGenerationRequest(
        prompt: String,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        guard let url = URL(string: APIEndpoints.imageGenerations) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        // Build parameters for the request body
        let parameters = RequestBodyBuilder.buildImageGenerationRequestBody(
            prompt: prompt
        )
        
        // Serialize parameters to JSON
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(.failure(NetworkError.jsonSerializationFailed))
            return
        }

        // Perform the network request
        let headers = NetworkManager.shared.createHeaders(contentType: "application/json")
        NetworkManager.shared.performRequest(
            to: url,
            headers: headers,
            body: body,
            parse: NetworkResponseHandler.parseDalleResponse,
            completion: completion
        )
    }

    // Sends a request for image variations
    func sendImageVariationRequest(
        image: UIImage,
        completion: @escaping (Result<UIImage, Error>) -> Void
    ) {
        guard let url = URL(string: APIEndpoints.imageVariations) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let boundary = "Boundary-\(UUID().uuidString)"

        // Build multipart body for the image
        guard let body = MultipartBodyBuilder.createImageBody(
            image: image,
            boundary: boundary,
            model: AIModels.dalle
        ) else {
            completion(.failure(NetworkError.multipartBodyBuilderFailed))
            return
        }

        // Perform the network request
        let headers = NetworkManager.shared.createHeaders(contentType: "multipart/form-data; boundary=\(boundary)")
        NetworkManager.shared.performRequest(
            to: url,
            headers: headers,
            body: body,
            parse: NetworkResponseHandler.parseDalleResponse,
            completion: completion
        )
    }

    // Sends a request for analyzing an image with a prompt
    func sendImageAnalysisRequest(
        image: UIImage,
        prompt: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let url = URL(string: APIEndpoints.chatCompletions) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        // Convert image to data
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            completion(.failure(NetworkError.imageConversionFailed))
            return
        }

        // Build parameters for the request body
        let parameters = RequestBodyBuilder.buildImageAnalysisRequestBody(
            imageData: imageData,
            prompt: prompt
        )
        
        // Serialize parameters to JSON
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(.failure(NetworkError.jsonSerializationFailed))
            return
        }

        // Perform the network request
        let headers = NetworkManager.shared.createHeaders(contentType: "application/json")
        NetworkManager.shared.performRequest(
            to: url,
            headers: headers,
            body: body,
            parse: NetworkResponseHandler.parseGPTResponse,
            completion: completion
        )
    }

    // Sends a request to generate audio from a text message
    func sendAudioGenerationRequest(
        message: String,
        completion: @escaping (Result<(URL, String), Error>) -> Void
    ) {
        guard let url = URL(string: APIEndpoints.chatCompletions) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        // Build parameters for the request body
        let parameters = RequestBodyBuilder.buildAudioGenerationRequestBody(
            message: message
        )
                
        // Serialize parameters to JSON
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(.failure(NetworkError.jsonSerializationFailed))
            return
        }

        // Perform the network request
        let headers = NetworkManager.shared.createHeaders(contentType: "application/json")
        NetworkManager.shared.performRequest(
            to: url,
            headers: headers,
            body: body,
            parse: NetworkResponseHandler.parseAudioGenerationResponse,
            completion: completion
        )
    }

    // Sends a sentiment analysis request for an audio file
    func sendSpeechSentimentRequest(
        audioURL: URL,
        prompt: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let url = URL(string: APIEndpoints.chatCompletions) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        // Convert audio file to data
        guard let audioData = try? Data(contentsOf: audioURL) else {
            completion(.failure(NetworkError.audioConversionFailed))
            return
        }

        // Build parameters for the request body
        let parameters = RequestBodyBuilder.buildSpeechSentimentRequestBody(
            audioData: audioData,
            prompt: prompt
        )
        
        // Serialize parameters to JSON
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(.failure(NetworkError.jsonSerializationFailed))
            return
        }

        // Perform the network request
        let headers = NetworkManager.shared.createHeaders(contentType: "application/json")
        NetworkManager.shared.performRequest(
            to: url,
            headers: headers,
            body: body,
            parse: NetworkResponseHandler.parseSpeechSentimentResponse,
            completion: completion
        )
    }
}

