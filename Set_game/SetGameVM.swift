//
//  SetGameVM.swift
//  Set_game
//
//  Created by Anastasia Lulakova on 31.01.2024.
//

import Foundation
import SwiftUI


class SetGameVM : ObservableObject{
    
    @Published private var setGame: SetGame = SetGame()
    
    var cards: Array<Card> {
        return setGame.cards
    }
    
    
}
