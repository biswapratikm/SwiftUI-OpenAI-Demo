import Combine
import SwiftUI

/// ViewModel for managing speech-to-text functionality.
class SpeechToTextViewModel: ObservableObject {

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
    
    // Determines if the capability is for transcription or translation
    var isTranscription: Bool {
        capability.name == whisperModel.capabilities[0].name
    }

    // Sends the recorded audio file to the API for transcription or translation
    func sendRecording() {
        guard let recordingURL = recordedURL else {
            errorMessage = Strings.noRecording
            showErrorAlert = true
            return
        }
        sentURL = recordingURL
        recordedURL = nil
        result = ""
        isLoading = true
        NetworkRequests.shared.sendWhisperRequest(audioFileURL: recordingURL, isTranscription: isTranscription) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let text):
                    self?.result = text
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.showErrorAlert = true
                }
            }
        }
    }

}
