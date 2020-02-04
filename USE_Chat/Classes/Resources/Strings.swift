//
//  Strings.swift
//  USE_Chat
//
//  Created by Usemobile on 27/03/19.
//

import Foundation

extension String {
    
    static var typeHere: String {
        switch currentLanguage {
        case .en:
            return "Type here..."
        case .pt:
            return "Digite Aqui..."
        }
        
    }
    
    static var fail: String {
        switch currentLanguage {
        case .en:
            return "FAIL"
        case .pt:
            return "FALHOU"
        }
        
    }
    
//    static var model: String {
//        switch currentLanguage {
//        case .en:
//            return ""
//        case .pt:
//            return ""
//        }
//
//    }
    
}
