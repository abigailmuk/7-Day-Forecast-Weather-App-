//
//  FiveDayWeatherView.swift
//  weatherApp
//
//  Created by Abigail Mukombero on 08/05/2022.
//
import SDWebImageSwiftUI
import SwiftUI
/// 5 Days forecast page
    
struct FiveDayWeatherView: View {
    
    @StateObject private var fiveDayListVM = FiveDayListViewModel()
    
    var body: some View {
        NavigationView {
            
            //Background Color
            ZStack{
                //Gradient Colours adding using color set in assets
                LinearGradient(gradient: Gradient(colors: [Color("Mid Blue"), Color("Light Blue")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    //Display City Name Location entered by user from Textfield
                    Group {
                        HStack {
                        Image(systemName: "location")
                                .foregroundColor(Color.white)
                                                              .frame(width: 10, alignment: .leading)
                        Text(fiveDayListVM.location)
                        .bold()
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.trailing)
                        }
                    //Display the Date
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.white)
                        
                        
                HStack {
                    //Textfield for user entry
                    TextField("Search for location...", text: $fiveDayListVM.location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .accentColor(.blue)
                    Button {
                        fiveDayListVM.getWeatherForecast()
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                    }
                List(fiveDayListVM.forecasts, id: \.day) { day in
                    VStack(alignment: .leading) {
                        HStack{
                        Text(day.day)
                            .fontWeight(.bold)

                        }
                        HStack(alignment: .top) {
                            WebImage(url: day.weatherIconURL)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 95)
                            VStack(alignment: .leading) {
                                Text(day.overview)
                                    .fontWeight(.bold)
                                HStack {
                                    Text(day.high)
                                    Text(day.low)
                                }
                                HStack {
                                    Text(day.clouds)
                                }
                                Text(day.humidity)
                            }
                        }
                    }.listRowBackground(Color("Misty Blue"))
                    
                }
                .offset(y: 20)
                .listStyle(PlainListStyle())
                
                    
                }.offset(y: -10)
                .padding(.horizontal)
                
            
                Spacer()
                .alert(item: $fiveDayListVM.appError){
                    appAlert in Alert(title: Text("Error"),
                    message: Text("""
                        \(appAlert.errorString)
                        Please try again later!
                        """
                        )
                    )
                }
            }
    }.navigationTitle("Weather forecast")

}
}


