//
//  ContentView.swift
//  Set_game
//
//  Created by Anastasia Lulakova on 30.01.2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: SetGameVM
    var body: some View {
        VStack{
            ScrollView{
                cards
            }
            
            HStack{
                AddCardsButton
                Spacer()
                NewGameButton
            }
            .font(.title2)
        }
        .padding()
    }
    
    var cards: some View {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 150))]) {
                ForEach(viewModel.cards){ card in
                    if viewModel.isSetSelected && !viewModel.isSetMatched {
                        CardView(card: card, mismatch: true)
                            .aspectRatio(3/2, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card: card)
                            }
                    }else {
                        CardView(card: card)
                            .aspectRatio(3/2, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card: card)
                            }
                    }
                }
        }
    }
    
    var AddCardsButton : some View {
        Button(action: {
            viewModel.addThreeMoreCards()
        }, label: {
            Text("Add 3 cards")
        })
    }

    var NewGameButton : some View {
        Button(action: {
            viewModel.startNewGame()
        }, label: {
            Text("New Game")
        })
    }
}


struct CardView:View {
    
    let card: Card
    var shapeColor : Color{
        card.content.color.shapeColor
    }
    var mismatch: Bool?
    
    var body: some View{
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                let numberOfShapes: Int = card.content.numberOfShapes.numOfShapes
                
                Group{
                    base.foregroundColor(.white)
                    base.strokeBorder((card.isChosen ? .orange : .black), lineWidth: 2)
                    if card.isChosen && card.isMatched {
                        base.strokeBorder(.cyan, lineWidth: 3)
                    }else if card.isChosen {
                        if mismatch != nil {
                            base.strokeBorder(.pink, lineWidth: 3)
                        }
                    }
                        
                    HStack {
                        ForEach((1...numberOfShapes), id: \.self){ index in
                            switch card.content.shape {
                            case .diamond:
                                diamond
                            case .squiggle:
                                squiggle
                            case .oval:
                                oval
                            }
                        }
                    }
                    
                    .padding()
                    
                }
        }
    }
    
    var diamond: some View {
        ZStack {
            if card.content.shading == CardContent.Shading.open {
                Diamond()
                    .foregroundColor(.white)
                Diamond()
                    .stroke(shapeColor, style: StrokeStyle(lineWidth: 2))
            }else{
                Diamond()
                    .foregroundColor(shapeColor)
            }
               
        }
        .aspectRatio(2/3, contentMode: .fit)
        .opacity(card.content.shading == CardContent.Shading.striped ? 0.3 : 1)
    }
    
    var squiggle: some View {
        ZStack{
            Squiggle()
                .stroke(shapeColor, style: StrokeStyle(lineWidth: 23, lineCap: .round))
            if card.content.shading == CardContent.Shading.open {
                Squiggle()
                    .stroke(.white, style: StrokeStyle(lineWidth: 20, lineCap: .round))
            }
        }
        .aspectRatio(2/3, contentMode: .fit)
        .opacity(card.content.shading == CardContent.Shading.striped ? 0.3 : 1)
    }
    
    var oval: some View{
        ZStack {
            if card.content.shading == CardContent.Shading.open {
                Ellipse()
                    .foregroundColor(.white)
                Ellipse()
                    .stroke(shapeColor, style: StrokeStyle(lineWidth: 2))
            }else{
                Ellipse()
                    .foregroundColor(shapeColor)
            }
                
        }
        .aspectRatio(2/3, contentMode: .fit)
        .opacity(card.content.shading == CardContent.Shading.striped ? 0.3 : 1)
    }
}

#Preview {
    ContentView(viewModel: SetGameVM())
}
