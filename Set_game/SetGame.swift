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
}

struct Card : Equatable, Identifiable{
    
    let id: Int
    let content: CardContent
    var isChosen: Bool = false
    var isMatched: Bool = false
    
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
