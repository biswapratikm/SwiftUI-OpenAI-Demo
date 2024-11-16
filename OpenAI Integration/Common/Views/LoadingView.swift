//
//  LoadingView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/11/24.
//


import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    LoadingView()
}

