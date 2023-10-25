//
//  CustomButton.swift
//  weather-app
//
//  Created by sirotek on 25/10/2023.
//

import SwiftUI

struct WeatherButton: View {
    var title: String
    var textColor: Color
    var bgColor: Color
    
    var body: some View {
        Text(title)
            .frame(width: 150,height: 50)
            .background(bgColor)
            .foregroundColor(textColor)
            .cornerRadius(10)
            .font(.system(size:20,weight: .bold,design: .default))
    }
}

struct WeatherButton_Previews: PreviewProvider {
    static var previews: some View {
        WeatherButton(title: "Tap me", textColor: .white, bgColor: .black)
    }
}

