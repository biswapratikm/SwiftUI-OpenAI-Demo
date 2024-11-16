//
//  SettingsView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/10/24.
//

import SwiftUI

struct SettingsView: View {
    
    // Shared settings model observed for changes
    @ObservedObject var settingsModel = SettingsModel.shared
    
    var body: some View {

        NavigationView {
            
            // List displaying various settings
            List {
                // max tokens setting
                SettingRowWithText(setting: $settingsModel.maxTokens)
                
                // temperature slider
                SettingRowWithSlider(setting: $settingsModel.temperature)
                
                // top P slider
                SettingRowWithSlider(setting: $settingsModel.topP)
                
                // presence penalty slider
                SettingRowWithSlider(setting: $settingsModel.presencePenalty)
                
                // frequency penalty slider
                SettingRowWithSlider(setting: $settingsModel.frequencyPenalty)
            }
            .listStyle(PlainListStyle())
            .padding(.top, -20)
        }
        .navigationTitle(Strings.settings)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    SettingsView()
}
