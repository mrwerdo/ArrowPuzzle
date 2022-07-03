//
//  ArrowPuzzleApp.swift
//  Shared
//
//  Created by Andrew Thompson on 3/7/2022.
//

import SwiftUI

@main
struct ArrowPuzzleApp: App {
    var body: some Scene {
        WindowGroup("Arrow Puzzle") {
            let properties = CellProperties(font: .largeTitle,
                                                   accentColor: Color.teal,
                                                   borderWidth: 2.0,
                                                   backgroundColor: .white)
            ContentView().environment(\.cellProperties, properties)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
