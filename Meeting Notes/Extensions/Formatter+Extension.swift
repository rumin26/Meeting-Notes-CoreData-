//
//  Formatter+Extension.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/22/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import Foundation

extension Formatter {
    static let customGet: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return formatter
    }()
    
    static let customPrint: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d h:mm a"
        return formatter
    }()
}
