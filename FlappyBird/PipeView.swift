//
//  PipeView.swift
//  FlappyBird
//
//  Created by Ilnur on 15.11.2023.
//

import SwiftUI

struct PipeView: View {
    let topPipeHeight: CGFloat
    let pipeWidth: CGFloat
    let pipeSpacing: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let availableHeight = geometry.size.height - pipeSpacing
            let bottomPipeHeight = availableHeight - topPipeHeight
            
            VStack {
                Image("flappeBirdPipe")
                    .resizable()
                    .rotationEffect(.degrees(180))
                    .frame(width: pipeWidth, height: topPipeHeight)
                
                Spacer()
                    .frame(height: pipeSpacing)
                
                Image("flappeBirdPipe")
                    .resizable()
                    .frame(width: pipeWidth, height: bottomPipeHeight)
            }
        }
    }
}

struct PipeView_Previews: PreviewProvider {
    static var previews: some View {
        PipeView(topPipeHeight: 300, pipeWidth: 100, pipeSpacing: 100)
    }
}
