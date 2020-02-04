//
//  TitleView.swift
//  USE_Chat
//
//  Created by Usemobile on 06/03/19.
//

import UIKit

class TitleView: UIView {
    
    // MARK: - UI Components
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        self.addSubview(view)
        return view
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let imageAspect: CGFloat = 1/1
        let size: CGFloat = 34
        imageView.center.y = label.center.y
        imageView.setCorner(size/2)
        return imageView
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = settings.font
        label.textColor = settings.textColor
        label.sizeToFit()
        label.textAlignment = .center
        label.center = self.center
        return label
    }()
    
    // MARK: - Properties
    
    var settings: TitleViewSettings = .default {
        didSet {
            self.label.font = settings.font
            self.label.textColor = settings.textColor
        }
    }
    
    var model: ChatUserViewModel
    
    // MARK: - Life Cycle
    
    init(model: ChatUserViewModel, settings: TitleViewSettings = .default) {
        self.model = model
        self.settings = settings
        let size: CGFloat = 34
        let width = UIScreen.main.bounds.width * 0.75
        super.init(frame: .init(origin: .zero, size: .init(width: width, height: size)))
        self.setup(size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    fileprivate func setup(_ size: CGFloat) {
        self.setupContentViewConstraints()
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.label)
        self.imageView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil, size: .init(width: size, height: size))
        self.label.anchor(top: self.topAnchor, left: self.imageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        self.setup()
    }
    
    fileprivate func setupContentViewConstraints() {
        self.addConstraints([
            self.contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.contentView.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor),
            self.contentView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
    }
    
    private func setup() {
        self.label.text = self.model.fullName
        if let imageUrl = self.model.imageUrl {
            if let image = self.model.image {
                self.imageView.image = image
            }
            DispatchQueue.main.async {
                self.imageView.cast(urlStr: imageUrl)
            }
        } else {
            self.imageView.image = self.model.image
        }
    }
}
