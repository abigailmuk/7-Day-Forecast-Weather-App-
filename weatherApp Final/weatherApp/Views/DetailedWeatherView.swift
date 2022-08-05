//
//  DetailedWeatherView.swift
//
//
//  Created by Abigail Mukombero on 05/05/2022.
//


import SDWebImageSwiftUI
import SwiftUI

// Detailed Weather View

struct DetailedWeatherView: View {
    @StateObject var weatherIcon = WeatherIconModel()
    @Binding var cityName: String
    @State var weatherForView:Weather?
    
    
    //Handle the user input and send to 'getCurrentWeather' to handle the API call
    func getWeather (){
        let url = setLocationURLString(location: cityName)
        getCurrentWeather(url: url, completion: {_ in weatherForView = weather})
    }
    
    
    var body: some View {
        
        //Background Color
        ZStack{
            
            //Gradient Colours adding using color set in assets
            LinearGradient(gradient: Gradient(colors: [Color("Mid Blue"), Color("Light Blue")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                //Display City Name Location entered by user from Textfield
                Image(systemName: "location")
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(width: 20, alignment: .leading)
                    
                Text(cityName)
                   .bold()
                   .font(.largeTitle)
                   .frame(maxWidth: .infinity, alignment: .leading)
                   .foregroundColor(.white)
                   .padding(.horizontal)
                   .padding(.trailing)
                }
                
            VStack{
                //Display the Date
                Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                    .fontWeight(.light)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .padding(.vertical)
                
                
                HStack {
                    //Textfield for user entry
                    TextField("Search for location...", text: $cityName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accentColor(.blue)
                    Button {
                        getWeather()
                        weatherIcon.fetchWeatherIcon(cityName: cityName)
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
            
            VStack(alignment: .leading, spacing: 20){
                //Weather Summary Icon
                Image(systemName: "\(weatherIcon.conditionString)")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(weatherIcon.conditionColor)
                    .padding()
                Text("More Details")
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .font(.system(size: 25, weight: .medium))
                HStack {
                    Image(systemName: "thermometer")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                    Text(weatherForView?.main.temp.description ?? "--")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .medium))
                    Text("°")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .medium))
                }
                
                //Humidity
                HStack {
                    
                    Image(systemName: "humidity.fill")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                    Text(weatherForView?.main.humidity.description ?? "--")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .medium))
                    Text("%")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .medium))
                }
                    VStack(spacing: 8){
                //Pressure
                HStack {
                    Image(systemName: "aqi.high")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                    Text(weatherForView?.main.pressure.description ?? "--")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .medium))
                    Text("hPa")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .medium))
                }
                
                //Wind Speed
                
                                    
                               
                
            Group {
                HStack {
                    Image(systemName: "smoke")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                    Text(weatherForView?.wind.speed.description ?? "--")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .medium))
                    Text("mph")
                        .foregroundColor(.white)
                        .font(.system(size: 25, weight: .medium))
                    }
                }
         
                    
                }
                    
                Spacer()
            .navigationTitle("Detailed Weather")
            }
            }.padding(.horizontal).frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 20)
                .foregroundColor(.black)
                .background(Color("Misty Blue"))
                .cornerRadius(20)
                }.onAppear(perform: getWeather)
}

    }
    
}
