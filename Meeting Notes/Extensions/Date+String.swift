//
//  Date+String.swift
//  Meeting Notes
//
//  Created by Rumin Shah on 6/22/20.
//  Copyright © 2020 Rumin Shah. All rights reserved.
//

import Foundation

extension Date {
    var customDate: String {
        let date = Formatter.customGet.string(from: self)
        if let tempDate = Formatter.customGet.date(from: date) {
            let customDate = Formatter.customPrint.string(from: tempDate)
            return customDate
        }
        
        return ""
    }
}
