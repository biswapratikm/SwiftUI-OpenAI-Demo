//
//  AudioRecorder.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 04/11/24.
//


import AVFoundation

/// AudioRecorder is responsible for handling the audio recording process.
/// It manages permissions, session configuration, starting and stopping of audio recordings,
/// and provides the resulting audio file URL.

class AudioRecorder {
    private var audioRecorder: AVAudioRecorder?
    var audioURL: URL?
    
    // Request permission to record audio
    func requestPermission(completion: @escaping (Bool) -> Void) {
         AVAudioApplication.requestRecordPermission() { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    // Configure audio session for recording
    private func configureAudioSessionForRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session for recording: \(error)")
        }
    }

    // Starts the audio recording and returns the URL of the recorded file.
    func startRecording(completion: @escaping (Result<URL, Error>) -> Void) {
        configureAudioSessionForRecording()
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString + ".wav"
        let fileURL = tempDir.appendingPathComponent(fileName)
        audioURL = fileURL

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,  // Standard sample rate for WAV
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16, // 16-bit depth is standard for WAV
            AVLinearPCMIsFloatKey: false,  // PCM format
            AVLinearPCMIsBigEndianKey: false
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            completion(.success(fileURL))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Stop recording audio
    func stopRecording() {
        audioRecorder?.stop()
    }

    // Clear resources after recording
    func clearRecording() {
        audioRecorder = nil
        audioURL = nil
    }
}

