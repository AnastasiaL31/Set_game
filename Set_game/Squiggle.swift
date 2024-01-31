//
//  Squiggle.swift
//  Set_game
//
//  Created by Anastasia Lulakova on 31.01.2024.
//

import SwiftUI

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))

        path.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control1: CGPoint(x: rect.maxX, y: rect.midY), control2: CGPoint(x: rect.minX, y: rect.midY))
        return path
        
    }
    
    
}

#Preview {
    Squiggle()
}
