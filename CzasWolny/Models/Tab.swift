//
//  Tab.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 28.03.24.
//

import Foundation
enum Tab: String, CaseIterable {
    case deadlines = "Terminy"
    case groups = "Grupy"
    case schedule = "Rozkład zajęć"
    
    
    var systemImage:String {
        switch self {
            
        case .deadlines:
            return "calendar"
        case .groups:
            return "person.3.fill"
        case .schedule:
            return "book.fill"
            
        }
    }
        
        var index:Int {
            return Tab.allCases.firstIndex(of: self) ?? 0
        }
    }

