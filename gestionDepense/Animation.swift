//
//  AnimatedImageView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 21/11/2023.
//

import SwiftUI

struct AnimatedImageView: View {
    @State private var waveOffset: CGFloat = -50
    @State var name: String

    var body: some View {
        ZStack {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 300)
                .cornerRadius(150)
                .clipped()

            WaveShape(offset: waveOffset)
                .fill(Color.blue.opacity(0.3))
                .frame(width: 300, height: 300)
                .mask(
                    RoundedRectangle(cornerRadius: 150)
                        .frame(width: 300, height: 300)
                )
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        waveOffset = 50
                    }
                }
        }
    }
}

struct WaveShape: Shape {
    var offset: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                          control: CGPoint(x: rect.midX, y: rect.midY + offset))

        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        path.closeSubpath()

        return path
    }

    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
}

struct AnimatedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(), value: configuration.isPressed)
    }
}
