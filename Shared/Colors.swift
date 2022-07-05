//
//  Colors.swift
//  ArrowPuzzle
//
//  Created by Andrew Thompson on 3/7/2022.
//

import SwiftUI
import Combine

struct Colors : EnvironmentKey {
    static var defaultValue: Colors = Colors.Themes.blue
    
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
    
    struct Themes {
        static let red = Colors(
            text: "d83150",
            stroke: "6d1425",
            background: ["641121", "5c0f1e", "540d1a", "4c0b17", "430813", "3b0610"]
        )
        
        static let redBlue = Colors(
            text: "ffffff",
            stroke: "ffffff",
            background: ["f44369", "d64270","b74077","993f7e","7b3e84","5c3c8b"]
        )
        
        static let bluePink = Colors(
            text: "ffb600",
            stroke: "ffffff",
            background: ["4d00f7", "6a00f4","8900f2","bc00dd","e500a4","f20089"]
        )
        
        static let colorful = Colors(
            text: "073b4c",
            stroke: "ffffff",
            background: ["ef476f", "f78c6b","ffd166","83d483","06d6a0","0cb0a9","118ab2"]
        )
        
        static let gray = Colors(
            text: "dddddd",
            stroke: "111111",
            background: ["2F2F2F","343434","464646","575757","696969","9a9a9a"]
        )
        
        static let teal = Colors(
            text: "bbbbbb",
            stroke: "052b56",
            background: ["03416b","005377","026879","036e7a","03737a","037d7a"]
        )
        
        static let blue = Colors(
            text: "ffffff",
            stroke: "1c2541",
            background: ["2b3b56","3a506b","4b8895","53a4aa","57b2b4","5bc0be"]
        )
        
        static let orange = Colors(
            text: "244060",
            stroke: "515575",
            background: ["eaac8b", "e88c7d", "e56b6f", "b56576", "915f78", "6d597a"]
        )
    }
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
        let colors: [Colors] = [
            Colors.Themes.red,
            Colors.Themes.redBlue,
            Colors.Themes.bluePink,
            Colors.Themes.colorful,
            Colors.Themes.gray,
            Colors.Themes.teal,
            Colors.Themes.blue,
            Colors.Themes.orange
        ]
        
        let properties = CellProperties(font: .largeTitle, borderWidth: 0.0)
        let hexGrid = HexGrid()
        var generator = Xorshift128Plus(123, 456)
        hexGrid.randomize(using: &generator)
        let publisher = PassthroughSubject<CellTapEvent, Never>()
        
        return ForEach(0..<colors.count, id: \.self) { index in
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
