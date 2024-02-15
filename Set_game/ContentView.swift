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
                
                VStack {
                    newGameButton
                    
                    shuffleButton
                }
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
    
    
    var shuffleButton : some View {
        Button {
            viewModel.shuffle()
        } label: {
            Text("Shuffle")
        }

    }
    
     func choose(_ card: Card){
        let duration : TimeInterval = viewModel.isSetSelected && viewModel.isSetMatched ? 0.5 : 0
       withAnimation(.easeInOut(duration: duration))
       {
           if viewModel.isSetSelected && viewModel.isSetMatched {
               for card in viewModel.cards{
                   if card.isChosen{
                       chosenMatchedCards.append(card)
                   }
               }
               discard()
           }
           viewModel.choose(card: card)
       }
   }
    
    @State private var chosenMatchedCards: Array<Card> = []
     
    
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
                   //.offset(x: 0, y: CGFloat(card.id)/4 * -1)
            }
                RoundedRectangle(cornerRadius: 12)
                .opacity(dealtCards.count < 81 ? 1 : 0)
                
        }
        
        .frame(width: 100, height: 100/aspectRatio)
        .onTapGesture {
            dealCards()
        }
    }
    
    
    private func dealCards(){
            if dealtCards.count > 0 {
                if viewModel.isSetSelected && viewModel.isSetMatched {
                    for card in viewModel.cards{
                        if card.isChosen{
                            chosenMatchedCards.append(card)
                        }
                    }
                        discard()
                    withAnimation (.linear(duration: 1.5).delay(5)) {
                        viewModel.addThreeMoreCards(replace: true)
                    }
                    withAnimation (.easeInOut(duration: 0.5)) {
                        deal()
                        return
                    }
                }else{
                    viewModel.addThreeMoreCards(replace: false)
                }
            }
            deal()
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
           for card in chosenMatchedCards{
                    withAnimation(.easeInOut(duration: 0.1)){
                        discardedCards.append(card)
                    }
           }
        chosenMatchedCards.removeAll()
    }
    
    var newGameButton : some View {
        Button(action: {
            viewModel.startNewGame()
            dealtCards.removeAll()
            discardedCards.removeAll()
            
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
    
    var strokeColor: Color {
        if card.isChosen {
            if card.isMatched {
                return .cyan
            }
            else if mismatch != nil {
                return .pink
            }
            return .orange
        }
        return .black
    }
    
    
    @ViewBuilder
    var body: some View {
        ZStack {
            cardBase
            cardContent
        }
        .animation(.easeOut(duration: 0.3))
        
    }
    

    var cardBase: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            base.foregroundColor(.white)
            base.strokeBorder(.black, lineWidth: 2)
                .overlay {
                    let strokeBase =                         base.strokeBorder(strokeColor, lineWidth: 2)

                    if card.isChosen && (card.isMatched || mismatch != nil){
                        strokeBase
                            .transition(.asymmetric(insertion: .scale(scale: 0.5).animation(.easeIn(duration: 0.3)), removal: .identity) )
                    }else{
                        strokeBase
                    }
                }
        }
    }
    
    var cardContent: some View {
        HStack {
            let numberOfShapes: Int = card.content.numberOfShapes.numOfShapes

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
            .aspectRatio(2/3, contentMode: .fit)
            .opacity(card.content.shading == CardContent.Shading.striped ? 0.3 : 1)
        }
        .padding()
    }
    
    var diamond: some View {
        ZStack {
            let base = Diamond()
            if card.content.shading == CardContent.Shading.open {
                base.foregroundColor(.white)
                base.stroke(shapeColor, style: StrokeStyle(lineWidth: 2))
            }else{
                base.foregroundColor(shapeColor)
            }
        }
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
    }
    
    var oval: some View{
        ZStack {
            if card.content.shading == CardContent.Shading.open {
                Ellipse().foregroundColor(.white)
                Ellipse().stroke(shapeColor, style: StrokeStyle(lineWidth: 2))
            }else{
                Ellipse().foregroundColor(shapeColor)
            }
        }
    }
    
    
}

#Preview {
    ContentView(viewModel: SetGameVM())
}
