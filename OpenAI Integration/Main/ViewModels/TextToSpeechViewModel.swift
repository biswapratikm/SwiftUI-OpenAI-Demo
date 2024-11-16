//
//  TextToSpeechViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 24/10/24.
//

import AVFoundation
import SwiftUI
import Combine

/// ViewModel for managing text-to-speech functionality.
class TextToSpeechViewModel: ObservableObject {
    @Published var userPrompt: String = ""
    @Published var text: String = ""
    @Published var isLoading: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var audioURL: URL?
    
    let capability: Capability

    init(capability: Capability) {
        self.capability = capability
    }

    // Sends text to the API for speech synthesis
    func sendTextToSpeechAPI() {
        guard !text.isEmpty else { return }
        isLoading = true
        userPrompt = text
        text = ""
        audioURL = nil
        NetworkRequests.shared.sendTextToSpeechRequest(inputText: userPrompt) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let audioURL):
                    self?.audioURL = audioURL
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            }
        }
    }
    
}
