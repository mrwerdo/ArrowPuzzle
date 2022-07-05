//
//  Colors.swift
//  ArrowPuzzle
//
//  Created by Andrew Thompson on 3/7/2022.
//

import SwiftUI
import Combine

struct Colors : EnvironmentKey {
    static var defaultValue: Colors = Colors.themes.something2
    
    var text: Color
    var stroke: Color
    var background: [Color]
    
    init(text: String, stroke: String, background: [String]) {
        self.text = Color(hex: text)
        self.stroke = Color(hex: stroke)
        self.background = background.map(Color.init(hex:))
    }
    
    init(text: Color, stroke: Color, background: [Color]) {
        self.text = text
        self.stroke = stroke
        self.background = background
    }
    
    init(_ array: [String]) {
        text = Color(hex: array[0])
        stroke = Color(hex: array[1])
        background = array[2...].map(Color.init(hex:))
    }
    
    static var themes = (
        red: Colors(["bc2440","6d1425","641121","5c0f1e","540d1a","4c0b17","430813","3b0610"]),
        gray: Colors(["000000","111111","232323","343434","464646","575757","696969","9a9a9a"]),
        blue: Colors(["052b56","052f5f","03416b","005377","026879","036e7a","03737a","037d7a"]),
        something: Colors( ["0b132b","1c2541","2b3b56","3a506b","4b8895","53a4aa","57b2b4","5bc0be","ffffff"]),
        something2: Colors(["355070","515575","6d597a","915f78","b56576","e56b6f","e88c7d","eaac8b"].reversed())
    )
}

extension EnvironmentValues {
    var cellColors: Colors {
        get {
            self[Colors.self]
        }
        set {
            self[Colors.self] = newValue
        }
    }
}



extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct Color_Previews: PreviewProvider {
    static var previews: some View {
        let red = Colors(
            text: "bc2440",
            stroke: "6d1425",
            background: [
                "3b0610",
                "430813",
                "4c0b17",
                "540d1a",
                "5c0f1e",
                "641121"
            ].reversed()
        )
        
        let red2 = Colors(
            text: "3e3b92",
            stroke: "ffffff",
            background: ["f44369", "d64270","b74077","993f7e","7b3e84","5c3c8b"]
        )
        
        let red3 = Colors(
            text: "ffb600",
            stroke: "ffffff",
            background: ["6a00f4","8900f2","bc00dd","e500a4","f20089","2d00f7"]//.reversed()
        )
        
        let colorful = Colors(
            text: "073b4c",
            stroke: "ffffff",
            background: ["ef476f", "f78c6b","ffd166","83d483","06d6a0","0cb0a9","118ab2"]
        )
        
        let gray = Colors(
            text: "dddddd",
            stroke: "111111",
            background: ["2F2F2F","343434","464646","575757","696969","9a9a9a"]
        )
        
        let blue = Colors(text: "bbbbbb"/*"052b56"*/,
                          stroke: "052b56", /*"052f5f"*/
                          background: ["03416b","005377","026879","036e7a","03737a","037d7a"]
        )
        
        let something = Colors(text: "ffffff",
                               stroke: "1c2541",
                               background: ["2b3b56","3a506b","4b8895","53a4aa","57b2b4","5bc0be"]
        )
        
        let something2 = Colors(text: "244060",
                                stroke: "515575",
                                background: ["6d597a","915f78","b56576","e56b6f","e88c7d","eaac8b"].reversed()
        )
        
        let colors: [Colors] = [
            red,
            red2,
            red3,
            colorful,
            gray,
            blue,
            something,
            something2
        ]
        
        let properties = CellProperties(font: .largeTitle, borderWidth: 0.0)
        let hexGrid = HexGrid()
        var generator = Xorshift128Plus(123, 456)
        hexGrid.randomize(using: &generator)
        let publisher = PassthroughSubject<CellTapEvent, Never>()
        
        return ForEach(0..<5, id: \.self) { index in
            Group {
                HexGridView(publisher: publisher)
                    .environmentObject(hexGrid)
                    .environment(\.cellColors, colors[index])
                    .environment(\.cellProperties, properties)
                    .previewLayout(.sizeThatFits)
                    .preferredColorScheme(.light)
                HexGridView(publisher: publisher)
                    .environmentObject(hexGrid)
                    .environment(\.cellColors, colors[index])
                    .environment(\.cellProperties, properties)
                    .previewLayout(.sizeThatFits)
                    .preferredColorScheme(.dark)
            }
        }
    }
}
