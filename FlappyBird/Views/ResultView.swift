//
//  ResultView.swift
//  FlappyBird
//
//  Created by Ilnur on 16.11.2023.
//

import SwiftUI

struct ResultView: View {
    let score: Int
    let highScore: Int
    let resetAction: () -> Void
    
    var body: some View {
        VStack {
            Text("Game over")
                .font(.largeTitle)
                .padding()
            Text("Score \(score)")
                .font(.title)
            Text("BEST: \(highScore)")
                .padding()
            Button("RESET", action: resetAction)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
                .padding()
        }
        .background(.white.opacity(0.8))
        .cornerRadius(20)
        .padding()
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultView(score: 5, highScore: 8, resetAction: {})
    }
}
