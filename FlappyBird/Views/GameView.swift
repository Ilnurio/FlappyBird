//
//  ContentView.swift
//  FlappyBird
//
//  Created by Ilnur on 15.11.2023.
//

import SwiftUI

struct GameView: View {
    @State private var birdVelocity = CGVector(dx: 0, dy: 0)
    @State private var birdPosition = CGPoint(x: 100, y: 300)
    @State private var lastUpdateTime = Date()
    
    private var birdSize: CGFloat = 80
    
    private let topPipeHeight = CGFloat.random(in: 100...500)
    private let pipeWidth: CGFloat = 100
    private let pipeSpacing: CGFloat = 100
    private let pipeOffset: CGFloat = 0
    
    private let jumpVelocity = -400
    private let gravity: CGFloat = 1000
    private let groundHeight: CGFloat = 100
    private let scores = 0
    
    private let timer = Timer.publish(
        every: 0.01,
        on: .main,
        in: .common
    ).autoconnect()
    
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
                .onTapGesture {
                    // устанавливаем вертикальную скорость вверх
                    birdVelocity = CGVector(dx: 0, dy: jumpVelocity)
                }
                .onReceive(timer) { currentTime in
                    let deltaTime = currentTime.timeIntervalSince(lastUpdateTime)
                    
                    applyGravity(deltaTime: deltaTime)
                    updateBirdPosition(deltaTime: deltaTime)
                    checkBoudaries(geometry: geometry)
                    
                    lastUpdateTime = currentTime
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
    
    private func applyGravity(deltaTime: TimeInterval) {
        birdVelocity.dy += CGFloat(gravity * deltaTime)
    }
    
    private func updateBirdPosition(deltaTime: TimeInterval) {
        birdPosition.y += birdVelocity.dy * CGFloat(deltaTime)
    }
    
    private func checkBoudaries(geometry: GeometryProxy) {
        // Проверка, не достигла ли птица верха экрана
        if birdPosition.y <= 0 {
            birdPosition.y = 0
        }
        
        // Проверка, не достигла ли птицв грунта
        if birdPosition.y > geometry.size.height - groundHeight {
            birdPosition.y = geometry.size.height - groundHeight
            birdVelocity.dy = 0
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
