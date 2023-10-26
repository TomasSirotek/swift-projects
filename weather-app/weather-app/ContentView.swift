//
//  ContentView.swift
//  weather-app
//
//  Created by sirotek on 24/10/2023.
//

import SwiftUI

// Todo: Do network call
// Todo: Switch city
struct ContentView: View {
    @State private var isNight = true
    @State private var  data : WeatherResponse?
    
    
    var body: some View {

        ZStack {
           
            BackgroundView(isNight: isNight)
            
            WeatherView(cityName: "Prague", temp: 2, tempStatus: "Mostly clearr", hTemp: "24", lTemp: "18")

            GeometryReader { geometry in
                ZStack {
                    RectangleView(geometry: geometry)
                    
                    // TODO Re do it into data model
                    HStack(spacing:30) {
                        WeatherItem(dayOfWeek: "Mon", imgName: "cloud.sun.fill" , temp: 18)
                        WeatherItem(dayOfWeek: "Tue", imgName: "cloud.rain.fill", temp: 25)
                        WeatherItem(dayOfWeek: "Wed", imgName: "cloud.hail.fill", temp: 10)
                        WeatherItem(dayOfWeek: "Thu", imgName: "wind.snow", temp: 16)
                    }
                    .position(x: geometry.size.width / 2, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height * 0.28)
                    
                    Spacer()
                    Button {
                        isNight.toggle()
                    } label: {
                        WeatherButton(title: "Switch day", textColor: .black, bgColor: .white)
                    }.position(x: geometry.size.width / 2, y: UIScreen.main.bounds.height - UIScreen.main.bounds.height * 0.15)
                    
                }
                .opacity(0.9)
            }
        }.task {
            do {
                data = try await getWeatherData()
               
            } catch GHError.invalidURL{
                print("invalid URL")
            }
            catch GHError.invalidResp{
                print("invalid respo")
            }
            catch GHError.invalidData{
                print("invalid data")
            } catch {
                print("Unexpected stuff")
            }
        }
    }
    
    func getWeatherData() async throws -> WeatherResponse {
        let api = "https://api.open-meteo.com/v1/forecast?latitude=50.088&longitude=14.4208&current=temperature_2m,is_day&hourly=temperature_2m&daily=temperature_2m_max,temperature_2m_min&timezone=auto"
        
        guard let url = URL(string: api) else {
            throw GHError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GHError.invalidResp
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let weatherData = try decoder.decode(WeatherResponse.self, from: data)
            return weatherData;
        } catch {
            print("Errr")
            throw GHError.invalidData
        }
    }

}
 
#Preview {
    ContentView()
}

enum GHError: Error {
    case invalidURL
    case invalidResp
    case invalidData
}


struct WeatherResponse: Codable {
    let current: CurrentWeather
    let hourly: HourlyWeather
    let daily: DailyWeather
}

struct CurrentWeather: Codable {
    let time: String
    let interval: String
    let temperature_2m: String
    let is_day: String?
}

struct HourlyWeather: Codable {
    let time: String
    let temperature_2m: String
}

struct DailyWeather: Codable {
    let time: [String]
    let temperature_2m_max: [String]
    let temperature_2m_min: [String]
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

struct BackgroundView: View {
   var isNight: Bool
    
    var body: some View {
        Image(isNight ? "Night" : "Day")
            .resizable()
            .ignoresSafeArea(.all)
    }
}

struct WeatherView: View {
    var cityName: String
    var temp : Int
    var tempStatus: String
    var hTemp: String
    var lTemp: String
    
    var body: some View {
        VStack(spacing: 8) {
            
            Text(cityName)
                .font(.system(size: 41, weight: .medium, design: .default))
                .foregroundStyle(.white)
            
            
            Text("\(temp)°")
                .font(.system(size: 70, weight: .medium, design: .default))
                .foregroundStyle(.white)
            
            VStack(spacing: 8) {
                Text(tempStatus)
                    .font(.system(size: 20, weight: .medium, design: .default))
                    .foregroundStyle(.white)
                    .opacity(0.5)
                HStack {
                    Text("H:\(hTemp)°")
                        .font(.system(size: 20, weight: .medium, design: .default))
                        .foregroundStyle(.white)
                    
                    Text("L:\(lTemp)°")
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
    }
}

struct RectangleView: View {
    var geometry : GeometryProxy
    
    var body: some View {
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
    }
}

