//
//  ImageGenerationViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 24/10/24.
//


import SwiftUI
import Combine

/// ViewModel for managing image generation based on user input.
class ImageGenerationViewModel: ObservableObject {
    @Published var userInput: String = ""
    @Published var userPrompt: String = ""
    @Published var generatedImage: UIImage? = nil
    @Published var isLoading: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    let capability: Capability
    
    
    init(capability: Capability) {
        self.capability = capability
    }
    
    // Generates an image based on the user input
    func generateImage() {
        guard !userInput.isEmpty else { return }
        
        isLoading = true
        userPrompt = userInput
        userInput = ""
        generatedImage = nil
        
    
        if AppConfig.shared.isDebugMode {
            // Simulate image generation with a demo image in debug mode
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.generatedImage = UIImage(named: Strings.demoImage)
                self?.isLoading = false
            }
        } else {
            // Make API call to generate image in production mode
            NetworkRequests.shared.sendImageGenerationRequest(prompt: userPrompt) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let image):
                        self?.generatedImage = image
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                        self?.showErrorAlert = true
                    }
                }
            }
        }
    }
    
}
