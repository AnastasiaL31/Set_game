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
        return setGame.cards.filter { card in
            card.isShown == true
        }
    }
    
    var isSetSelected = false
    var isSetMatched = false
    
    func startNewGame(){
        setGame.startNewGame()
    }
    
    func addThreeMoreCards(){
        //check for sets
        
        setGame.addThreeMoreCards()
    }
    
    
    func choose(card: Card){
        if let match = setGame.choose(card: card){
            isSetSelected = true
            isSetMatched = match
        }else {
            isSetSelected = false
            isSetMatched = false
        }
    }
}
