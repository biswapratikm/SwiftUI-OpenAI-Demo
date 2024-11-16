//
//  ImageAnalysisViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 24/10/24.
//


import Foundation
import UIKit

/// ViewModel for managing image analysis and retrieving analyzed text.
class ImageAnalysisViewModel: ObservableObject {
    let capability: Capability
    @Published var selectedImage: UIImage?
    @Published var analyzedText: String = ""
    @Published var showErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: Bool = false

    init(capability: Capability) {
        self.capability = capability
    }
    
    // Analyzes the selected image and fetches text result
    func analyzeImage() {
        guard let image = selectedImage else { return }
        analyzedText = ""
        isLoading = true
        NetworkRequests.shared.sendImageAnalysisRequest(image: image, prompt: capability.prefix) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let text):
                    self.analyzedText = text
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                }
            }
        }
    }
}
