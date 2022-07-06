//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Thompson on 3/7/2022.
//

import SwiftUI
import Combine

struct CellProperties : EnvironmentKey {
    static var defaultValue = CellProperties()
    
    var size: CGSize = CGSize(width: 50, height: 50)
    var font: Font = Font.system(.largeTitle)
    var borderWidth: Double = 0.0
}

extension EnvironmentValues {
    var cellProperties: CellProperties {
        get {
            self[CellProperties.self]
        }
        set {
            self[CellProperties.self] = newValue
        }
    }
}

struct CellTapEvent {
    var column: Int
    var row: Int
}

struct CellView: View {
    var publisher: PassthroughSubject<CellTapEvent, Never>
    var column: Int
    var row: Int
    @EnvironmentObject var hexGrid: HexGrid
    @Environment(\.cellProperties) var properties: CellProperties
    @Environment(\.cellColors) var colors: Colors

    var body: some View {
        Text("\(hexGrid[column, row] + 1)")
            .font(properties.font)
            .frame(width: properties.size.width, height: properties.size.height)
            .foregroundColor(colors.text)
            .background(
                Circle()
                    .inset(by: properties.borderWidth / 2)
                    .stroke(lineWidth: properties.borderWidth)
                    .foregroundColor(colors.stroke)
                    .background(Circle().fill(colors.background[hexGrid[column, row]]))
            )
            .onTapGesture {
                publisher.send(CellTapEvent(column: column, row: row))
            }
    }
}

struct ColumnView: View {
    var publisher: PassthroughSubject<CellTapEvent, Never>
    let column: Int
    let spacing: Double
    @EnvironmentObject var hexGrid: HexGrid
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<hexGrid.lengthOfColumn(column), id: \.self) { row in
                CellView(publisher: publisher, column: column, row: row)
            }
        }
    }
}

struct HexGridView: View {
    var publisher: PassthroughSubject<CellTapEvent, Never>
    let horizontalSpacing: Double = 0.0
    let verticalSpacing: Double = 0.0
    
    var body: some View {
        HStack(spacing: horizontalSpacing - 7) {
            ForEach(0..<7, id: \.self) {
                ColumnView(publisher: publisher, column: $0, spacing: verticalSpacing)
            }
        }
        .padding()
    }
}


struct ContentView: View {
    enum Mode {
        case logical
        case free
    }
    
    @EnvironmentObject var hexGrid: HexGrid
    @State var mode: Mode = .logical
    @State var amount: Int = 1
    @State var colors: Colors = Colors.defaultValue
    
    var modeTitle: String {
        switch mode {
        case .logical: return "Switch to Free Mode"
        case .free: return "Switch to Logical Mode"
        }
    }
    
    var publisher = PassthroughSubject<CellTapEvent, Never>()
    
    var themePicker: some View {
        let picker = Picker(selection: $colors, label: Text("Theme:")) {
            ForEach(0..<Colors.Themes.all.count, id: \.self) {
                Text("Theme \($0)").tag(Colors.Themes.all[$0])
            }
        }
        #if os(iOS)
        return picker.pickerStyle(.wheel)
        #else
        return picker.pickerStyle(.segmented)
        #endif
    }
    
    var body: some View {
        VStack {
            themePicker
            HexGridView(publisher: publisher)
                .onReceive(publisher) { output in
                    switch mode {
                    case .logical:
                        hexGrid.updateLogical(output.column, output.row, by: amount)
                    case .free:
                        hexGrid[output.column, output.row] += amount
                    }
                }
                .environment(\.cellColors, colors)
            HStack {
                Button("Reset") {
                    hexGrid.reset()
                }
                Button("Randomize") {
                    hexGrid.randomize()
                }
                Spacer(minLength: 50)
                Picker(selection: $mode, label: Text("Mode:")) {
                    Text("Logical").tag(Mode.logical)
                    Text("Free").tag(Mode.free)
                }
                .pickerStyle(.segmented)
            }
            HStack {
                Picker(selection: $amount, label: Text("Increment:")) {
                    Text("1").tag(1)
                    Text("2").tag(2)
                    Text("3").tag(3)
                    Text("4").tag(4)
                    Text("5").tag(5)
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let properties = CellProperties(borderWidth: 4.0)
        let hexGrid = HexGrid()
        
        ForEach(ColorScheme.allCases, id: \.self) {
            let publisher = PassthroughSubject<CellTapEvent, Never>()
            HexGridView(publisher: publisher)
                .environmentObject(hexGrid)
                .environment(\.cellProperties, properties)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme($0)
        }
    }
}
