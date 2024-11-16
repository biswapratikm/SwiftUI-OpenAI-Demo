//
//  NetworkResponseHandler.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 29/10/24.
//

import Foundation
import UIKit

struct NetworkResponseHandler {
    
    // Parses the response for Text-to-Speech and saves the audio file
    static func parseTtsResponse(data: Data, completion: @escaping (Result<URL, Error>) -> Void) {
        if let fileURL = saveAudioFile(data: data) {
            completion(.success(fileURL))
        } else {
            completion(.failure(NetworkError.fileSaveFailed))
        }
    }
    
    // Saves the audio file to a temporary directory
    private static func saveAudioFile(data: Data, fileExtension: String = Strings.m4a) -> URL? {
        let fileManager = FileManager.default
        let tempDirectory = fileManager.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent(Strings.savedAudioFileName + fileExtension)

        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print(Strings.audioSaveFailed + error.localizedDescription)
            return nil
        }
    }
    
    // Parses the Whisper transcription response
    static func parseWhisperResponse(data: Data, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let transcription = jsonResponse["text"] as? String {
                completion(.success(transcription))
            } else {
                completion(.failure(NetworkError.jsonDecodingFailed))
            }
        } catch {
            completion(.failure(NetworkError.jsonDecodingFailed))
        }
    }
    
    // Parses the GPT response and extracts the text message
    static func parseGPTResponse(data: Data, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = jsonResponse["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let text = message["content"] as? String {
                completion(.success(text))
            } else {
                completion(.failure(NetworkError.jsonDecodingFailed))
            }
        } catch {
            completion(.failure(NetworkError.jsonDecodingFailed))
        }
    }
    
    // Parses the DALL-E response and returns the generated image
    static func parseDalleResponse(data: Data, completion: @escaping (Result<UIImage, Error>) -> Void) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let dataArray = json["data"] as? [[String: Any]],
               let imageUrlString = dataArray.first?["url"] as? String,
               let imageUrl = URL(string: imageUrlString),
               let imageData = try? Data(contentsOf: imageUrl),
               let generatedImage = UIImage(data: imageData) {
                completion(.success(generatedImage))
            } else {
                completion(.failure(NetworkError.invalidResponse))
            }
        } catch {
            completion(.failure(NetworkError.jsonDecodingFailed))
        }
    }
    
    // Parses the Audio Generation response and saves the audio file
    static func parseAudioGenerationResponse(data: Data, completion: @escaping (Result<(URL, String), Error>) -> Void) {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = jsonResponse["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let audio = message["audio"] as? [String: Any],
               let audioDataString = audio["data"] as? String,
               let transcript = audio["transcript"] as? String,
               let audioData = Data(base64Encoded: audioDataString) {
                
                let audioURL = saveAudioFile(data: audioData, fileExtension: Strings.wav)
                if let audioURL = audioURL {
                    completion(.success((audioURL, transcript)))
                } else {
                    completion(.failure(NetworkError.fileSaveFailed))
                }
            } else {
                completion(.failure(NetworkError.jsonDecodingFailed))
            }
        } catch {
            completion(.failure(NetworkError.jsonDecodingFailed))
        }
    }

    // Parses the Speech Sentiment response
    static func parseSpeechSentimentResponse(data: Data, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = jsonResponse["choices"] as? [[String: Any]],
               let choice = choices.first,
               let message = choice["message"] as? [String: Any],
               let content = message["content"] as? String {
                completion(.success(content))
            } else {
                completion(.failure(NetworkError.jsonDecodingFailed))
            }
        } catch {
            completion(.failure(NetworkError.jsonDecodingFailed))
        }
    }
}

