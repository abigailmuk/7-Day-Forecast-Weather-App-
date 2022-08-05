//
//  UIAppExtension.swift
//  weatherApp
//
//  Created by Abigail Mukombero on 05/05/2022.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
