//
//  ChatViewController.swift
//  USE_Chat
//
//  Created by Usemobile on 06/03/19.
//

import UIKit

public protocol ChatViewControllerDelegate {
    func newMessageCreated(_ viewController: ChatViewController, message: MessageViewModel)
    func viewWillDisappear(_ viewController: ChatViewController)
}

public class ChatViewController: UIViewController {
    
    // MARK: - UI Components
    
    lazy var tableView: ChatTableView = {
        let view = ChatTableView(settings: self.settings, messages: self.messages)
        view.delegate = self
        return view
    }()
    
    var titleView: TitleView?
    let keyboardObserver = InputAccessoryView()
    
    // MARK: - Properties
    
    public var messages = [MessageViewModel]()
    public var delegate: ChatViewControllerDelegate?
    
    var settings: ChatSettings = .default
    var userModel: ChatUserViewModel
    
    public override var inputAccessoryView: UIView? {
        return keyboardObserver
    }
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Life Cycle
    
    required public init(userModel: ChatUserViewModel, messages: [MessageViewModel] = [], settings: ChatSettings = .default) {
        self.userModel = userModel
        self.messages = messages
        self.settings = settings
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.addTableView()
        self.keyboardObserver.constraintToUpdate = self.tableView.textViewBottom
        self.view.backgroundColor = .white
        self.titleView = TitleView(model: self.userModel, settings: self.settings.titleViewSettings)
        self.navigationItem.titleView = self.titleView
        self.titleView?.sizeToFit()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(false)
        self.delegate?.viewWillDisappear(self)
    }
    
    // MARK: - Setup
    
    fileprivate func addTableView() {
        self.view.addSubview(self.tableView)
        let isTranslucent = self.navigationController?.navigationBar.isTranslucent ?? true
        let padding: CGFloat = isTranslucent ? self.getSafeAreaTop() : 0
        if self.settings.checkIfNavBarIsTranslucent {
            self.tableView.fillSuperview(padding: UIEdgeInsets(top: padding, left: 0, bottom: 0, right: 0))
        } else {
            self.tableView.fillSuperview()
        }
    }
    
    public func setupMessages(_ messages: [MessageViewModel]) {
        self.tableView.setupMessages(messages)
    }
    
    public func insertMessages(_ messages: [MessageViewModel]) {
        self.tableView.insertMessages(messages)
    }
    
    private func getSafeAreaTop() -> CGFloat{
        if #available(iOS 11, *) {
            return self.view.safeAreaInsets.top
        } else {
            return UIApplication.shared.statusBarFrame.size.height + 44
        }
    }
    
}

// MARK: - ChatTable Delegate

extension ChatViewController: ChatTableViewDelegate {
    
    func newMessageCreated(_ tableView: ChatTableView, message: MessageViewModel) {
        self.delegate?.newMessageCreated(self, message: message)
    }
    
}
