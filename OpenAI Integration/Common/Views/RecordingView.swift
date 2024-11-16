//
//  RecordingView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 05/11/24.
//

import SwiftUI

struct RecordingView: View {
    @Binding var audioURL: URL?
    var isLoading: Bool 
    @ObservedObject var viewModel: RecordingViewModel // ViewModel for recording

    var body: some View {
        HStack {
            // Start/Stop recording button
            Button(action: viewModel.toggleRecording) {
                Text(viewModel.isRecording ? Strings.stop : Strings.start)
                    .frame(width: 70, height: 40)
            }
            Spacer()

            // Audio playback view
            if let audioURL = viewModel.audioURL {
                AudioPlaybackView(audioURL: audioURL)
            }
            Spacer()

            // Loading indicator or send button
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 70, height: 40)
            } else {
                Button(action: {
                    audioURL = viewModel.audioURL
                    viewModel.clearRecording()
                }) {
                    Text(Strings.send)
                        .frame(width: 70, height: 40)
                }
                .disabled(viewModel.isRecording || viewModel.audioURL == nil)
            }
        }
        .onAppear {
            // Request permission on view appear
            Task {
                await viewModel.requestPermission()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(AppColors.background)
        .alert(isPresented: $viewModel.showErrorAlert) {
            // Show error alert if needed
            Alert(
                title: Text(Strings.error),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text(Strings.ok))
            )
        }
    }
}


#Preview {
    @Previewable @State  var audioURL: URL? = URL(string: "https://example.com/audio.m4a")
      
    RecordingView(audioURL: $audioURL, isLoading: false, viewModel: RecordingViewModel())
  
}
