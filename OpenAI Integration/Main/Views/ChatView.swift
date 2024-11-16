//
//  ChatView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 22/10/24.
//
import SwiftUI

struct ChatView: View {
    
    // ViewModel for chat functionality
    @StateObject private var viewModel: ChatViewModel
    
    // Initialize ViewModel with capability
    init(capability: Capability) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(capability: capability))
    }
    
    var body: some View {
        VStack {
            
            // Scrollable chat messages
            ScrollViewReader { scrollViewProxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // Instructional text when no messages are present
                        if viewModel.messages.isEmpty {
                            InstructionTextView(text: viewModel.capability.display)
                        } else {
                            // Display chat messages
                            ForEach(viewModel.messages) { message in
                                ChatBubble(text: message.content,
                                           isUser: message.role == .user,
                                           isFullWidth: false)
                                .id(message.id)
                            }
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages) {
                    // Scroll to the last message when updated
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input field for new messages
            MessageInputView(userInput: $viewModel.userInput,
                             isLoading: viewModel.isLoading,
                             placeholder: Strings.placeholderMessage,
                             onSend: viewModel.sendMessage)
        }
        // Title, error handling, and toolbar configuration
        .modifier(
            title: viewModel.capability.name,
            showErrorAlert: $viewModel.showErrorAlert,
            errorMessage: viewModel.errorMessage,
            toolbarText: Strings.settings,
            toolbarDestination: SettingsView()
        )
    }
}


#Preview {
    if let firstModel = openAIModels.first {
        if let firstCapability = firstModel.capabilities.first {
            ChatView(capability: firstCapability)
        }
    }
}
