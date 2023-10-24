//
//  ContentView.swift
//  weather-app
//
//  Created by simko on 24/10/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        ZStack {
           
            Image("Image")
                .resizable()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 8) {
        
                    Text("Prague")
                        .font(.system(size: 41, weight: .medium, design: .default))
                        .foregroundStyle(.white)


                Text("28°")
                    .font(.system(size: 70, weight: .medium, design: .default))
                    .foregroundStyle(.white)

                VStack(spacing: 8) {
                    Text("Mostly clear")
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .foregroundStyle(.gray)

                    HStack {
                        Text("H:24°")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .foregroundStyle(.white)

                        Text("L:18°")
                            .font(.system(size: 20, weight: .medium, design: .default))
                            .foregroundStyle(.white)
                    }
                }

                Image("House")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 400, height: 400)

                Spacer()
            }
            .padding()



        

            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("DPurple"), Color("LPurple")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width, height: UIScreen.main.bounds.height * 0.5)
                        .position(x: geometry.size.width / 2, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height * 0.15)
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                        )
                        .frame(width: geometry.size.width, height: UIScreen.main.bounds.height * 0.5)
                        .position(x: geometry.size.width / 2, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height * 0.15)
                        .blur(radius: 20)
                    
                    HStack(spacing:30) {
                        WeatherItem(dayOfWeek: "Mon", imgName: "cloud.sun.fill", temp: 18)
                        WeatherItem(dayOfWeek: "Tue", imgName: "cloud.rain.fill", temp: 25)
                        WeatherItem(dayOfWeek: "Wed", imgName: "cloud.hail.fill", temp: 10)
                        WeatherItem(dayOfWeek: "Thu", imgName: "wind.snow", temp: 16)
                    }
                    .position(x: geometry.size.width / 2, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height * 0.28)
                    
                    Spacer()
                    Button {
                       print("clicked")
                    } label: {
                        Text("Switch day")
                            .frame(width: 150,height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .font(.system(size:20,weight: .bold,design: .default))
                    }.position(x: geometry.size.width / 2, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height * 0.15)
                    
                }
                .opacity(0.9)
            }
        }
    }
}


#Preview {
    ContentView()
}

struct WeatherItem: View {
    var dayOfWeek: String
    var imgName: String
    var temp: Int
    
    
    var body: some View {
        VStack{
            Text(dayOfWeek)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
            Image(systemName: imgName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40,height: 40)
            
            Text("\(temp)°")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold))
        }
    }
}
