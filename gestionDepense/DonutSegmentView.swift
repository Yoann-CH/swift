//
//  DonutSegmentView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 23/11/2023.
//

import SwiftUI

struct DonutSegmentView: View {
    var center: CGPoint
    var radius: CGFloat
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    var total: Double
    var categorie: String
    var selectedCategorie: String?
    var devise: String
    var isSelected: Bool {
        selectedCategorie == categorie
        
    }
    var midAngle: Angle {
        Angle(degrees: (startAngle.degrees + endAngle.degrees) / 2)
    }

    var body: some View {
        ZStack {
            Path { path in
                path.move(to: center)
                path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            }
            .fill(color)
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.easeInOut, value: isSelected)



            if selectedCategorie == categorie {
                let deviseSymbol = symbolForCurrencyCode(devise)
                Text("\(total, specifier: "%.2f") \(deviseSymbol)")
                    .foregroundColor(.white)
                    .position(
                        x: center.x + cos(midAngle.radians) * (radius + 10) / 2,
                        y: center.y + sin(midAngle.radians) * (radius + 10) / 2
                    )
            } else {
                iconForCategory(categorie)
                    .foregroundColor(.white)
                    .position(
                        x: center.x + cos(midAngle.radians) * radius / 2,
                        y: center.y + sin(midAngle.radians) * radius / 2
                    )
            }
        }
    }
}

private func iconForCategory(_ category: String) -> Image {
    switch category {
    case "Nourriture":
        return Image(systemName: "fork.knife")
    case "Transport":
        return Image(systemName: "car")
    case "Loisirs":
        return Image(systemName: "gamecontroller")
    case "Autre":
        return Image(systemName: "square.and.pencil")
    default:
        return Image(systemName: "questionmark.circle")
    }
}
