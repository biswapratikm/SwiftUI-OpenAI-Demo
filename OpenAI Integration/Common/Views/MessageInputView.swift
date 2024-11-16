//
//  MessageInputView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 31/10/24.
//


import SwiftUI

struct MessageInputView: View {
    @Binding var userInput: String
    var isLoading: Bool
    let placeholder: String
    let onSend: () -> Void
    
    var body: some View {
        HStack {
            // Input field for user message
            TextField(placeholder, text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading)
                .onSubmit {
                    onSend()
                }
            
            ZStack {
                if isLoading {
                    ProgressView()
                } else {
                    Button(action: onSend) {
                        Text(Strings.send)
                    }
                    .disabled(userInput.isEmpty)
                }
            }
            .frame(width: 50, height: 20)
            .padding()
        }
        .background(AppColors.background)
    }
}


#Preview {
    @Previewable @State var inputText = ""
    MessageInputView(userInput: $inputText, isLoading: false, placeholder: "Type a prompt...", onSend: { })
}
