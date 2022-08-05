//
//  weatherAppApp.swift
//  weatherApp
//
//  Created by Abigail Mukombero on 05/05/2022.
//

import SwiftUI

@main
struct weatherAppApp: App {
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor.white ]
    }
    
    var body: some Scene {
        WindowGroup {
            InitialWeatherView()
        }
    }
}
