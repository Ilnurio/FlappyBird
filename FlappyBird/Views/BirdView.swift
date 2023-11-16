//
//  BirdView.swift
//  FlappyBird
//
//  Created by Ilnur on 15.11.2023.
//

import SwiftUI

struct BirdView: View {
    let birdSize: CGFloat
    var body: some View {
        Image("flappyBird")
            .resizable()
            .scaledToFit()
            .frame(width: birdSize, height: birdSize)
    }
}

struct BirdView_Previews: PreviewProvider {
    static var previews: some View {
        BirdView(birdSize: 80)
    }
}
