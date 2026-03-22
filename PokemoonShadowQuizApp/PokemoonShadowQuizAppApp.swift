//
//  PokemoonShadowQuizAppApp.swift
//  PokemoonShadowQuizApp
//
//  Created by Bartosz Mrugała on 14/07/2025.
//

import SwiftUI

@main
struct PokemoonShadowQuizAppApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some Scene {
        WindowGroup {
            StartView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
