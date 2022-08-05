//
//  InitialWeatherView.swift
//  weatherApp
//
//  Created by Abigail Mukombero on 05/05/2022.
//

import SDWebImageSwiftUI
import SwiftUI


// Display the weather icon, temperature and humidity. Also display the navigation view buttons - leading to 'Detailed Weather' and '5 Day Forecast'
struct InitialWeatherView: View {
    
    @StateObject var weatherIcon = WeatherIconModel()
    @State var weatherForView:Weather?
    @State var cityName: String = ""
    @State var title: String = ""

    //Handle the user input and send to 'getCurrentWeather' to handle the API call
    func getWeather (){
        
        let url = setLocationURLString(location: cityName)
        getCurrentWeather(url: url, completion: {_ in weatherForView = weather})
    }
    
    var body: some View {
        NavigationView{
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
                        .padding(.bottom, 20)
                        .offset()
                        .accentColor(.blue)
                        
                    Button {
                        //
                        getWeather()
                        weatherIcon.fetchWeatherIcon(cityName: cityName)
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                            .padding(.bottom, 20)
                            .foregroundColor(.white)

                    }
                    
                }.offset(y: 20)
                
                
                VStack{
                    //Weather Summary Icon
                    Image(systemName: "\(weatherIcon.conditionString)")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(weatherIcon.conditionColor)
                
                //Display Temperature

                HStack(spacing: 8){
                                    Image(systemName: "thermometer")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .padding(10)

                
                    Text(weatherForView?.main.temp.description ?? "--")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.white)
                    Text("°")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.white)

                    
                }
                    
                //Display humidity
                
                HStack(spacing: 8){
                                    Image(systemName: "humidity.fill")
                                        .renderingMode(.original)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .padding(10)
                                 .foregroundColor(.white)

                
                    Text(weatherForView?.main.humidity.description ?? "--")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.white)
                    Text("%")
                        .font(.system(size: 50, weight: .medium))
                        .foregroundColor(.white)
                }
                }
                
                //Navigation Buttons to transition views 
                NavigationLink(destination: DetailedWeatherView(cityName: $cityName), label: {
                    Text("Detailed weather")
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 280, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.black)
                        .cornerRadius(30)
                    
                })
                
                NavigationLink(destination: FiveDayWeatherView(), label: {
                    Text("5 Day Forecast")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))
                        .bold()
                        .frame(width: 280, height: 50)
                        .background(Color.black)
                        .foregroundColor(.black)
                        .cornerRadius(30)
                })
        } .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                    .foregroundColor(.black)
                    .background(Color("Misty Blue"))
                    .cornerRadius(20)
                .navigationTitle("Today's Weather ")
                
            }
            }.onAppear(perform: getWeather)
        }.accentColor(.white)
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InitialWeatherView()
                .previewInterfaceOrientation(.portrait)
        }
    }
}
