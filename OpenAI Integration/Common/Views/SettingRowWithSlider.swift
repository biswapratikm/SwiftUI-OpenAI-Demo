//
//  SettingRowWithSlider.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 03/10/24.
//

import SwiftUI

struct SettingRowWithSlider: View {
    @Binding var setting: Setting

    var body: some View {
        VStack(alignment: .leading) {
            // Display setting name and current value
            HStack {
                Text("\(setting.name):")
                    .font(.headline)
                Text("\(setting.value, specifier: Strings.decimal)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primary)
            }

            // Description text for the setting
            Text(setting.description)
                .font(.subheadline)
                .foregroundColor(AppColors.gray)

            // Slider to adjust the setting value
            HStack {
                // Minimum value label
                Text("\(setting.minValue, specifier: Strings.decimal)")
                    .font(.subheadline)
                    .foregroundColor(AppColors.primary)

                // Slider control to change the setting value
                Slider(value: $setting.value, in: setting.minValue...setting.maxValue, step: 0.1)

                // Maximum value label
                Text("\(setting.maxValue, specifier: Strings.decimal)")
                    .font(.subheadline)
                    .foregroundColor(AppColors.primary)
            }
        }
        .padding()
    }
}



#Preview {
    SettingRowWithSlider(setting: .constant(SettingsModel.shared.temperature))
}
