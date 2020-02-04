//
//  MessageViewModel.swift
//  USE_Chat
//
//  Created by Usemobile on 06/03/19.
//

import Foundation

public class MessageViewModel: NSObject {
    
    public let message: String
    public let dateStr: String
    public let isFromCurrentUser: Bool
    public let date: Date
    
    public init(message: String, date: Date, isFromCurrentUser: Bool) {
        self.message = message
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        self.dateStr = formatter.string(from: date)
        self.date = date
        self.isFromCurrentUser = isFromCurrentUser
        super.init()
    }
}
