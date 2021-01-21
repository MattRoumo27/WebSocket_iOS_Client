//
//  ContentView.swift
//  WebSocket_ChatClient
//
//  Created by Matt Roumeliotis on 1/14/21.
//

import SwiftUI


struct ContentView: View {
    
    var body: some View {
        NavigationView {
            JoinChat()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
