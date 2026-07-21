//
//  StringExtension.swift
//  MiniFlix
//
//  Created by Tuong Vi on 20/7/26.
//

import Foundation

extension String{
    var toDate: Date?{
        try? Date(self,
                  strategy: Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits)", timeZone: .gmt))
    }
}
