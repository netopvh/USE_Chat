//
//  Extensions.swift
//  USE_Chat
//
//  Created by Usemobile on 06/03/19.
//

import Foundation
import UIKit

extension String {
    static func getStringFrom(customClass: AnyClass, key: String) -> String? {
//        let string = NSLocalizedString(key, tableName: nil, bundle: Bundle(for: customClass), value: "", comment: "")
//        return string
        if let bundle = Bundle(path: Bundle(for: customClass).path(forResource: "USE_Chat", ofType: "bundle") ?? "") {
            return NSLocalizedString(key, bundle: bundle, comment: "")
        } else {
            return nil
        }
//        return NSLocalizedString(key, bundle: Bundle(for: customClass), comment: "")
    }
}


extension UIImage {
    
    class func getFrom(nameResource: String, type: String) -> UIImage? {
        guard let bundle = Bundle.main.path(forResource: nameResource, ofType: type) else { return nil }
        let url = URL(fileURLWithPath: bundle)
        guard let data = try? Data(contentsOf: url) else { return nil }
        let image = UIImage(data: data)
        return image
    }
    
    class func getFrom(customClass: AnyClass, nameResource: String) -> UIImage? {
        let frameworkBundle = Bundle(for: customClass)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("org.cocoapods.USE-Chat.bundle")
        let resourceBundle = Bundle(url: bundleURL!)
        let image = UIImage(named: nameResource, in: resourceBundle, compatibleWith: nil)
        return image
    }
    
    class func getFrom(customClass: AnyClass, nameResource: String, type: String) -> UIImage? {
        guard let bundle = Bundle(for: customClass).path(forResource: nameResource, ofType: type) else { return nil }
        let url = URL(fileURLWithPath: bundle)
        guard let data = try? Data(contentsOf: url) else { return nil }
        let image = UIImage(data: data)
        return image
    }
}

extension UIView {
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        anchor(top: superview?.topAnchor, left: superview?.leftAnchor, bottom: superview?.bottomAnchor, right: superview?.rightAnchor, padding: padding)
    }

    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
            
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: padding.left).isActive = true
            
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -padding.right).isActive = true
            
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
            
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
        
    }
    
    func applyLightShadow() {
        self.applyShadow(opacity: 0.2, shadowRadius: 3.0)
    }
    
    func applyShadow(opacity: Float, shadowRadius: CGFloat) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
    }
    
    
    func applyCircle() {
        self.setCorner(self.bounds.height/2)
    }
    
    func setCorner(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
    
    func applyLightShadowToCircle() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 3
    }
    
    func applyShadowToCircle() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 5
    }
    
    func removeShadow() {
        self.layer.shadowPath = nil
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 0
        self.layer.shadowOpacity = 0
    }
    
    func setBottomShadow() {
        self.addshadow(top: false, left: false, bottom: true, right: false)
    }
    
    func addshadow(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat = 1.5) {
        
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 0.3
        
        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height
        
        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}

extension UIColor {
    
    static let chatBarBG: UIColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
    static let textViewBorder: UIColor = #colorLiteral(red: 0.9176470588, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
    static let sendButton: UIColor = #colorLiteral(red: 0.08235294118, green: 0.5725490196, blue: 0.9019607843, alpha: 1)
    
}


extension UITextField {
    
    func setPlaceholderFont(_ text: String, _ font: UIFont, _ color: UIColor) {
        let attributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font
        ]
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
    
}

extension UIDevice {
    
    static let isXFamily: Bool = {
        return UIScreen.main.bounds.size.height >= 812
    }()
    
}

extension UIImageView {
    
    func cast(urlStr: String, placeholder: UIImage? = nil, completion: ((UIImage?, String?) -> Void)? = nil) {
        self.image = placeholder
        guard let url = URL.init(string: urlStr) else {
            completion?(nil, "URL inválida")
            return
        }
        URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    let image: UIImage? = UIImage(data: data)
                    completion?(image, nil)
                    self.image = image
                }
            } else if let error = error {
                completion?(nil, error.localizedDescription)
            } else {
                completion?(nil, "Image cast fail")
            }
        }.resume()
    }
}
