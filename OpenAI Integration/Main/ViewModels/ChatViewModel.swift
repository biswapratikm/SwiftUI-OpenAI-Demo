//
//  ChatViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 24/10/24.
//


import SwiftUI
import Combine

/// ViewModel for managing chat functionality and message interactions.
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var userInput: String = ""
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    
    let capability: Capability
    
    init(capability: Capability) {
        self.capability = capability
    }
    
    // Sends a user message and handles API response

    func sendMessage() {
        guard !userInput.isEmpty else { return }
        let userMessage = Message(role: .user, content: userInput)
        messages.append(userMessage)
        let conversationHistory = messages.map { message in
            ["role": message.role.rawValue, "content": message.content]
        }
        
        userInput = ""
        
        NetworkRequests.shared.sendTextRequest(messages: conversationHistory) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseText):
                    let assistantMessage = Message(role: .assistant, content: responseText)
                    self?.messages.append(assistantMessage)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            }
        }
    }
    
}
