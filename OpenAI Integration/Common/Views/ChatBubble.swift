//
//  TextView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 31/10/24.
//


import SwiftUI

struct ChatBubble: View {
    let text: String
    var isUser: Bool
    var isFullWidth: Bool = true
    var italic: Bool = false

    var body: some View {
        HStack {
            if isUser && !isFullWidth { Spacer() } // Align user bubble right
            Text(text)
                .padding(10)
                .background(isUser ? AppColors.blue : AppColors.backgroundGray)
                .foregroundColor(isUser ? AppColors.white : AppColors.primary)
                .cornerRadius(15)
                .frame(maxWidth: isFullWidth ? .infinity : 250, alignment: alignment)
                .italic(italic)
            if !isUser && !isFullWidth { Spacer() } // Align assistant bubble left
        }
    }

    private var alignment: Alignment {
        isFullWidth ? .leading : (isUser ? .trailing : .leading)
    }
}




#Preview {
    ChatBubble(text: "Hello", isUser: false, isFullWidth: true)
    ChatBubble(text: "Hello", isUser: false, isFullWidth: false)
    ChatBubble(text: "Hello", isUser: true, isFullWidth: true)
    ChatBubble(text: "Hello", isUser: true, isFullWidth: false)
    
    ChatBubble(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", isUser: false, isFullWidth: true)
    ChatBubble(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", isUser: false, isFullWidth: false)
    ChatBubble(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", isUser: true, isFullWidth: true)
    ChatBubble(text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", isUser: true, isFullWidth: false)
}
