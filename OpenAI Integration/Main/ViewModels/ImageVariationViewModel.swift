//
//  ImageManipulationViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 24/10/24.
//


import SwiftUI

/// ViewModel for managing image variation generation.
class ImageVariationViewModel: ObservableObject {
    let capability: Capability
    @Published var selectedImage: UIImage?
    @Published var generatedImage: UIImage?
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false
    
    init(capability: Capability) {
        self.capability = capability
    }
    
    func clearGeneratedImage() {
        generatedImage = nil
    }
    
    // Generates image variations from the selected image
    func generateImage() {
        guard let image = selectedImage else { return }
        self.generatedImage = nil
        isLoading = true
        
        if AppConfig.shared.isDebugMode {
            // Simulate demo image generation in debug mode
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.generatedImage = UIImage(named: Strings.demoImage)
                self?.isLoading = false
            }
        } else {
            // Request image variation from OpenAI
            NetworkRequests.shared.sendImageVariationRequest(image: image) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let image):
                        self.generatedImage = image
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                        self.showErrorAlert = true
                    }
                }
            }
        }
    }
}

