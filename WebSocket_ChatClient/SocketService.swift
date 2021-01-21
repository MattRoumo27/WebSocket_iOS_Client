//
//  SocketService.swift
//  WebSocket_ChatClient
//
//  Created by Matt Roumeliotis on 1/15/21.
//

import Foundation
import SocketIO

let host = "http://192.168.1.39:4000"

final class SocketService: ObservableObject  {
    private var manager = SocketManager(socketURL: URL(string: host)!, config: [.log(false), .compress])
    private var socket: SocketIOClient?
    
    @Published var messages = [String]()
    @Published var handleCurrentTyping = [String]()
    @Published var participantsList = [String : String]()
    @Published var userName = ""
    
    init() {
        configureSocket()
    }
    
    // Setup the socket to connect with the server and to start listening for events.
    func configureSocket() {
        socket = manager.defaultSocket
        
        guard let socket = socket else {
            print("configureSocket: found nil value for socket")
            return
        }
        
        socket.on(clientEvent: .connect) { (data, ack) in
            print("Connected")
            
            self.receiveChat()
            self.receiveTypingNotification()
            self.receiveParticipantsList()
        }
        
        socket.connect()
    }
    
    // MARK: - Sending Data
    
    // Sends the chat to the server which will handle sending it to everyone on the participant's list including this device
    func sendChat(hand: String, msg: String) {
        guard let socket = socket else {
            print("sendChat: found nil value for socket")
            return
        }
        
        socket.emit("chat", [ "message": msg, "handle": hand])
    }
    
    func sendTypingNotification(hand: String) {
        guard let socket = socket else {
            print("sendTypingNotification: found nil value for socket")
            return
        }
        
        socket.emit("typing", hand)
    }
    
    func sendUsername(hand: String) {
        guard let socket = socket else {
            print("sendUserName: found nil value for socket")
            return
        }
        
        socket.emit("registerName", hand)
        self.userName = hand
    }
    
    func askForParticipantsList() {
        guard let socket = socket else {
            print("askForParticipantsList: found nil value for socket")
            return
        }
        
        print("Asking for list of participants")
        socket.emit("participantsList")
    }
    
    // MARK: - Listening for Data
    
    // Listen for chat messages received from the server. Unpack the JSON data and add it to the messages array
    func receiveChat() {
        guard let socket = socket else {
            print("receiveChat: found nil value for socket")
            return
        }
        
        socket.on("chat") { [weak self] (data, ack) in
            print(data)
            if let data = data[0] as? [String: String],
               let handle = data["handle"],
               let message = data["message"] {
                DispatchQueue.main.async {
                    let msgReceived = String(handle + ": " + message)
                    self?.messages.append(msgReceived)
                    self?.handleCurrentTyping = []
                }
            }
        }
    }
    
    // Listen for a typing notification
    func receiveTypingNotification() {
        guard let socket = socket else {
            print("receiveTypingNotification: found nil value for socket")
            return
        }
        
        socket.on("typing") { [weak self] (data, ack) in
            if let data = data[0] as? String {
                self?.handleCurrentTyping.append(data)
            }
        }
    }
    
    func receiveParticipantsList() {
        guard let socket = socket else {
            print("receiveParticipantList: found nil value for socket")
            return
        }
        
        // Listen for the participants list from the server
        socket.on("participantList") { [weak self] (data, ack) in
            if let data = data[0] as? [String : String] {
                guard let self = self else {
                    return
                }
                
                var userList = data
                
                // Removing this client's name from the list of participants received
                if let index = userList.firstIndex(where: { $0.value == self.userName }) {
                    userList.remove(at: index)
                }
                self.participantsList = userList
            }
        }
    }
}
