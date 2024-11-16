//
//  InstructionTextView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 01/11/24.
//


import SwiftUI

struct InstructionTextView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(AppColors.secondary)
            .frame( height: 300)
    }
}

#Preview {
    InstructionTextView(text: "Type in your prompt, and GPT-4o-mini will generate a short text response based on it.")
}
