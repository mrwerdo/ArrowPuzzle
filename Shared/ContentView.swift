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
    var accentColor: Color = Color.accentColor
    var borderWidth: Double = 4.0
    var backgroundColor: Color = .white
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

    var body: some View {
        Text("\(hexGrid[column, row] + 1)")
            .font(properties.font)
            .frame(width: properties.size.width, height: properties.size.height)
            .foregroundColor(properties.accentColor)
            .background(
                Circle()
                    .inset(by: properties.borderWidth / 2)
                    .stroke(lineWidth: properties.borderWidth)
                    .foregroundColor(properties.accentColor)
                    .background(Circle().fill(properties.backgroundColor))
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
    
    var modeTitle: String {
        switch mode {
        case .logical: return "Switch to Free Mode"
        case .free: return "Switch to Logical Mode"
        }
    }
    
    var publisher = PassthroughSubject<CellTapEvent, Never>()
    
    var body: some View {
        VStack {
            HexGridView(publisher: publisher)
                .onReceive(publisher) { output in
                    switch mode {
                    case .logical:
                        hexGrid.updateLogical(output.column, output.row)
                    case .free:
                        hexGrid[output.column, output.row] += 1
                    }
                }
            HStack {
                Button("Reset") {
                    hexGrid.reset()
                }
                Spacer(minLength: 50)
                Picker(selection: $mode, label: Text("Mode:")) {
                    Text("Logical").tag(Mode.logical)
                    Text("Free").tag(Mode.free)
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let properties = CellProperties(font: .largeTitle,
                                           accentColor: Color.teal,
                                           borderWidth: 2.0,
                                           backgroundColor: .white)
    
    static var hexGrid = HexGrid()
    
    static var previews: some View {
        let publisher = PassthroughSubject<CellTapEvent, Never>()
        HexGridView(publisher: publisher)
            .environmentObject(hexGrid)
            .environment(\.cellProperties, properties)
            .frame(width: 500, height: 500)
            .previewLayout(.sizeThatFits)
    }
}
