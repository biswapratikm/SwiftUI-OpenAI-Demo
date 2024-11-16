//
//  SmallThumbSliderStyle.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 06/11/24.
//


import SwiftUI

struct CustomSlider: View {
    @Binding var progress: Double
    var thumbColor: Color = AppColors.white
    var thumbSize: CGFloat = 12
    var trackColor: Color = AppColors.clear
    var lineWidth: CGFloat = 4

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            ZStack(alignment: .leading) {
                // Track for slider
                Rectangle()
                    .fill(trackColor)
                    .frame(height: lineWidth)
                // Thumb for slider
                Circle()
                    .fill(thumbColor)
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: width * CGFloat(progress) - thumbSize / 2)
                    .gesture(
                        // Drag gesture for updating progress
                        DragGesture()
                            .onChanged { value in
                                let newProgress = min(max(0, value.location.x / width), 1)
                                progress = newProgress
                            }
                    )
            }
            .frame(height: max(lineWidth, thumbSize))
        }
    }
}


#Preview {
    @Previewable @State var progress = 0.5
    CustomSlider(progress: $progress)
}

