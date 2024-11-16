//
//  AudioChatViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 12/11/24.
//


import SwiftUI
import Combine

/// ViewModel for managing audio responses, including generation and transcript handling.
class AudioResponseViewModel: ObservableObject {
    @Published var userPrompt: String = ""
    @Published var text: String = ""
    @Published var transcript: String = ""
    @Published var isLoading: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var audioURL: URL?
    
    let capability: Capability
    
    init(capability: Capability) {
        self.capability = capability
    }
    
    // Sends audio request to API and handles response
    func sendAudioChatAPI() {
        guard !text.isEmpty else { return }
        isLoading = true
        userPrompt = text
        text = ""
        transcript = ""
        audioURL = nil
        
        if AppConfig.shared.isDebugMode {
            // Simulate request with demo data in debug mode
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.isLoading = false
                self?.transcript = Strings.mockTranscript
                if let demoURL = Bundle.main.url(forResource: Strings.demoAudio, withExtension: Strings.wav) {
                    self?.audioURL = demoURL
                } else {
                    self?.errorMessage = Strings.demoAudioError
                    self?.showErrorAlert = true
                }
            }
        } else {
            // Perform actual network request in production mode
            NetworkRequests.shared.sendAudioGenerationRequest(message: userPrompt) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let response):
                        self?.audioURL = response.0
                        self?.transcript = response.1
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        self?.showErrorAlert = true
                    }
                }
            }
        }
    }
    
}

