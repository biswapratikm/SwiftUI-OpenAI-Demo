//
//  CommonViewModifier.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 08/11/24.
//


import SwiftUI

struct CommonLayoutModifier<Destination: View>: ViewModifier {
    let title: String
    @Binding var showErrorAlert: Bool
    let errorMessage: String
    let toolbarText: String?
    let toolbarDestination: Destination?

    init(
        title: String,
        showErrorAlert: Binding<Bool>,
        errorMessage: String,
        toolbarText: String? = nil,
        toolbarDestination: Destination? = nil
    ) {
        self.title = title
        _showErrorAlert = showErrorAlert
        self.errorMessage = errorMessage
        self.toolbarText = toolbarText
        self.toolbarDestination = toolbarDestination
    }

    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Add toolbar item if text and destination exist
                if let toolbarText = toolbarText, let toolbarDestination = toolbarDestination {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: toolbarDestination) {
                            Text(toolbarText)
                                .font(.headline)
                        }
                    }
                }
            }
            .alert(isPresented: $showErrorAlert) {
                // Show error alert
                Alert(
                    title: Text(Strings.error),
                    message: Text(errorMessage),
                    dismissButton: .default(Text(Strings.ok))
                )
            }
            .onTapGesture {
                // Dismiss keyboard on tap
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
    }
}

extension View {
    func modifier<Destination: View>(
        title: String,
        showErrorAlert: Binding<Bool>,
        errorMessage: String,
        toolbarText: String? = nil,
        toolbarDestination: Destination = EmptyView()
    ) -> some View {
        self.modifier(
            CommonLayoutModifier(
                title: title,
                showErrorAlert: showErrorAlert,
                errorMessage: errorMessage,
                toolbarText: toolbarText,
                toolbarDestination: toolbarDestination
            )
        )
    }
}

