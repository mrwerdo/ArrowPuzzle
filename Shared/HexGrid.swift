//
//  HexGrid.swift
//  ArrowPuzzle
//
//  Created by Andrew Thompson on 3/7/2022.
//

import Foundation
import SwiftUI
import Combine

struct HexGrid {
    private var cells: [Int]
    
    init() {
        let numberOfCells = 2 * (4 + 5 + 6) + 7
        cells = [Int](repeating: 0, count: numberOfCells)
    }
    
    private func index(column: Int, row: Int) -> Int {
        return numberOfCellsBefore(column: column) + row
    }
    
    private func numberOfCellsBefore(column y: Int) -> Int {
        // 7 - abs(3 - y) gives:
        // 6 - y = 4
        // 5 - y = 5
        // 4 - y = 6
        // 3 - y = 7
        // 2 - y = 6
        // 1 - y = 5
        // 0 - y = 4
        // But we want the cumulative sum of the number of cells.
        if y == 0 {
            return 0
        } else {
            return 7 - abs(3 - y) + numberOfCellsBefore(column: y - 1)
        }
    }
    
    subscript(col: Int, row: Int) -> Int {
        get {
            return cells[index(column: col, row: row)]
        }
        set {
            cells[index(column: col, row: row)] = min(0, max(6, newValue))
        }
    }
}
