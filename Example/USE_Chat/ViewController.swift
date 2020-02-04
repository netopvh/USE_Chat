//
//  ViewController.swift
//  USE_Chat
//
//  Created by Tulio Parreiras on 03/06/2019.
//  Copyright (c) 2019 Tulio Parreiras. All rights reserved.
//

import UIKit
import USE_Chat

class ViewController: UIViewController {
    
    @IBAction func chatPressed(_ sender: Any) {
        self.presentChatVC()
    }
    
    lazy var language: ChatLanguage = {
        let languageCode = Locale.current.languageCode
        switch languageCode?.lowercased() {
        case "en":
            return .en
        default:
            return .pt
        }
    }()
    
    let userImage = "https://scontent.fcnf1-1.fna.fbcdn.net/v/t1.0-9/388816_211336025612084_1271640720_n.jpg?_nc_cat=109&_nc_ht=scontent.fcnf1-1.fna&oh=79edf8e91a78a7c3b47b00c8539c098a&oe=5D19B87B"
    
    func presentChatVC() {
        let messages = [
            MessageViewModel(message: "Olá", date: Date(), isFromCurrentUser: false),
            MessageViewModel(message: "Oi", date: Date(), isFromCurrentUser: true),
            MessageViewModel(message: "Tudo bem?", date: Date(), isFromCurrentUser: false),
            MessageViewModel(message: "Tudo e você?", date: Date(), isFromCurrentUser: true),
            MessageViewModel(message: "Ótimo", date: Date(), isFromCurrentUser: false),
            MessageViewModel(message: "Estou te esperando no local combinado", date: Date(), isFromCurrentUser: true),
            MessageViewModel(message: "Beleza já estou chegando", date: Date(), isFromCurrentUser: true)
//            ,
//            MessageViewModel(message: "Ouvi falar que blablablablbalbalbalbalbabalbalbalbalbalbalalbablablablalbalbalblalbalbablablablalbalbalblabablabalbalbalbla", date: Date(), isFromCurrentUser: false),
//            MessageViewModel(message: "Ouvi falar que blablablablbalbalbalbalbabalbalbalbalbalbalalbablablablalbalbalblalbalbablablablalbalbalblabablabalbalbalbla", date: Date(), isFromCurrentUser: true)
        ]
        let model = ChatUserViewModel(name: "Tulio", lastName: "de Oliveira Parreiras", imageUrl: self.userImage)
        
        let currentUserSettings = MessageCellSettings(backgroundColor: #colorLiteral(red: 0.08235294118, green: 0.4470588235, blue: 0.6196078431, alpha: 1), textColor: .white, textFont: .systemFont(ofSize: 14), dateFont: .systemFont(ofSize: 6))
        let otherUsersSettings = MessageCellSettings(backgroundColor: .white, textColor: .black, textFont: .systemFont(ofSize: 14), dateFont: .systemFont(ofSize: 6))
        let inputViewSettings = InputViewSettings(textFont: .systemFont(ofSize: 14), placeholderFont: .italicSystemFont(ofSize: 14), textColor: .black, placeholderColor: .gray, sendImage: UIImage(named: "sendIC"))
        let settings = ChatSettings(tableBackgroundImage: UIImage(named: "chatBG"), currentUserSettings: currentUserSettings, otherUsersSettings: otherUsersSettings, inputViewSettings: inputViewSettings)
        settings.language = self.language
        let chatVC = ChatViewController(userModel: model, messages: messages, settings: settings)
        chatVC.delegate = self
        self.navigationController?.pushViewController(chatVC, animated: true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = false
    }

}

extension ViewController: ChatViewControllerDelegate {
    
    func newMessageCreated(_ viewController: ChatViewController, message: MessageViewModel) {
        DispatchQueue.main.async {
            viewController.insertMessages([message])
        }
    }
    
    func viewWillDisappear(_ viewController: ChatViewController) {
        
    }
    
}

