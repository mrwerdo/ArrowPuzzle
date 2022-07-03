//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Thompson on 3/7/2022.
//

import SwiftUI

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

struct CellView: View {
    var number: Int
    @Environment(\.cellProperties) var properties: CellProperties

    var body: some View {
        Text("\(number)")
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
    }
}

struct ColumnView: View {
    let numberOfElements: Int
    let spacing: Double
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<numberOfElements, id: \.self) { index in
                CellView(number: index)
            }
        }
    }
}

struct ContentView: View {
    let horizontalSpacing: Double = 0.0
    let verticalSpacing: Double = 0.0
    
    var body: some View {
        HStack(spacing: horizontalSpacing - 7) {
            ColumnView(numberOfElements: 4, spacing: verticalSpacing)
            ColumnView(numberOfElements: 5, spacing: verticalSpacing)
            ColumnView(numberOfElements: 6, spacing: verticalSpacing)
            ColumnView(numberOfElements: 7, spacing: verticalSpacing)
            ColumnView(numberOfElements: 6, spacing: verticalSpacing)
            ColumnView(numberOfElements: 5, spacing: verticalSpacing)
            ColumnView(numberOfElements: 4, spacing: verticalSpacing)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static let properties = CellProperties(font: .largeTitle,
                                           accentColor: Color.teal,
                                           borderWidth: 2.0,
                                           backgroundColor: .white)
    
    static var previews: some View {
        ContentView()
            .environment(\.cellProperties, properties)
            .frame(width: 500, height: 500)
            .previewLayout(.sizeThatFits)
    }
}
