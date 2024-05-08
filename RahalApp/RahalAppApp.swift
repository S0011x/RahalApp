//
//  RahalAppApp.swift
//  RahalApp
//
//  Created by Juman Dhaher on 19/10/1445 AH.
//

import SwiftUI

@main
struct RahalAppApp: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true

    var body: some Scene {
        WindowGroup {
            SplashView(isOnboarding: $isOnboarding)
        }
    }
}
