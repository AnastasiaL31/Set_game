//
//  SetGame.swift
//  Set_game
//
//  Created by Anastasia Lulakova on 31.01.2024.
//

import Foundation
import SwiftUI

struct SetGame {
    
    private(set) var cards: Array<Card> = []
    private var content: Array<CardContent> = []
    
    private var numberOfChosenCards: Int {
        get{
           chosenCards.count
        }
    }
    
    private var chosenCards: Array<Card> {
        get {
            cards.filter({$0.isChosen})
        }
    }
    
    init() {
        createCards()
        
    }
    
    private mutating func CreateCardsContent(){
        for color in CardContent.ShapeColor.allCases{
            for shape in CardContent.Shape.allCases{
                for shading in CardContent.Shading.allCases{
                    for numberOfShapes in CardContent.NumberOfShapes.allCases{
                        content.append(CardContent(numberOfShapes: numberOfShapes, shape: shape, shading: shading, color: color))
                    }
                }
            }
        }
    }
    
    
    private mutating func createCards(){
        cards.removeAll()
        content.removeAll()
        CreateCardsContent()
        for numberOnCard in content.indices{
            cards.append(Card(id: numberOnCard, content: content[numberOnCard]))
        }
        cards.shuffle()
        for num in 0..<12 {
            cards[num].isShown = true
        }
    }
    
    // MARK: - add creation of new cards (previous were deleted)
    
     mutating func startNewGame(){
         createCards()
    }
    
    mutating func addThreeMoreCards(){
        if cards.contains(where: {!$0.isShown}) {
            var count = 0
            while count < 3 {
                if let cardWithIndexToAdd = cards.firstIndex(where: {!$0.isShown}){
                    cards[cardWithIndexToAdd].isShown.toggle()
                    count += 1
                } else {
                    return
                }
            }
        }
    }
    
    mutating func addAndReplaceThreeMoreCards(){
        let replacingIndexes = getChosenMatchedCards()
        if replacingIndexes.count == 3 {
            if cards.contains(where: {!$0.isShown}) {
                var count = 0
                while count < 3 {
                    if let cardIndexToAdd = cards.firstIndex(where: {!$0.isShown}){
                        var card = cards[cardIndexToAdd]
                        card.isShown.toggle()
                        cards[replacingIndexes[count]] = card
                        cards.remove(at: cardIndexToAdd)
                        count += 1
                    } else {
                        return
                    }
                }
            }
        }
    }
    
    func getChosenMatchedCards() -> Array<Int> {
        cards.filter { $0.isChosen && $0.isMatched && $0.isShown}.map{cards.firstIndex(of: $0) ?? -1}
    }
    
    
    mutating func choose(card: Card) -> Bool? {
        if numberOfChosenCards < 3 {
            if let index = cards.findCardIndex(card: card){
                cards[index].isChosen.toggle()
                if numberOfChosenCards == 3 {
                    if checkForSet(){
                        chosenCards.forEach { card in
                            if let realCardIndex = cards.findCardIndex(card: card) {
                                cards[realCardIndex].isMatched = true
                            }
                        }
                        return true
                    } else {
                        return false
                    }
                }
            }
        } else {
            chosenCards.forEach { card in
                if let realCardIndex = cards.findCardIndex(card: card) {
                    if cards[realCardIndex].isMatched {
                            cards.remove(at: realCardIndex)
                    }else {
                        cards[realCardIndex].isChosen = false
                    }
                }
            }
            if let index = cards.findCardIndex(card: card){
                cards[index].isChosen.toggle()
            }
        }
        return nil
    }
    
    func checkForSet() -> Bool{
        
        let colors = Set(chosenCards.map({ $0.content.color}))
        let numbers = Set(chosenCards.map({ $0.content.numberOfShapes}))
        let shapes = Set(chosenCards.map({ $0.content.shape}))
        let shadings = Set(chosenCards.map({ $0.content.shading}))
        return numbers.count != 2 && shapes.count != 2 && shadings.count != 2 && colors.count != 2
        }
    
}

struct Card : Equatable, Identifiable {
    
    let id: Int
    let content: CardContent
    var isChosen = false
    var isMatched = false
    var isShown = false
}

struct CardContent : Equatable, CustomDebugStringConvertible{
    
    enum ShapeColor: CaseIterable {
        var shapeColor: Color{
            switch self {
            case .red:
                Color.red
            case .green:
                Color.green
            case .purple:
                Color.purple
            }
        }
        
        case red, green, purple
    }
    
    enum Shape: CaseIterable {
        case diamond, squiggle, oval
    }
    
    enum Shading: CaseIterable {
        case solid, striped, open
    }
    
    enum NumberOfShapes : CaseIterable {
        var numOfShapes: Int{
            switch self {
            case .one:
                1
            case .two:
                2
            case .three:
                3
            }
        }
        
        case one, two, three
    }
    
    let numberOfShapes: NumberOfShapes
    let shape: Shape
    let shading: Shading
    let color: ShapeColor
    
    init(numberOfShapes: NumberOfShapes, shape: Shape, shading: Shading, color: ShapeColor) {
        self.numberOfShapes = numberOfShapes
        self.shape = shape
        self.shading = shading
        self.color = color
    }
    
    var debugDescription: String{
        var color = ""
        var shape = ""
        var shading = ""
        switch self.color {
        case .green:
            color = "🟢"
        case .red:
            color = "🔴"
        case .purple:
            color = "🟣"
        }
        
        switch self.shape {
        case .diamond:
            shape = "♢"
        case .squiggle:
            shape = "⎰"
        case .oval:
            shape = "⚬"
        }
        
        switch self.shading {
        case .solid:
            shading = "solid"
        case .striped:
            shading = "striped"
        case .open:
            shading = "open"
        }
        let result = "shape: \(shape) \(color) \(shading) "
        switch self.numberOfShapes {
        case .one:
            return result + "1"
        case .two:
            return result + "2"
        case .three:
            return result + "3"
        }
    }
}


extension Array<Card> {
    
    func findCardIndex(card: Card) -> Int?{
         firstIndex(where: {$0.id == card.id})
    }
}
