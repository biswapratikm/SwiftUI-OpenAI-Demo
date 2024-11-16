//
//  SpeechSentimentViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 13/11/24.
//


import SwiftUI
import Combine

/// ViewModel for managing speech sentiment analysis functionality.
class SpeechSentimentViewModel: ObservableObject {

    @Published var errorMessage: String = ""
    @Published var result: String = ""
    @Published var isLoading = false
    @Published var showErrorAlert = false
    @Published var sentURL: URL?
    @Published var recordedURL: URL?

    let capability: Capability

    init(capability: Capability) {
        self.capability = capability
    }
    
    // Send the recorded audio file for sentiment analysis
    func sendRecordingForSentimentAnalysis() {
        guard let recordingURL = recordedURL else {
            errorMessage = Strings.noRecording
            showErrorAlert = true
            return
        }
        
        sentURL = recordingURL
        recordedURL = nil
        result = ""
        isLoading = true
        
        NetworkRequests.shared.sendSpeechSentimentRequest(audioURL: recordingURL, prompt: capability.prefix) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let sentiment):
                    self?.result = sentiment
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            }
        }
    }

}
