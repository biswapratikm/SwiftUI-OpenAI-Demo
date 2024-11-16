//
//  SettingRowWithText.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/10/24.
//

import SwiftUI

struct SettingRowWithText: View {
    @Binding var setting: Setting
    @State private var inputValue: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Display setting name and value
            HStack {
                Text("\(setting.name):")
                    .font(.headline)
                Text("\(Int(setting.value))")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primary)
            }
            
            // Setting description
            Text(setting.description)
                .font(.subheadline)
                .foregroundColor(AppColors.gray)
            
            // Input field for value
            HStack {
                TextField(Strings.enterValue, text: $inputValue, onCommit: {
                    updateSettingValue() // Commit input change
                })
                .keyboardType(.numberPad)
                .padding()
                .cornerRadius(5)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .onReceive(inputValue.publisher.collect()) {
                    // Limit input to 3 digits
                    self.inputValue = String($0.prefix(3).filter { Strings.digits.contains($0) })
                }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button(Strings.done) {
                            updateSettingValue() // Apply value
                            hideKeyboard() // Close keyboard
                        }
                    }
                }
                .submitLabel(.done)
            }
        }
        .padding()
        .onAppear {
            inputValue = "\(Int(setting.value))" // Initialize input value
        }
    }
    
    private func updateSettingValue() {
        // Update value if within range
        if let value = Int(inputValue), Double(value) >= setting.minValue, Double(value) <= setting.maxValue {
            setting.value = Double(value)
        }
    }
}

// Extension to hide the keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SettingRowWithText(setting: .constant(SettingsModel.shared.maxTokens))
}
