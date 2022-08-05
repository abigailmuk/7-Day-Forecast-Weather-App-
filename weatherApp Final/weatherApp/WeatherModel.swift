//
//  WeatherModel.swift
//
//
//  Created by Abigail Mukombero on 05/05/2022.
//

import Foundation
import SwiftUI
// MARK: - Weather Details
struct Weather: Codable {
    let coord: Coord
    let weather: [WeatherElement]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    //let description: [WeatherElement]
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

var weather:Weather?
var title: String = ""

//Get the API details to examine in console
func getCurrentWeather(url:String, completion: @escaping (Weather)->())
{
    let session = URLSession(configuration: .default)
    session.dataTask (with:URL(string:url)!) {(data, _, err) in
        if err != nil {
            print(err!.localizedDescription)
            return
        }
        DispatchQueue.main.async {
            do {
                weather = try JSONDecoder().decode(Weather.self, from: data!)
                print("Temp is \(String(describing: weather?.main.temp))")
                print("Humidity is \(String(describing: weather?.main.humidity))")
                print("Windspeed is \(String(describing: weather?.wind.speed))")
                print("Humidity is \(String(describing: weather?.main.pressure))")
                print("Date is \(String(describing:weather?.dt))")
                print("Condition ID is \(String(describing: weather?.cod))")
                completion(weather!)
            }
            catch {
                print(error)
            }
        }
    }.resume()
    
    
}


let apiKey:String = "5227e885de2e64c2f6fcdfe51e8bc227"

func setLocationURLString(location: String)-> String {
    //Format user entry to for the API '+' requirement to handle spaces eg 'New York'
    let formattedlocation = location.replacingOccurrences(of: " ",  with: "+")
    return
        "https://api.openweathermap.org/data/2.5/weather?q=\(formattedlocation)&appid=\(apiKey)&units=metric"
    
    
}





//Class to collect the weather icon
class WeatherIconModel: ObservableObject {
    
    @Published var title: String = "-"

    @Published var descriptionText: String = "-"
  
    @Published var temp: String = "-"
  
    @Published var conditionId: Int = 0
  
    //Weather description details
    var conditionDescription: String {
        switch descriptionText {
        case "scattered clouds":
            return "scattered clouds"
        case "clear sky":
            return "clear sky"
        case "light rain":
            return "light rain"
        case "moderate rain":
            return "moderate rain"
        default:
            return "Weather information unknown"
        }
    }
    
    //Weather Icon Colour
    var conditionColor: Color {
        switch conditionId {
        case 200...232:
            return Color.white
        case 300...321:
            return Color.white
        case 500...531:
            return Color.white
        case 600...622:
            return Color.white
        case 701...711:
            return Color.red
        case 721:
            return Color.red
        case 731:
            return Color.red
        case 741...751:
            return Color.red
        case 761:
            return Color.red
        case 762:
            return Color.red
        case 771...781:
            return Color.red
        case 800:
            return Color.yellow
        default:
            return Color.yellow
        }
    }
    
    //Weather Icon Selection
    var conditionString: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...711:
            return "smoke.fill"
        case 721:
            return "sun.max.fill"
        case 731:
            return "sun.max.fill"
        case 741...751:
            return "cloud.fog.fill"
        case 761:
            return "sun.dust.fill"
        case 762:
            return "cloud.fog.fill"
        case 771...781:
            return "tornado"
        case 800:
            return "sun.max.fill"
        default:
            return "cloud.fill"
        }
    }
    
    init() {
        
        fetchWeatherIcon(cityName: "")
    }
    
    let myApiKey: String = "5227e885de2e64c2f6fcdfe51e8bc227"
    let weatherURL: String = "https://api.openweathermap.org/data/2.5/weather?"
   
    
    //fetch the correct icon relating to the city name
    func fetchWeatherIcon(cityName: String) {
        let urlString = "\(weatherURL)&appid=\(myApiKey)&q=\(cityName)&units=metric"
        print(urlString)
        
        
        guard let url = URL(string: urlString) else {
            print("url There is no.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("??")
                return
            }
            
            do {
                let model = try JSONDecoder().decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    self.title = model.name
                    //self.descriptionText = model.weather[0].weatherDescription
                    self.temp = "\(model.main.temp)"
                    self.conditionId = model.weather[0].id
                    
                }
            } catch {
                print("Failed")
            }
        }
        task.resume()
    }
    
    
    
}
