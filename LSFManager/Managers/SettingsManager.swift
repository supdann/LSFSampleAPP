//
//  SettingsManager.swift
//  LSFManager
//
//  Created by Daniel Montano on 20.12.17.
//  Copyright © 2017 danielmontano. All rights reserved.
//

import Foundation

class SettingsManager {
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////           Singleton Class Implementation           /////////////
    //////////////////////////////////////////////////////////////////////////////
    static let sharedInstance = SettingsManager()
    
    private init(){
        loadFromUserDefaults()
    }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////               API Manager properties               /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    var address: String?
    var port: Int?
    
    var defaultUsername: String?
    var defaultPass: String?
    
    // Persistence
    
    private let address_key: String = "addresskey"
    private let port_key: String = "portkey"
    
    private let defaultUsernameKey = "defaultusernamekey"
    private let defaultPasswordKey = "defaultpasswordkey"
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////           SETTINGS MANAGER IMPLEMENTATION          /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    func clearUserSettings(){
        UserDefaults.standard.removeObject(forKey: self.address_key)
        UserDefaults.standard.removeObject(forKey: self.port_key)
    }
    
    func loadFromUserDefaults(){
        self.address = getUserSettingObject(self.address_key) as? String
        self.port = getUserSettingObject(self.port_key) as? Int
        
        self.defaultUsername = getUserSettingObject(self.defaultUsernameKey) as? String
        self.defaultPass = getUserSettingObject(self.defaultPasswordKey) as? String
    }
    
    func saveToUserDefaults() throws {
        
        if let address = self.address, let port = self.port  {
            setUserSetting(key: self.address_key, value: address)
            setUserSetting(key: self.port_key, value: port)
        }else{
            throw CustomErrors.serverSettingsNotSavedError
        }
        
        if let defaultUsername = self.defaultUsername, let defaultPass = self.defaultPass  {
            setUserSetting(key: self.defaultUsernameKey, value: defaultUsername)
            setUserSetting(key: self.defaultPasswordKey, value: defaultPass)
        }else{
            throw CustomErrors.userSettingsNotSavedError
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////
    /////////////                SOME HELPER METHODS                 /////////////
    //////////////////////////////////////////////////////////////////////////////
    
    func setUserSetting(key:String, value:Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getUserSettingObject(_ key:String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
}
