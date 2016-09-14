//
//  Authentication.swift
//  MusicApp
//
//  Created by HungDo on 8/28/16.
//  Copyright © 2016 HungDo. All rights reserved.
//

import Foundation

class Authentication {
    
    fileprivate init() { }
    
    fileprivate var sessionUsername: String? {
        return self.userDefault.value(forKey: UserInfo.username) as? String
    }
    
    fileprivate var sessionPassword: String? {
        return self.userDefault.value(forKey: UserInfo.password) as? String
    }
    
    fileprivate let userDefault = UserDefaults.standard
    
    fileprivate struct UserInfo {
        static let username = "username"
        static let password = "password"
    }
    
    static let sharedAuthentication = Authentication()
    
    var username: String?
    var password: String?
    
    var validated: Bool {
        guard let username = sessionUsername else { return false }
        guard let password = sessionPassword else { return false }
        
        return self.username == username && self.password == password
    }
    
    func login(_ username: String?, password: String?) -> Bool {
        
        func loginWithoutUserInfo() -> Bool {
            return validated
        }
        
        func loginWithUserInfo(username: String, password: String) -> Bool {
            self.username = username
            self.password = password
            return loginWithoutUserInfo()
        }
        
        if username == nil && password == nil       { return loginWithoutUserInfo() }
        else if username == nil || password == nil  { return false }
        else                                        { return loginWithUserInfo(username: username!, password: password!) }
    }
    
    func logout() -> Bool {
        guard let _ = username, let _ = password else { return false }
        self.username = nil
        self.password = nil
        return true
    }
    
    func register(_ username: String?, password: String?) -> Bool {
        guard let username = username, let password = password else { return false }
        self.userDefault.setValue(username, forKey: UserInfo.username)
        self.userDefault.setValue(password, forKey: UserInfo.password)
        self.userDefault.synchronize()
        return self.login(username, password: password)
    }
    
    func unregister() -> Bool {
        if sessionUsername == nil && sessionPassword == nil { return false }
        self.userDefault.setValue(nil, forKey: UserInfo.username)
        self.userDefault.setValue(nil, forKey: UserInfo.password)
        self.userDefault.synchronize()
        return self.logout()
    }
    
}
