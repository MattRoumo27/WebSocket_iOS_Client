//
//  TextFieldAlert.swift
//  WebSocket_ChatClient
//
//  Created by Matt Roumeliotis on 1/21/21.
//

import SwiftUI

struct TextFieldAlert: View {
    
    let screenSize = UIScreen.main.bounds
    var title = ""
    @Binding var isShown: Bool
    @Binding var text: String
    var onOk: (String) -> Void = { _ in }
    var onCancel: () -> Void = { }
    
    var body: some View {
        VStack {
            Text(title)
            TextField("", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Button("Cancel") {
                    self.isShown = false
                    self.onCancel()
                }
                
                Button("OK") {
                    self.isShown = false
                    self.onOk(self.text)
                }
            }
        }.padding()
        .frame(width: screenSize.width * 0.7, height: screenSize.height * 0.3)
        .background(Color(#colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20.0,
                                    style: .continuous))
        .offset(y: isShown ? 0 : screenSize.height)
        .animation(.spring())
        .shadow(color: Color(#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)), radius: 6, x: -9, y: -9)
    }
}

struct TextFieldAlert_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldAlert(isShown: .constant(true), text: .constant(""))
    }
}
