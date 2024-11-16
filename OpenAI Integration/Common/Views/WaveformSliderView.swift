//
//  WaveformSliderView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 06/11/24.
//


import SwiftUI

struct WaveformSliderView: View {
    @Binding var progress: Double
    var waveformHeights: [CGFloat]
    var currentProgressIndex: Int
    var seekToIndex: (Int) -> Void

    var body: some View {
        HStack(spacing: 1.6) {
            // Create waveform bars with dynamic height
            ForEach(0..<waveformHeights.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 1.6)
                    .frame(width: 1.6, height: waveformHeights[index])
                    .foregroundColor(index < currentProgressIndex ? AppColors.primary : AppColors.secondary)
            }
        }
        .overlay {
            // Custom slider for seeking progress
            CustomSlider(
                progress: Binding(
                    get: { progress },
                    set: { newValue in
                        let index = Int(newValue * Double(waveformHeights.count))
                        seekToIndex(index) // Seek to the new index
                    }
                ),
                thumbSize: 14
            )
            .frame(height: 14) // Slider height
        }
    }
}



#Preview {
    @Previewable @State var progress = 0.5
    return WaveformSliderView(
        progress: $progress,
        waveformHeights: [10, 20, 15, 30, 25, 100],
        currentProgressIndex: 3,
        seekToIndex: { _ in }
    )
}

