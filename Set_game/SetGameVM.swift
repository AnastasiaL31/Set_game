//
//  SetGameVM.swift
//  Set_game
//
//  Created by Anastasia Lulakova on 31.01.2024.
//

import Foundation
import SwiftUI


class SetGameVM : ObservableObject{
    
    @Published private var setGame: SetGame
    
    var cards: Array<Card> {
        return setGame.cards.filter { card in
            card.isShown == true
        }
    }
    
    init(){
        setGame = SetGame()
    }
    
    var isSetSelected = false
    var isSetMatched = false
    
    func startNewGame(){
        setGame.startNewGame()
        isSetMatched = false
        isSetSelected = false
    }
    
    func shuffle(){
        setGame.shuffle()
    }
    
    func addThreeMoreCards(replace: Bool){
        if replace {
            if isSetSelected && isSetMatched{
                setGame.addAndReplaceThreeMoreCards()
                isSetSelected = false
                isSetMatched = false
            }
        }else if cards.count < 24 {
            setGame.addThreeMoreCards()
        }
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
