//
//  InputAccessoryView.swift
//  USE_Chat
//
//  Created by Usemobile on 07/03/19.
//

import Foundation
import UIKit

public let ALKeyboardFrameDidChangeNotification = "ALKeyboardFrameDidChangeNotification"
class InputAccessoryView: UIView {
    
    // MARK: - Properties
    
    private weak var observedView: UIView?
    private var defaultHeight: CGFloat = 44
    var constraintToUpdate: NSLayoutConstraint?
    var didUpdateConstraint: (() -> Void)?
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: defaultHeight)
    }
    
    // MARK: - Life Cycle
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        
        removeKeyboardObserver()
        if let _newSuperview = newSuperview {
            addKeyboardObserver(newSuperview: _newSuperview)
        }
        
        super.willMove(toSuperview: newSuperview)
    }
    
    deinit {
        removeKeyboardObserver()
    }
    
    // MARK: - Setup
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? NSObject == superview && keyPath == keyboardHandlingKeyPath(), let s = superview {
            
            let keyboardFrame = s.frame
            let screenBounds = UIScreen.main.bounds
            if let cnst = self.constraintToUpdate {
                let value = screenBounds.size.height - keyboardFrame.origin.y
                cnst.constant = -value
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    public func updateHeight(height: CGFloat) {
        for constraint in constraints {
            if constraint.firstAttribute == NSLayoutConstraint.Attribute.height && constraint.firstItem as! NSObject == self {
                constraint.constant = height < defaultHeight ? defaultHeight : height
            }
        }
    }
    
    private func keyboardHandlingKeyPath() -> String {
        return "center"
    }
    
    private func addKeyboardObserver(newSuperview: UIView) {
        observedView = newSuperview
        newSuperview.addObserver(self, forKeyPath: keyboardHandlingKeyPath(), options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    private func removeKeyboardObserver() {
        if observedView != nil {
            observedView!.removeObserver(self, forKeyPath: keyboardHandlingKeyPath())
            observedView = nil
        }
    }
    
    private func keyboardDidChangeFrame(frame: CGRect) {
        let userInfo: [AnyHashable : Any] = [UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect:frame)]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ALKeyboardFrameDidChangeNotification), object: nil, userInfo: userInfo)
    }
}
