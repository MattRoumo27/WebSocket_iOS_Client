//
//  JoinChat.swift
//  WebSocket_ChatClient
//
//  Created by Matt Roumeliotis on 1/21/21.
//

import SwiftUI

struct JoinChat: View {
    @State private var showingAlert = false
    @State private var nickName: String = ""
    @State private var moveToNextScreen = false
    @EnvironmentObject var service: SocketService
    
    // Controls when to move on to the next view
    var body: some View {
        joinChat
    }
    
    // Groups the button and alert together
    var joinChat: some View {
        ZStack {
            //NavigationLink(destination: ChatTableView(handle: nickName), isActive: $moveToNextScreen) { EmptyView() }
            NavigationLink(destination: ParticipantListView(), isActive: $moveToNextScreen) { EmptyView() }
            joinChatButton
            enterNameAlert
        }
    }
    
// MARK: - Front End Components
    // Simple button that a user can click to start the process to join the chat room
    var joinChatButton: some View {
        Button(action: {
            self.showingAlert = true
        }, label: {
            Rectangle()
                .frame(width: 150, height: 40)
                .overlay(
                    Text("Join Chat")
                        .foregroundColor(Color.white))
        })
    }
    
    // User is asked to enter their name. Once 'Ok' is hit they are connected to the server and taken to the chat room
    var enterNameAlert: some View {
        TextFieldAlert(title: "Please enter a name:", isShown: $showingAlert, text: $nickName, onOk: { text in
            print(text)
            service.sendUsername(hand: nickName)
            self.moveToNextScreen = true
        })
    }
}

struct JoinChat_Previews: PreviewProvider {
    static var previews: some View {
        JoinChat()
    }
}
