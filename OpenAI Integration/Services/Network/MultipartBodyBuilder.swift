//
//  MultipartBodyBuilder.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 29/10/24.
//

import Foundation
import UIKit

struct MultipartBodyBuilder {
    
    // Creates a multipart body for audio file upload
    static func createAudioBody(audioFileURL: URL, boundary: String, model: String) -> Data? {
        var body = Data()
        
        do {
            // Load audio data from file URL
            let audioData = try Data(contentsOf: audioFileURL)
            
            // Append audio file data with necessary headers
            body.append(convertToData("--\(boundary)\r\n"))
            body.append(convertToData("Content-Disposition: form-data; name=\"file\"; filename=\"\(audioFileURL.lastPathComponent)\"\r\n"))
            body.append(convertToData("Content-Type: audio/m4a\r\n\r\n"))
            body.append(audioData)
            body.append(convertToData("\r\n"))
            
        } catch {
            print("Failed to load audio file: \(error)")
            return nil
        }
        
        // Append model information
        body.append(convertToData("--\(boundary)\r\n"))
        body.append(convertToData("Content-Disposition: form-data; name=\"model\"\r\n\r\n"))
        body.append(convertToData("\(model)\r\n"))
        body.append(convertToData("--\(boundary)--\r\n"))
        
        return body
    }

    // Creates a multipart body for image upload
    static func createImageBody(image: UIImage, boundary: String, model: String) -> Data? {
        var body = Data()
        
        // Append model information
        body.append(convertToData("--\(boundary)\r\n"))
        body.append(convertToData("Content-Disposition: form-data; name=\"model\"\r\n\r\n"))
        body.append(convertToData("\(model)\r\n"))
        
        // Append image data with necessary headers
        body.append(convertToData("--\(boundary)\r\n"))
        body.append(convertToData("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n"))
        body.append(convertToData("Content-Type: image/png\r\n\r\n"))
        
        if let imageData = image.pngData() {
            body.append(imageData)
        } else {
            return nil
        }

        body.append(convertToData("\r\n"))
        
        // Append additional image parameters
        body.append(convertToData("--\(boundary)\r\n"))
        body.append(convertToData("Content-Disposition: form-data; name=\"n\"\r\n\r\n"))
        body.append(convertToData("1\r\n"))
        body.append(convertToData("--\(boundary)\r\n"))
        body.append(convertToData("Content-Disposition: form-data; name=\"size\"\r\n\r\n"))
        body.append(convertToData("1024x1024\r\n"))
        body.append(convertToData("--\(boundary)--\r\n"))
        
        return body
    }
    
    // Converts a string to UTF-8 encoded Data
    private static func convertToData(_ string: String) -> Data {
        return string.data(using: .utf8) ?? Data()
    }
    
}


