//
//  UserDefaultsManager.swift
//  Siroo
//
//  Created by jeongbae bang on 2/12/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    func save<T: Encodable>(_ object: T, to key: String) {
        if let encoded = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    func load<T: Decodable>(type: T.Type, from key: String) -> T? {
        if let savedData = UserDefaults.standard.data(forKey: key),
           let decodedObject = try? JSONDecoder().decode(T.self, from: savedData) {
            
            return decodedObject
        }
        
        return nil
    }
}
