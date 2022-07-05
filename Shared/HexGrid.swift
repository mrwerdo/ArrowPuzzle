//
//  HexGrid.swift
//  ArrowPuzzle
//
//  Created by Andrew Thompson on 3/7/2022.
//

import Foundation
import Combine

class HexGrid : ObservableObject {
    private struct Dimensions {
        var numberOfColumns: Int
        var numberOfCells: Int {
            return numberOfCellsBefore(column: numberOfColumns)
        }
        
        func lengthOfColumn(_ c: Int) -> Int {
            // fixme: hard coded constant
            return numberOfColumns - abs(3 - c)
        }
        
        func index(column: Int, row: Int) -> Int {
            return numberOfCellsBefore(column: column) + row
        }
        
        func numberOfCellsBefore(column y: Int) -> Int {
            if y == 0 {
                return 0
            } else {
                return lengthOfColumn(y - 1) + numberOfCellsBefore(column: y - 1)
            }
        }
    }
    
    let objectWillChange = ObservableObjectPublisher()
    
    private var cells: [Int]
    private let dimensions: Dimensions
    
    init() {
        dimensions = Dimensions(numberOfColumns: 7)
        cells = [Int](repeating: 0, count: dimensions.numberOfCells)
    }
    
    func lengthOfColumn(_ c: Int) -> Int {
        return dimensions.lengthOfColumn(c)
    }
    
    subscript(col: Int, row: Int) -> Int {
        get {
            return cells[dimensions.index(column: col, row: row)]
        }
        set {
            let clampedNewValue = newValue % 6
            let index = dimensions.index(column: col, row: row)
            let oldValue = cells[index]
            if clampedNewValue != oldValue {
                objectWillChange.send()
            }
            cells[index] = clampedNewValue
        }
    }
    
    private func isValidNeighbour(_ column: Int, _ row: Int) -> Bool {
        if !(0..<dimensions.numberOfColumns).contains(column) {
            return false
        }
        let length = lengthOfColumn(column)
        if !(0..<length).contains(row) {
            return false
        }
        return true
    }
    
    private func neighbours(at column: Int, _ row: Int) -> [(Int, Int)] {
        // Row values need one subtracted depending on whether the cell is located to the left or
        // right of the center.
        // fixme: this logic is incorrect for an even number of columns
        let l_adj = column - 1 < dimensions.numberOfColumns/2 ? -1 : 0
        let r_adj = column + 1 > dimensions.numberOfColumns/2 ? -1 : 0
        return [
            (column, row - 1),              // top
            (column, row),                  // center
            (column, row + 1),              // bottom
            (column + 1, row + r_adj),      // right top
            (column + 1, row + r_adj + 1),  // right bottom
            (column - 1, row + l_adj),      // left bottom
            (column - 1, row + l_adj + 1),  // left top
        ]
    }
    
    func updateLogical(_ column: Int, _ row: Int, by amount: Int = 1) {
        objectWillChange.send()
        for (y, x) in neighbours(at: column, row) where isValidNeighbour(y, x) {
            self[y, x] += amount
        }
    }
    
    func reset() {
        objectWillChange.send()
        cells = [Int](repeating: 0, count: dimensions.numberOfCells)
    }
    
    func randomize<T: RandomNumberGenerator>(using generator: inout T) {
        objectWillChange.send()
        for index in 0..<cells.count {
            cells[index] = (0..<6).randomElement(using: &generator) ?? 0
        }
    }
    
    func randomize() {
        objectWillChange.send()
        for index in 0..<cells.count {
            cells[index] = (0..<6).randomElement() ?? 0
        }
    }
}
