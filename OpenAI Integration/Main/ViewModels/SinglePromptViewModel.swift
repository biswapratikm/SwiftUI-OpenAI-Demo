//
//  ActionViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 24/10/24.
//


import SwiftUI
import Combine

/// ViewModel for managing a single prompt and response.
class SinglePromptViewModel: ObservableObject {
    @Published var userPrompt: String = ""
    @Published var result: String = ""
    @Published var userInput: String = ""
    @Published var isLoading: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    let capability: Capability
    
    init(capability: Capability) {
        self.capability = capability
    }
    
    // Sends the user input to the API
    func sendRequest() {
        guard !userInput.isEmpty else { return }
        result = ""
        isLoading = true
        userPrompt = userInput
        let message = ["role": ChatRole.user.rawValue, "content": capability.prefix + userInput]
        let conversationHistory = [message]
        userInput = ""
        
        NetworkRequests.shared.sendTextRequest(messages: conversationHistory) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let responseText):
                    self?.result = responseText
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            }
        }
    }
    
}
