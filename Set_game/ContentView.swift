//
//  ContentView.swift
//  Set_game
//
//  Created by Anastasia Lulakova on 30.01.2024.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: SetGameVM
    private let aspectRatio : CGFloat = 3/2
    private let dealAnimation: Animation = .easeInOut(duration: 0.5)
    
    
    var body: some View {
        VStack{
                cards
            HStack{
                discardPile
                Spacer()
                deck.foregroundColor(.blue)
                Spacer()
                NewGameButton
            }
            .font(.title2)
        }
        .padding()
    }
    
    var cards: some View {
       AspectVGrid(viewModel.cards, aspectRatio: aspectRatio){ card in
            if isDealt(card){
                CardView(card: card, mismatch: (viewModel.isSetSelected && !viewModel.isSetMatched) ? true : nil)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .onTapGesture {
                        choose(card)
                        }
                    .padding(4)
                    }
                    
            }
        }
    
    func choose(_ card: Card){
       var delay: TimeInterval = viewModel.isSetSelected && viewModel.isSetMatched ? 0.2 : 0
       var duration : TimeInterval = viewModel.isSetSelected && viewModel.isSetMatched ? 0.5 : 0
       withAnimation(.easeInOut(duration: duration).delay(delay))
       {
           discard()
           viewModel.choose(card: card)
       }
   }
    
   
     
    
    @Namespace private var dealingNamespace
    
    @State private var dealtCards = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealtCards.contains(card.id)
    }
    
    private var undealtCards : [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
  
    
    var deck : some View {
        ZStack {
            ForEach(undealtCards) { card in
                    CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
                RoundedRectangle(cornerRadius: 12)
                .opacity(dealtCards.count < 81 ? 1 : 0)
        }
        
        .frame(width: 100, height: 100/aspectRatio)
        .onTapGesture {
            if dealtCards.count > 0 {
                viewModel.addThreeMoreCards()
            }
            deal()
        }
    }
    
    private func deal(){
        var timeInterval: TimeInterval = 0
        for card in undealtCards {
            if card.isShown {
                withAnimation(.easeOut(duration: 0.5).delay(timeInterval)){
                    _ = dealtCards.insert(card.id)
                }
                timeInterval += 0.15
            }
        }
    }
    
    @Namespace private var discardNamespace
    
    @State private var discardedCards = [Card]()
    
    var discardPile: some View {
        ZStack {
            ForEach(discardedCards) { card in
                    CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
            }
           
        }
        .frame(width: 100, height: 100/aspectRatio)
    }
    
    
    private func discard() {
        var delay: TimeInterval = 0
        if viewModel.isSetSelected && viewModel.isSetMatched {
            for card in viewModel.cards{
                if card.isChosen{
                    withAnimation(.easeOut(duration: 0.5).delay(delay)){
                        discardedCards.append(card)
                    }
                    delay += 0.25
                }
            }
        }
    }
    
    var NewGameButton : some View {
        Button(action: {
            viewModel.startNewGame()
            dealtCards.removeAll()
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
