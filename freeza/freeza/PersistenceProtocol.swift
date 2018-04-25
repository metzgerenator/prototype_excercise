//
//  PersistenceProtocol.swift
//  freeza
//
//  Created by Michael Metzger  on 4/25/18.
//  Copyright © 2018 Zerously. All rights reserved.
//

import Foundation

protocol SaveToDiskDelegate {
    
}

extension SaveToDiskDelegate {
    func saveStringArraytoUserDefaults(array: [String]) {
        let defaults = UserDefaults.standard
        
        defaults.removeObject(forKey: "savedTitles")
        if !array.isEmpty {
            defaults.set(array, forKey: "savedTitles")
        }

    }
}


protocol RetriveFromDiskDataSource  {
 
}

extension RetriveFromDiskDataSource {
    
    func retriveTitlesFromDefaults() -> [String] {
        let defaults = UserDefaults.standard
        return defaults.stringArray(forKey: "savedTitles") ?? [String]()
    }
    
}
