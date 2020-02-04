//
//  ChatTableView.swift
//  USE_Chat
//
//  Created by Usemobile on 06/03/19.
//

import UIKit

protocol ChatTableViewDelegate {
    func newMessageCreated(_ tableView: ChatTableView, message: MessageViewModel)
}

class ChatTableView: UIView {
    
    // MARK: - UI Components
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .interactive
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tableTapped)))
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.register(CurrentUserCell.self, forCellReuseIdentifier: kCurrentUserCell)
        tableView.register(OtherUsersCell.self, forCellReuseIdentifier: kOtherUserCell)
        self.addSubview(tableView)
        return tableView
    }()
    
    lazy var textView: InputView = {
        let view = InputView(settings: self.settings.inputViewSettings)
        view.delegate = self
        view.backgroundColor = .chatBarBG
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.didIncreaseHeight = {
            self.scrollTable()
        }
        return view
    }()
    
    lazy var imvBackground: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.chatBackground ?? UIImage.getFrom(customClass: ChatTableView.self, nameResource: "chat", type: "png")
        self.addSubview(imageView)
        return imageView
    }()
    
    // MARK: - Properties
    
    var settings: ChatSettings = .default
    var chatBackground: UIImage?
    var textViewBottom = NSLayoutConstraint()
    var keyboardHeight: CGFloat?
    let kCurrentUserCell = "CurrentUserCell"
    let kOtherUserCell = "OtherUsersCell"
    var messages = [MessageViewModel]()
    var delegate: ChatTableViewDelegate?
    var allowKeyboardWillSHow = true
    
    // MARK: - LifeCycle
    
    init(settings: ChatSettings = .default, messages: [MessageViewModel] = []) {
        self.settings = settings
        self.messages = messages
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.setup()
        self.scrollTableAnimated()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow == nil {
            removeObservers()
        } else {
            addObservers()
        }
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - Observers
    
    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Setup
    
    private func setup() {
        self.imvBackground.fillSuperview()
        self.tableView.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor)
        self.textView.anchor(top: self.tableView.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor)
        self.textViewBottom = self.textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.textViewBottom.isActive = true
        self.setupSettings()
    }
    
    private func setupSettings() {
        if let image = self.settings.tableBackgroundImage {
            self.backgroundColor = .clear
            self.imvBackground.image = image
        } else {
            self.backgroundColor = self.settings.tableBackgroundColor
        }
    }
    
    func setupMessages(_ messages: [MessageViewModel]) {
        self.messages = messages
        self.tableView.reloadData()
        self.scrollTableAnimated()
    }
    
    func insertMessages(_ messages: [MessageViewModel]) {
        let (start, end) = (self.messages.count, (self.messages.count + messages.count))
        let indexPaths = (start ..< end).map { return IndexPath(row: $0, section: 0)}
        
        self.messages.append(contentsOf: messages)
        self.tableView.insertRows(at: indexPaths, with: .fade)
        
        UIView.animate(withDuration: 0.25) {
            self.scrollTable()
        }
    }
    
    fileprivate func scrollTableAnimated() {
        guard self.messages.count > 0 else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: false)
            }
        }
    }
    
    func scrollTable() {
        guard self.messages.count > 0 else { return }
        self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: false)
    }
    
    @objc func tableTapped() {
        self.endEditing(false)
    }
    
    @objc func keyboardWillHide(_ sender: NSNotification) {
        self.allowKeyboardWillSHow = false
        self.textViewBottom.constant = 0
        if UIDevice.isXFamily {
            self.textView.txvBottom.constant = -(12 + 20)
        }
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollTable()
            self.layoutIfNeeded()
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.allowKeyboardWillSHow = true
            })
        }
    }
    
    @objc func keyboardWillShow(_ sender: NSNotification) {
        guard self.allowKeyboardWillSHow else { return }
        guard let userInfo = sender.userInfo, let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, duration == 0.25, let keyboardHeight = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        self.keyboardHeight = keyboardHeight.cgRectValue.size.height
        self.textViewBottom.constant = -(self.keyboardHeight ?? 0)
        if UIDevice.isXFamily {
            self.textView.txvBottom.constant = -12
        }
        UIView.animate(withDuration: duration, animations: {
            self.superview?.layoutIfNeeded()
            self.layoutIfNeeded()
            self.scrollTable()
        }) { _ in
            
        }
        
    }
    
}

// MARK: - TableView DataSource

extension ChatTableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = self.messages[indexPath.row]
        if message.isFromCurrentUser {
            let cell = tableView.dequeueReusableCell(withIdentifier: kCurrentUserCell, for: indexPath) as! CurrentUserCell
            cell.settings = self.settings.currentUserSettings
            cell.message = self.messages[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kOtherUserCell, for: indexPath) as! OtherUsersCell
            cell.settings = self.settings.otherUsersSettings
            cell.message = self.messages[indexPath.row]
            return cell
        }
    }
    
}

// MARK: - ChatTableView Delegate

extension ChatTableView: InputViewDelegate {
    
    func sendPressed(newMessage: MessageViewModel) {
        self.delegate?.newMessageCreated(self, message: newMessage)
    }
}
