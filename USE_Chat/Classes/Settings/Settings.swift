//
//  Settings.swift
//  USE_Chat
//
//  Created by Usemobile on 07/03/19.
//

import Foundation

public enum ChatLanguage: String {
    case en
    case pt
}

var currentLanguage: ChatLanguage = .pt

public class ChatSettings {
    
    public var language: ChatLanguage = .pt {
        didSet {
            currentLanguage = language
        }
    }
    
    public var tableBackgroundImage: UIImage?
    public var tableBackgroundColor: UIColor
    public var checkIfNavBarIsTranslucent = true
    public var currentUserSettings: MessageCellSettings
    public var otherUsersSettings: MessageCellSettings
    public var inputViewSettings: InputViewSettings
    public var titleViewSettings: TitleViewSettings
    
    public static var `default`: ChatSettings {
        return ChatSettings()
    }
    
    public init(tableBackgroundImage: UIImage? = nil, tableBackgroundColor: UIColor = .white, currentUserSettings: MessageCellSettings = .default, otherUsersSettings: MessageCellSettings = .default, inputViewSettings: InputViewSettings = .default, titleViewSettings: TitleViewSettings = .default) {
        self.tableBackgroundImage = tableBackgroundImage
        self.tableBackgroundColor = tableBackgroundColor
        self.currentUserSettings = currentUserSettings
        self.otherUsersSettings = otherUsersSettings
        self.inputViewSettings = inputViewSettings
        self.titleViewSettings = titleViewSettings
    }
}

public class MessageCellSettings {
    public var backgroundColor: UIColor
    public var textColor: UIColor
    public var textFont: UIFont
    public var dateFont: UIFont
    
    public static var `default`: MessageCellSettings {
        return MessageCellSettings(backgroundColor: .white, textColor: .black, textFont: .systemFont(ofSize: 14), dateFont: .systemFont(ofSize: 6))
    }
    
    public init(backgroundColor: UIColor, textColor: UIColor, textFont: UIFont, dateFont: UIFont) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.textFont = textFont
        self.dateFont = dateFont
    }
}

public class InputViewSettings {
    public var textFont: UIFont
    public var placeholderFont: UIFont
    public var textColor: UIColor
    public var placeholderColor: UIColor
    public var sendImage: UIImage?
    public var sendTintColor: UIColor?
    
    public static var `default`: InputViewSettings {
        return InputViewSettings(textFont: .systemFont(ofSize: 14), placeholderFont: .italicSystemFont(ofSize: 14), textColor: .black, placeholderColor: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1))
    }
    
    public init(textFont: UIFont, placeholderFont: UIFont, textColor: UIColor, placeholderColor: UIColor, sendImage: UIImage? = nil, sendTintColor: UIColor? = nil) {
        self.textFont = textFont
        self.placeholderFont = placeholderFont
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.sendImage = sendImage
        self.sendTintColor = sendTintColor
    }
}

public class TitleViewSettings {
    public var font: UIFont
    public var textColor: UIColor
    
    public static var `default`: TitleViewSettings {
        return TitleViewSettings(font: .systemFont(ofSize: 17, weight: .semibold), textColor: .black)
    }
    
    public init(font: UIFont, textColor: UIColor) {
        self.font = font
        self.textColor = textColor
    }
}
