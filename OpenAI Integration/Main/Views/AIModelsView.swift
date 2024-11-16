//
//  ContentView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/10/24.
//

import SwiftUI

struct AIModelsView: View {
    var body: some View {
        // Main navigation view
        NavigationView {
            // List of OpenAI models
            List(openAIModels, id: \.name) { model in
                // Navigation link to capabilities view for each model
                NavigationLink(destination: CapabilitiesView(model: model)) {
                    VStack(alignment: .leading) {
                        Text(model.name)
                            .font(.headline)
                        Text(model.description)
                            .font(.subheadline)
                            .foregroundColor(AppColors.gray)
                    }
                }
            }
            .padding(.top, -20)
            .navigationTitle(Strings.models)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AIModelsView()
}
