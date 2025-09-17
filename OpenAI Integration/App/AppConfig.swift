//
//  AppConfig.swift
//  OpenAI Integration
//
//  Created by Biswapratik Maharana on 14/11/24.
//


final class AppConfig {
    static let shared = AppConfig()
    
    // Global debug mode flag
    let isDebugMode: Bool
    
    private init() {
//        #if DEBUG
//        self.isDebugMode = true
//        #else
        self.isDebugMode = false
//        #endif
    }
}
