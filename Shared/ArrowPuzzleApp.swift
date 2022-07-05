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
            ContentView()
                .environmentObject(hexGrid)
                .fixedSize()
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
