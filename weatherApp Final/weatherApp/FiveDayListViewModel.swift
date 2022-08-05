//
//  FiveDayListViewModel.swift
//  weatherApp
//
//  Created by Abigail Mukombero on 05/05/2022.
//


import CoreLocation
import Foundation
import SwiftUI

class FiveDayListViewModel: ObservableObject {
    struct AppError: Identifiable {
        let id = UUID().uuidString
        let errorString: String
    }
    
    @Published var forecasts: [ForecastViewModel] = []
    var appError: AppError? = nil
    @AppStorage("location") var location: String = ""
    var system: Int = 0
    
    init() {
        if location != "" {
            getWeatherForecast()
        }
    }
    
    func getWeatherForecast() {
        UIApplication.shared.endEditing()
        let apiService = APIService.shared
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error as? CLError {
                switch error.code {
                case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                    self.appError = AppError(errorString: NSLocalizedString("Unable to find location from your search, enter valid location name", comment: ""))
                case .network:
                    self.appError = AppError(errorString: NSLocalizedString("No network connection, please connect to internet", comment: ""))
                default:
                    self.appError = AppError(errorString: error.localizedDescription)
                }
                self.appError = AppError(errorString: error.localizedDescription)
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                        apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=current,hourly,minutely,alert&appid=5227e885de2e64c2f6fcdfe51e8bc227",
                                           dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in

                    switch result {
                    case .success(let forecast):
                        DispatchQueue.main.async {
                            self.forecasts = forecast.daily.map { ForecastViewModel(forecast: $0, system: self.system)}
                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            self.appError = AppError(errorString: errorString)
                            print(errorString)
                        }
                    }
                }
            }
        }

    }
}
