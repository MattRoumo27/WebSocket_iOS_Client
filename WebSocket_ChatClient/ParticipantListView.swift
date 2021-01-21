//
//  ParticipantList.swift
//  WebSocket_ChatClient
//
//  Created by Matt Roumeliotis on 1/21/21.
//

import SwiftUI

struct ParticipantListView: View {
    @EnvironmentObject var service: SocketService
    @State var groupChatRoomSelected = false;
    
    @ViewBuilder
    var body: some View {
        if self.groupChatRoomSelected {
            ChatTableView()
        } else {
            listView
                .navigationBarTitle(Text("Welcome \(service.userName)"), displayMode: .inline)
                .padding(.all, 25)
                .onAppear() {
                    service.askForParticipantsList()
            }
        }
    }
    
    var listView: some View {
        ScrollView {
            participantsTable
            groupChatRoomButton
        }
    }
    
    var groupChatRoomButton: some View {
        Button(action: {
            self.groupChatRoomSelected = true
        }) {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.blue)
                .frame(width: UIScreen.main.bounds.width - 100, height: 50)
                .overlay(
                    Text("Join Server Chat")
                        .foregroundColor(.white))
        }
    }
    
    var participantsTable: some View {
        ForEach(service.participantsList.values.sorted(by: >), id: \.self) { name in
            HStack {
                Text(name)
                    .foregroundColor(.black)
                Spacer()
            }
            Divider()
        }
    }
}

struct ParticipantList_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantListView().environmentObject(SocketService())
    }
}
