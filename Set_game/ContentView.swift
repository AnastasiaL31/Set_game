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
        }
        .padding()
    }
    
    var cards: some View {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150, maximum: 150))]) {
                ForEach(viewModel.cards.indices, id: \.self){ index in
                    CardView(card: viewModel.cards[index])
                        .aspectRatio(3/2, contentMode: .fit)
                }
        }
           
    }

}


struct CardView:View {
    
    let card: Card
    var shapeColor : Color{
        card.content.color.shapeColor
    }
    
    var body: some View{
        VStack {
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                let numberOfShapes: Int = card.content.numberOfShapes.numOfShapes
                
                Group{
                    base.foregroundColor(.white)
                    base.strokeBorder(lineWidth: 2)
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
            Text("\(card.id)")
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
