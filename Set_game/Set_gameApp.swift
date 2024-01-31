//
//  Set_gameApp.swift
//  Set_game
//
//  Created by Anastasia Lulakova on 30.01.2024.
//

import SwiftUI

@main
struct Set_gameApp: App {
    @State var vm = SetGameVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: vm)
        }
    }
}
