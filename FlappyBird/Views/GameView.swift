//
//  ContentView.swift
//  FlappyBird
//
//  Created by Ilnur on 15.11.2023.
//

import SwiftUI

struct GameView: View {
    private var birdSize: CGFloat = 80
    private let birdPosition = CGPoint(x: 100, y: 300)
    private let topPipeHeight = CGFloat.random(in: 100...500)
    private let pipeWidth: CGFloat = 100
    private let pipeSpacing: CGFloat = 100
    private let pipeOffset: CGFloat = 0
    private let scores = 0
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack {
                    Image("flappyBirdBackground")
                        .resizable()
                        .ignoresSafeArea()
                        .padding(
                            EdgeInsets(
                                top: 0,
                                leading: 0,
                                bottom: -50,
                                trailing: -30
                            )
                        )
                    
                    BirdView(birdSize: birdSize)
                        .position(birdPosition)
                    
                    PipeView(
                        topPipeHeight: topPipeHeight,
                        pipeWidth: pipeWidth,
                        pipeSpacing: pipeSpacing
                    )
                    .offset(x: geometry.size.width + pipeOffset)
                }
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Text(scores.formatted())
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding()
                    }
                }
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
