//
//  SearchView.swift
//  MyTrips
//
//  Created by Anton Shvets on 04.07.2024.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    let trailingButtonShowed: Bool
    let trailingButtonImageName: String
    let placeholder: String
    let onSubmit: () -> Void
    let onClear: () -> Void
    let onTrailingButtonTapped: () -> Void
    
    // Private
    @FocusState private var searchFieldFocus: Bool
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $searchText)
                .focused($searchFieldFocus)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .overlay(alignment: .trailing) {
                    if searchFieldFocus {
                        Button {
                            onClear()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.trailing, 5)
                        }
                    }
                }
                .onSubmit {
                    onSubmit()
                }
            
            VStack {
                if trailingButtonShowed {
                    Button {
                        onTrailingButtonTapped()
                    } label: {
                        Image(systemName: trailingButtonImageName)
                            .imageScale(.large)
                    }
                    .buttonStyle(SearchMarkButtonStyle())
                }
            }
        }
    }
}

#Preview {
    SearchView(
        searchText: .constant("Paris"),
        trailingButtonShowed: true,
        trailingButtonImageName: "mappin.slash",
        placeholder: "Search ...",
        onSubmit: {
            print("onSubmit")
        },
        onClear: {
            print("onClear")
        },
        onTrailingButtonTapped: {
            print("onMarkButtonTapped")
        }
    )
}
