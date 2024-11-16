//
//  ImageSelectionViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 07/11/24.
//


import SwiftUI

/// ViewModel for managing image selection.
class ImageSelectionViewModel: ObservableObject {
    
    @Published var selectedImage: UIImage? = nil
    @Published var showingImagePicker: Bool = false
    
    // Toggles the image picker visibility.
    func toggleImagePicker() {
        showingImagePicker.toggle()
    }
    
    // Sets the selected image.
    func setImage(_ image: UIImage?) {
        selectedImage = image
    }
    
    // Clears the selected image.
    func clearImage() {
        selectedImage = nil
    }
}

