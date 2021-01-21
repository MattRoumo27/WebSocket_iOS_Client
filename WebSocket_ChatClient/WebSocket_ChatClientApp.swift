//
//  WebSocket_ChatClientApp.swift
//  WebSocket_ChatClient
//
//  Created by Matt Roumeliotis on 1/14/21.
//

import SwiftUI

@main
struct WebSocket_ChatClientApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(SocketService())
        }
    }
}
