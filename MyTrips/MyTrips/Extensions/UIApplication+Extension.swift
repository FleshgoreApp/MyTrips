//
//  UIApplication+Extension.swift
//  MyTrips
//
//  Created by Anton Shvets on 30.06.2024.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
