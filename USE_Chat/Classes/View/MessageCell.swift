//
//  MessageCell.swift
//  USE_Chat
//
//  Created by Usemobile on 06/03/19.
//

import UIKit

class CurrentUserCell: BaseMessageCell {
    
    override func setup() {
        super.setup()
        self.viewMessage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
    }
    
}

class OtherUsersCell: BaseMessageCell {
    
    override func setup() {
        super.setup()
        self.viewMessage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
    }
}

class BaseMessageCell: UITableViewCell {
    
    var message: MessageViewModel? {
        didSet {
            self.viewMessage.message = self.message
        }
    }
    
    var viewMessage = MessageView()
    
    var settings: MessageCellSettings? {
        didSet {
            self.viewMessage.settings = self.settings
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.viewMessage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.viewMessage)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        self.selectionStyle = .none
        let screenWidth = UIScreen.main.bounds.width
        self.viewMessage.anchor(top: self.topAnchor, left: nil, bottom: self.bottomAnchor, right: nil, padding: .init(top: 8, left: 0, bottom: 8, right: 0))
        self.viewMessage.widthAnchor.constraint(lessThanOrEqualToConstant: screenWidth * 0.65).isActive = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
