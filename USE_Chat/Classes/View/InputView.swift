//
//  InputView.swift
//  USE_Chat
//
//  Created by Usemobile on 06/03/19.
//

import UIKit

protocol InputViewDelegate {
    func sendPressed(newMessage: MessageViewModel)
}

class InputView: UIView {
    
    // MARK: - UI Components

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .white
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.textViewBorder.cgColor
        textView.textContainerInset.left = self.textPadding
        textView.textContainerInset.right = self.textPadding
        textView.addSubview(self.lblPlaceholder)
        textView.sendSubviewToBack(self.lblPlaceholder)
        self.addSubview(textView)
        return textView
    }()
    
    lazy var btnSend: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.sendPressed), for: .touchUpInside)
        self.addSubview(button)
        return button
    }()
    
    lazy var lblPlaceholder: UILabel = {
        let label = UILabel()
        label.text = String.getStringFrom(customClass: InputView.self, key: "lblPlaceholder_text") ?? .fail
        label.frame = CGRect(x: self.textPadding + 6, y: 8, width: 100, height: 30)
        label.textAlignment = .left
        label.text = .typeHere
        return label
    }()
    
    // MARK: - Properties
    
    var isBtnSendVisible = false
    var didIncreaseHeight: (() -> Void)?
    var accessoryView: InputAccessoryView?
    var textViewHeight = NSLayoutConstraint()
    var textViewRightAnchor = NSLayoutConstraint()
    var textPadding: CGFloat = 10
    var delegate: InputViewDelegate?
    var settings: InputViewSettings = .default
    let padding: CGFloat = 12
    var txvBottom = NSLayoutConstraint()
    
    // MARK: - Life Cycle
    
    init(settings: InputViewSettings = .default) {
        self.settings = settings
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    // MARK: - Setup
    
    fileprivate func setupTextViewConstraints() {
        let bottomAnchor = (UIDevice.isXFamily ? (padding + 20) : padding)
        self.txvBottom = self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -bottomAnchor)
        self.txvBottom.isActive = true
        self.textView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, padding: .init(top: padding, left: padding, bottom: bottomAnchor, right: 0))
        self.textViewRightAnchor = self.textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -padding)
        self.textViewRightAnchor.isActive = true
        self.textViewHeight = self.textView.heightAnchor.constraint(equalToConstant: 40)
        self.textViewHeight.isActive = true
    }
    
    fileprivate func setupTextView() {
        self.setupTextViewConstraints()
        self.textView.text = ""
        self.setupAttributes()
        self.resize(textView: textView, increaseHeight: false)
        self.textView.setCorner(33/2)
    }
    
    private func setup() {
        self.setupTextView()
        self.btnSend.anchor(top: nil, left: self.textView.rightAnchor, bottom: self.textView.bottomAnchor, right: nil, padding: .init(top: 0, left: padding, bottom: -5.5, right: padding), size: .init(width: 44, height: 44))
        self.applyLightShadowToCircle()
        self.setupSettings()
    }
    
    private func setupSettings() {
        let image: UIImage? = self.settings.sendImage ?? UIImage.getFrom(customClass: InputView.self, nameResource: "send", type: "png")
        if let tintColor = self.settings.sendTintColor {
            self.btnSend.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
            self.btnSend.tintColor = tintColor
        } else {
            self.btnSend.setImage(image, for: .normal)
        }
    }
    
    @objc func sendPressed() {
        guard var text = self.textView.text, !text.isEmpty, self.textView.textColor != self.settings.placeholderColor else { return }
        while text.last == "\n" {
            text.removeLast()
        }
        while text.first == "\n" {
            text.removeFirst()
        }
        guard !text.isEmpty else { return }
        self.textView.text = nil
        self.textViewDidChange(self.textView)
        let message = MessageViewModel(message: text, date: Date(), isFromCurrentUser: true)
        self.delegate?.sendPressed(newMessage: message)
    }
    
    private func setupAttributes() {
        self.textView.textColor = self.settings.textColor
        self.textView.font = self.settings.textFont
        self.lblPlaceholder.textColor = self.settings.placeholderColor
        self.lblPlaceholder.font = self.settings.placeholderFont
        self.lblPlaceholder.sizeToFit()
    }
    
    func setSendVisible() {
        guard let text = self.textView.text else { return }
        if (self.isBtnSendVisible && text.isEmpty) || (!self.isBtnSendVisible && !text.isEmpty) {
            self.isBtnSendVisible = !self.isBtnSendVisible
            self.textViewRightAnchor.constant = self.isBtnSendVisible ? -(44 + 2*padding) : -padding
            UIView.animate(withDuration: 0.25) {
                self.layoutIfNeeded()
            }
        }
    }

}

// MARK: - TextView Delegate

extension InputView: UITextViewDelegate {
    
    func resize(textView: UITextView, increaseHeight: Bool) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        let newHeight: CGFloat = estimatedSize.height >= 100 ? 100 : estimatedSize.height
        let didIncrease = newHeight > textView.frame.height
        self.textViewHeight.constant = newHeight
        textView.isScrollEnabled = estimatedSize.height >= 100
        if let view = self.accessoryView {
            view.updateHeight(height: newHeight + 24)
        }
        self.layoutIfNeeded()
        if didIncrease && increaseHeight {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                self.didIncreaseHeight?()
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.setSendVisible()
        self.lblPlaceholder.isHidden = !textView.text.isEmpty
        self.resize(textView: textView, increaseHeight: true)
    }
    
    
}
