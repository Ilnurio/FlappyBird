//
//  ContentView.swift
//  FlappyBird
//
//  Created by Ilnur on 15.11.2023.
//

import SwiftUI

enum GameState {
    case ready, active, stopped
}

struct GameView: View {
    @State private var birdVelocity = CGVector(dx: 0, dy: 0)
    @State private var birdPosition = CGPoint(x: 100, y: 300)
    
    @State private var pipeOffset: CGFloat = 0
    @State private var topPipeHeight = CGFloat.random(in: 100...500)
    
    @State private var scores = 0
    @State private var lastUpdateTime = Date()
    @State private var gameState: GameState = .ready
    
    private var birdSize: CGFloat = 80
    private let birdRadius: CGFloat = 13
    
    private let pipeWidth: CGFloat = 100
    private let pipeSpacing: CGFloat = 100
    private let jumpVelocity = -400
    private let gravity: CGFloat = 1000
    private let pipePosition: CGFloat = 300
    private let groundHeight: CGFloat = 100
    
    private let highScore = 0
    
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
                    
                    if gameState == .ready {
                        Button(action: playButtonAction) {
                            Image(systemName: "play.fill")
                                .font(Font.system(size: 60))
                                .foregroundStyle(.white)
                        }
                    }
                    
                    if gameState == .stopped {
                        ResultView(score: scores, highScore: highScore) {
                            resetGame()
                        }
                    }
                }
                .onTapGesture {
                    // устанавливаем вертикальную скорость вверх
                    birdVelocity = CGVector(dx: 0, dy: jumpVelocity)
                }
                .onReceive(timer) { currentTime in
                    guard gameState == .active else { return }
                    let deltaTime = currentTime.timeIntervalSince(lastUpdateTime)
                    
                    applyGravity(deltaTime: deltaTime)
                    updateBirdPosition(deltaTime: deltaTime)
                    checkBoudaries(geometry: geometry)
                    updatePipePosition(deltaTime: deltaTime)
                    resetPipePositioIfNeeded(geometry: geometry)
                    
                    if checkCollisions(geometry: geometry) {
                        gameState = .stopped
                    }
                    
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
    
    private func playButtonAction() {
        gameState = .active
        lastUpdateTime = Date()
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
            gameState = .stopped
        }
        
        // Проверка, не достигла ли птицв грунта
        if birdPosition.y > geometry.size.height - groundHeight {
            birdPosition.y = geometry.size.height - groundHeight
            birdVelocity.dy = 0
            gameState = .stopped
        }
    }
    
    private func checkCollisions(geometry: GeometryProxy) -> Bool {
        // Создаем прямоугольник вокруг птицы
        let birdFrame = CGRect(
            x: birdPosition.x - birdRadius / 2,
            y: birdPosition.y - birdRadius / 2,
            width: birdRadius,
            height: birdRadius
        )
        
        // Создаем прямоугольник вокруг верхнего столба
        let topPipeFrame = CGRect(
            x: geometry.size.width + pipeOffset,
            y: 0,
            width: pipeWidth,
            height: topPipeHeight
        )
        
        // Создаем прямоугольник вокруг нижнего столба
        let bottomPipeFrame = CGRect(
            x: geometry.size.width + pipeOffset,
            y: topPipeHeight + pipeSpacing,
            width: pipeWidth,
            height: topPipeHeight
        )
        
        return birdFrame.intersects(topPipeFrame)
                    || birdFrame.intersects(bottomPipeFrame)
    }
    
    private func updatePipePosition(deltaTime: TimeInterval) {
        pipeOffset -= CGFloat(pipePosition * deltaTime)
    }
    
    private func resetPipePositioIfNeeded(geometry: GeometryProxy) {
        if pipeOffset <= -geometry.size.width - pipeWidth {
            pipeOffset = 0
            topPipeHeight = CGFloat.random(in: 100...500)
        }
    }
    
    private func resetGame() {
        birdPosition = CGPoint(x: 100, y: 300)
        birdVelocity = CGVector(dx: 0, dy: 0)
        pipeOffset = 0
        topPipeHeight = CGFloat.random(in: 100...500)
        scores = 0
        gameState = .ready
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
