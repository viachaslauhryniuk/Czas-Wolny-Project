//
//  CzasWolnyApp.swift
//  CzasWolny
//
//  Created by Слава Гринюк on 14.03.24.
//
import Firebase
import SwiftUI

@main
struct CzasWolnyApp: App {
    init(){
            FirebaseApp.configure()
        }

    var body: some Scene {
        WindowGroup {
            EnterView()
        }
    }
}
