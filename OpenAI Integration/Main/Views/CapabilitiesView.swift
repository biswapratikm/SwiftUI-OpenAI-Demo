//
//  CapabilitiesView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/10/24.
//

import SwiftUI

struct CapabilitiesView: View {
    
    // The OpenAI model that holds capabilities
    let model: OpenAIModel
    
    var body: some View {
        List(model.capabilities, id: \.name) { capability in
            
            // Navigate to the corresponding view based on capability type
            NavigationLink(destination: {
                switch capability.type {
                case .chat:
                    ChatView(capability: capability)
                case .singlePrompt:
                    SinglePromptView(capability: capability)
                case .imageGeneration:
                    ImageGenerationView(capability: capability)
                case .imageVariation:
                    ImageVariationView(capability: capability)
                case .speechToText:
                    SpeechToTextView(capability: capability)
                case .textToSpeech:
                    TextToSpeechView(capability: capability)
                case .imageAnalysis:
                    ImageAnalysisView(capability: capability)
                case .audioGeneration:
                    AudioResponseView(capability: capability)
                case .speechSentiment:
                    SpeechSentimentView(capability: capability)
                }
            }) {
                VStack(alignment: .leading) {
                    // Display capability name and description
                    Text(capability.name)
                        .font(.headline)
                    Text(capability.description)
                        .font(.subheadline)
                        .foregroundColor(AppColors.gray)
                }
            }
        }
        .padding(.top, -20)
        .navigationTitle(model.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    if let firstModel = openAIModels.first {
        CapabilitiesView(model: firstModel)
    }
}
