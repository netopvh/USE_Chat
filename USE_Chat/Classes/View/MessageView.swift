//
//  MessageView.swift
//  USE_Chat
//
//  Created by Usemobile on 06/03/19.
//

import Foundation
import UIKit

class MessageView: UIView {
    
    // MARK: - UI Components
    
    lazy var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        return view
    }()
    
    lazy var lblText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        self.circleView.addSubview(label)
        return label
    }()
    
    lazy var lblDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 6)
        self.circleView.addSubview(label)
        return label
    }()
    
    // MARK: - Properties
    
    var message: MessageViewModel? {
        didSet {
            self.setup()
        }
    }
    
    var settings: MessageCellSettings? {
        didSet {
            guard let _settings = self.settings else { return }
            self.lblText.font = _settings.textFont
            self.lblDate.font = _settings.dateFont
            self.lblText.textColor = _settings.textColor
            self.lblDate.textColor = _settings.textColor
            self.circleView.backgroundColor = _settings.backgroundColor
        }
    }
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.applyShadowToCircle()
        self.circleView.setCorner(12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.setConstraints()
        guard let _message = message else { return }
        self.lblText.text = _message.message
        self.lblDate.text = _message.dateStr
        
        let isFromCurrentUser = _message.isFromCurrentUser
        self.lblDate.textAlignment = isFromCurrentUser ? .left : .right
    }
    
    fileprivate func setConstraints() {
        self.circleView.fillSuperview()
        self.lblText.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, padding: .init(top: 12, left: 16, bottom: 0, right: 16))
        self.lblDate.anchor(top: self.lblText.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}
