//
//  PersistenceProtocol.swift
//  freeza
//
//  Created by Michael Metzger  on 4/25/18.
//  Copyright © 2018 Zerously. All rights reserved.
//

import Foundation

protocol saveToDisDelegate {
    
}

extension saveToDisDelegate {
    func saveStringArraytoUserDefaults(array: [String]) {
        let defaults = UserDefaults.standard
        defaults.set(array, forKey: "savedTitles")
        
    }
}


protocol retriveFromDiskDataSource  {
 
}

extension retriveFromDiskDataSource {
    
    func retriveTitlesFromDefaults() -> [String] {
        let defaults = UserDefaults.standard
        return defaults.stringArray(forKey: "savedTitles") ?? [String]()
    }
    
}
