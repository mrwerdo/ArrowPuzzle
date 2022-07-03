//
//  ArrowPuzzleApp.swift
//  Shared
//
//  Created by Andrew Thompson on 3/7/2022.
//

import SwiftUI

@main
struct ArrowPuzzleApp: App {
    
    @StateObject var hexGrid = HexGrid()
    
    var body: some Scene {
        WindowGroup("Arrow Puzzle") {
            let properties = CellProperties(font: .largeTitle,
                                                   accentColor: Color.teal,
                                                   borderWidth: 2.0,
                                                   backgroundColor: .white)
            ContentView()
                .environmentObject(hexGrid)
                .environment(\.cellProperties, properties)
                .fixedSize()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
