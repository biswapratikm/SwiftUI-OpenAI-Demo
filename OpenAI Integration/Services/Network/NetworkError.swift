//
//  NetworkError.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 29/10/24.
//


import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidParameters
    case invalidResponse
    case noData
    case jsonDecodingFailed
    case audioFileLoadFailed(Error)
    case imageConversionFailed
    case audioConversionFailed
    case fileSaveFailed
    case multipartBodyBuilderFailed
    case custom(String)
    case jsonSerializationFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The URL provided is invalid.",
                                     comment: "Invalid URL")
        case .invalidParameters:
            return NSLocalizedString("The parameters provided are invalid.",
                                     comment: "Invalid Parameters")
        case .invalidResponse:
            return NSLocalizedString("The response from the server was invalid.",
                                     comment: "Invalid Response")
        case .noData:
            return NSLocalizedString("No data was received from the server.",
                                     comment: "No Data")
        case .jsonDecodingFailed:
            return NSLocalizedString("Failed to decode the JSON response.",
                                     comment: "JSON Decoding Failed")
        case .audioFileLoadFailed(let error):
            return NSLocalizedString("Failed to load the audio file: \(error.localizedDescription)",
                                     comment: "Audio File Load Failed")
        case .imageConversionFailed:
            return NSLocalizedString("Image conversion failed.",
                                     comment: "Image Conversion Failed")
        case .fileSaveFailed:
            return NSLocalizedString("Failed to save the file to disk.",
                                     comment: "File Save Failed")
        case .custom(let message):
            return NSLocalizedString(message,
                                     comment: "Custom Error")
        case .audioConversionFailed:
            return NSLocalizedString("Audio conversion failed.",
                                     comment: "Audio Conversion Failed")
        case .multipartBodyBuilderFailed:
            return NSLocalizedString("Failed to create request body.",
                                     comment: "Failed to create request body.")
        case .jsonSerializationFailed:
            return NSLocalizedString("Failed to serialize the JSON request body.",
                                     comment: "JSON Serialization Failed")
            
        }
    }
}

