//
//  RecordingViewModel.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 05/11/24.
//

import SwiftUI

/// ViewModel for managing audio recording.
class RecordingViewModel: ObservableObject {
    @Published var isRecording = false
    @Published var audioURL: URL?
    @Published var errorMessage: String = ""
    @Published var showErrorAlert = false
    
    private let audioRecorder = AudioRecorder()  // Audio recorder instance
    
    // Requests permission to record audio.
    func requestPermission() async {
        audioRecorder.requestPermission { [weak self] granted in
            if !granted {
                self?.errorMessage = Strings.microphoneDenied
                self?.showErrorAlert = true
            }
        }
    }
    
    // Toggles recording state.
    func toggleRecording() {
        isRecording ? stopRecording() : startRecording()
    }
    
    // Starts recording audio.
    private func startRecording() {
        audioRecorder.startRecording { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success: self?.isRecording = true
                case .failure(let error):
                    self?.errorMessage = Strings.recordingFailed + error.localizedDescription
                    self?.showErrorAlert = true
                }
            }
        }
    }
    
    // Stops recording audio.
    private func stopRecording() {
        audioRecorder.stopRecording()
        audioURL = audioRecorder.audioURL
        isRecording = false
    }
    
    // Clears the current recording.
    func clearRecording() {
        audioURL = nil
        isRecording = false
    }
}

