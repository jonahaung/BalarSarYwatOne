//
//  AppUtilities.swift
//  MyanmarTypo
//
//  Created by Aung Ko Min on 10/10/19.
//  Copyright © 2019 Aung Ko Min. All rights reserved.
//

import Foundation

class AppUtilities {
    
    static let dateFormatter_relative: RelativeDateTimeFormatter = {
        $0.dateTimeStyle = .named
        $0.unitsStyle = .short
        return $0
    }(RelativeDateTimeFormatter())
    
    static let dateFormatter: DateFormatter = {
        $0.dateStyle = .short
        $0.timeStyle = .none
        return $0
    }(DateFormatter())
    
}
