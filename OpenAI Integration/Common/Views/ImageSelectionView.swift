//
//  ImageSelectionView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 07/11/24.
//

import SwiftUI

struct ImageSelectionView: View {
    @Binding var selectedImage: UIImage?
    var isLoading: Bool
    @ObservedObject var viewModel: ImageSelectionViewModel // ViewModel for Image Selection
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                if let image = viewModel.selectedImage {
                    // Display selected image
                    ImageView(image: image)
                        .frame(width: 52, height: 52)
                }
                Spacer()
            }
            HStack {
                // Open image picker
                Button(action: viewModel.toggleImagePicker) {
                    Text(Strings.selectImage)
                        .frame(width: 120, height: 40)
                }
                Spacer()
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(width: 70, height: 40)
                } else {
                    Button(action: {
                        selectedImage = viewModel.selectedImage 
                        viewModel.clearImage()
                    }) {
                        Text(Strings.send)
                            .frame(width: 70, height: 40)
                    }
                    .disabled(viewModel.selectedImage == nil)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(AppColors.background)
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(selectedImage: Binding(
                get: { viewModel.selectedImage },
                set: { newImage in
                    viewModel.setImage(newImage) // Update selected image
                }
            ))
        }
    }
}


#Preview {
    @Previewable @State var previewSelectedImage: UIImage? = UIImage(named: "demo_image")!
    let previewViewModel = ImageSelectionViewModel()
    ImageSelectionView(
        selectedImage: $previewSelectedImage,
        isLoading: false, viewModel: previewViewModel
    )
}
