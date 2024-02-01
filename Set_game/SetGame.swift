//
//  SetGame.swift
//  Set_game
//
//  Created by Anastasia Lulakova on 31.01.2024.
//

import Foundation
import SwiftUI

struct SetGame {
    
    private(set) var cards: Array<Card>
    private var content: Array<CardContent>
    
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
        cards = []
        content = []
        CreateCardsContent()
        for numberOnCard in content.indices{
            cards.append(Card(id: numberOnCard, content: content[numberOnCard]))    
        }
        cards.shuffle()
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
    
     mutating func startNewGame(){
         cards.shuffle()
         cards.indices.forEach {
             cards[$0].isShown = ($0 < 12)
             cards[$0].isChosen = false
             cards[$0].isMatched = false
         }
    }
    
    mutating func addThreeMoreCards(addingIndexes: Array<Int> = []){
        if cards.contains(where: {!$0.isShown}) {
            var count = 0
            while count < 3 {
                let randomIndex = Int.random(in: cards.indices)
                if !cards[randomIndex].isShown {
                    cards[randomIndex].isShown.toggle()
                    if addingIndexes.count > 0 {
                        cards.insert(cards[randomIndex], at: addingIndexes[count])
                    }
                    count += 1
                }
            }
        }
    }
    
    func GetNotShownCard() -> Card? {
        if cards.contains(where: {!$0.isShown}) {
            while true {
                let randomIndex = Int.random(in: cards.indices)
                if !cards[randomIndex].isShown {
                    return cards[randomIndex]
                }
            }
        }
        return nil
    }
    
    mutating func addOneMoreCard(at index: Int) {
        if cards.contains(where: {!$0.isShown}) {
            if cards.indices.contains(index) {
                while true {
                    let randomIndex = Int.random(in: cards.indices)
                    if !cards[randomIndex].isShown {
                        var selectedCard = cards[randomIndex]
                        selectedCard.isShown = true
                        cards.insert(selectedCard, at: index)
                        cards.remove(at: randomIndex)
                        return
                    }
                }
            }
        }
    }
    
    mutating func choose(card: Card) -> Bool? {
        if numberOfChosenCards < 3 {
            if let index = cards.firstIndex(where: {$0.id == card.id}){
                cards[index].isChosen.toggle()
                if numberOfChosenCards == 3 {
                    if checkForSet(){
                        chosenCards.forEach { card in
                            if let realCardIndex = cards.firstIndex(where: {$0.id == card.id}) {
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
                if let realCardIndex = cards.firstIndex(where: {$0.id == card.id}) {
                    if cards[realCardIndex].isMatched {
                        if let card = GetNotShownCard() {
                            cards[realCardIndex] = card
                            cards[realCardIndex].isShown = true
                            cards.removeAll(where: {$0 == card})
                        }else {
                            cards.remove(at: realCardIndex)
                        }
                    }else {
                        cards[realCardIndex].isChosen = false
                    }
                }
            }
            if let index = cards.firstIndex(where: {$0.id == card.id}){
                cards[index].isChosen.toggle()
            }
//            if addingIndexes.count > 0 {
//                addThreeMoreCards(addingIndexes: addingIndexes)
//            }
        }
        return nil
    }
    
    func checkForSet() -> Bool{
        var numbers : Set<Int>  = []
        var shapes : Set<CardContent.Shape> = []
        var shadings : Set<CardContent.Shading>  = []
        var colors : Set<CardContent.ShapeColor>  = []
        chosenCards.forEach{
            numbers.insert($0.content.numberOfShapes.numOfShapes)
            shapes.insert($0.content.shape)
            shadings.insert($0.content.shading)
            colors.insert($0.content.color)
        }
        return numbers.count != 2 && shapes.count != 2 && shadings.count != 2 && colors.count != 2
        }
    
}

struct Card : Equatable, Identifiable{
    
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
