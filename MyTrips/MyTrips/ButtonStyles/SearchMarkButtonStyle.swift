//
//  SearchMarkButtonStyle.swift
//  MyTrips
//
//  Created by Anton Shvets on 04.07.2024.
//

import SwiftUI

struct SearchMarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .foregroundStyle(.white)
            .background(.red)
            .clipShape(.circle)
    }
}
