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
    @State private var  data : Welcome?
    
    
    var body: some View {

        ZStack {
           
            BackgroundView(isNight: isNight)
            
            WeatherView(cityName: "Prague", temp: formattedCelsius(curreTemo: data?.current.temperature2M ?? 0.00), tempStatus: "Mostly clear", hTemp: formattedCelsius(curreTemo: data?.daily.temperature2MMax.first ?? 0.00), lTemp: formattedCelsius(curreTemo: data?.daily.temperature2MMin.first ?? 0.00))

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
    
    func formattedCelsius(curreTemo: Double) -> Int {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        let finalFormat = formatter.string(from:  NSNumber(value: curreTemo))!
        
       return Int(finalFormat) ?? 0
    }
    
    func formattedCelsius(curreTemo: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: curreTemo)) ?? ""
    }


    
    func getWeatherData() async throws -> Welcome {
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
            let weatherData = try decoder.decode(Welcome.self, from: data)
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

// MARK: - Welcome
struct Welcome: Codable {
    let latitude, longitude, generationtimeMS: Double
    let utcOffsetSeconds: Int
    let timezone, timezoneAbbreviation: String
    let elevation: Int
    let currentUnits: CurrentUnits
    let current: Current
    let hourlyUnits: HourlyUnits
    let hourly: Hourly
    let dailyUnits: DailyUnits
    let daily: Daily

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentUnits = "current_units"
        case current
        case hourlyUnits = "hourly_units"
        case hourly
        case dailyUnits = "daily_units"
        case daily
    }
}

// MARK: - Current
struct Current: Codable {
    let time: String
    let interval: Int
    let temperature2M: Double
    let isDay: Int

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case isDay = "is_day"
    }
}

// MARK: - CurrentUnits
struct CurrentUnits: Codable {
    let time, interval, temperature2M, isDay: String

    enum CodingKeys: String, CodingKey {
        case time, interval
        case temperature2M = "temperature_2m"
        case isDay = "is_day"
    }
}

// MARK: - Daily
struct Daily: Codable {
    let time: [String]
    let temperature2MMax, temperature2MMin: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
    }
}

// MARK: - DailyUnits
struct DailyUnits: Codable {
    let time, temperature2MMax, temperature2MMin: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2MMax = "temperature_2m_max"
        case temperature2MMin = "temperature_2m_min"
    }
}

// MARK: - Hourly
struct Hourly: Codable {
    let time: [String]
    let temperature2M: [Double]

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
    }
}

// MARK: - HourlyUnits
struct HourlyUnits: Codable {
    let time, temperature2M: String

    enum CodingKeys: String, CodingKey {
        case time
        case temperature2M = "temperature_2m"
    }
}


enum GHError: Error {
    case invalidURL
    case invalidResp
    case invalidData
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

