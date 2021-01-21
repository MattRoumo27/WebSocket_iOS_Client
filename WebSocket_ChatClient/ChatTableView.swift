//
//  ChatTable.swift
//  WebSocket_ChatClient
//
//  Created by Matt Roumeliotis on 1/21/21.
//

import SwiftUI

struct ChatTableView: View {
    @EnvironmentObject var service: SocketService
    @State var handle = ""
    @State var message = ""
    
    var body: some View {
        VStack {
            messagingTable
            textFields
            sendButton
        }.padding(.all, 30)
        .navigationBarTitle(Text("Welcome \(service.userName)"), displayMode: .inline)
    }
    
    var messagingTable: some View {
        ScrollView {
            ForEach(service.messages, id: \.self) { msg in
                HStack {
                    Text(msg)
                        .foregroundColor(Color.black)
                    Spacer()
                }
                Divider()
            }
            HStack {
                Text(service.handleCurrentTyping.isEmpty ? "" : String(service.handleCurrentTyping[0] + " is typing"))
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                    .italic()
                Spacer()
            }
        }.background(Color(UIColor.lightGray).opacity(0.2))
    }
    
    var textFields: some View {
        Group {
           /* TextField("Handle", text: $handle) { isEditing in
                service.sendUsername(hand: handle)
            }
           */
            TextField("Message", text: $message) { isEditing in
                service.sendTypingNotification(hand: handle)
            }
        }
    }
    
    var sendButton: some View {
        Button(action: {
            service.sendChat(hand: service.userName, msg: message)
            message = ""
        }) {
            Rectangle()
                .foregroundColor(.blue)
                .frame(width: UIScreen.main.bounds.width - 20, height: 50)
                .overlay(
                    Text("Send")
                        .foregroundColor(.white))
        }
    }
}

struct ChatTable_Previews: PreviewProvider {
    static var previews: some View {
        ChatTableView().environmentObject(SocketService())
    }
}
