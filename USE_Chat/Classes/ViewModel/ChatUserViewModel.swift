//
//  ChatUserViewModel.swift
//  USE_Chat
//
//  Created by Usemobile on 06/03/19.
//

import Foundation

public class ChatUserViewModel: NSObject {
    
    public var name: String
    public var lastName: String?
    public var imageUrl: String?
    public var image: UIImage?
    
    public var fullName: String {
        if let _lastName = self.lastName {
            return self.name + " " + _lastName
        }
        return self.name
    }
    
    public init(name: String, lastName: String? = nil, imageUrl: String? = nil, image: UIImage? = nil) {
        self.name = name
        self.lastName = lastName
        self.imageUrl = imageUrl
        self.image = image
        super.init()
    }
    
}
