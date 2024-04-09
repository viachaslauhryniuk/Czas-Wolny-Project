//
//  EnterViewModel.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 8.04.24.
//

import Foundation
final class EnterViewModel: ObservableObject{
    
    @Published var showLogRegView = false
    @Published var nextView: ViewStack = .login
    
}
