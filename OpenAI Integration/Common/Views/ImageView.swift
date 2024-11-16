//
//  ImageView.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 07/11/24.
//

import SwiftUI

struct ImageView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(15)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    ImageView(image: UIImage(named: "demo_image")!)
}
