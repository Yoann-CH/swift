//
//  CustomAlertView.swift
//  gestionDepense
//
//  Created by CHAMBEUX Yoann on 23/11/2023.
//

import SwiftUI

struct CustomAlertView: View {
    var title: String
    var message: String
    var primaryButtonText: String
    var primaryButtonAction: () -> Void
    var primaryButtonColor: Color = .blue
    var secondaryButtonText: String?
    var secondaryButtonAction: (() -> Void)?
    var secondaryButtonColor: Color = .gray

    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
                .padding()

            Text(message)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            
            HStack {
                if let secondaryButtonText = secondaryButtonText, let secondaryButtonAction = secondaryButtonAction {
                    Button(secondaryButtonText, action: secondaryButtonAction)
                        .padding()
                        .foregroundColor(.blue)
                        .background(secondaryButtonColor)
                        .cornerRadius(8)
                }
                
                Button(primaryButtonText, action: primaryButtonAction)
                    .padding()
                    .foregroundColor(.white)
                    .background(primaryButtonColor)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(width: 300, height: 250)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 10)
    }
}
