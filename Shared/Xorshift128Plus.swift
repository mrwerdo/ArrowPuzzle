//
//  Xorshift128Plus.swift
//  ArrowPuzzle
//
//  Created by Andrew Thompson on 5/7/2022.
//

import Foundation

/// Swift version of Xorshift+ from: https://en.wikipedia.org/wiki/Xorshift
struct Xorshift128Plus: RandomNumberGenerator {
    private var xS: UInt64
    private var yS: UInt64
    
    /// Two seeds, `x` and `y`, are required for the random number generator (default values are provided for both).
    init(_ xSeed: UInt64, _ ySeed:  UInt64) {
        xS = xSeed == 0 && ySeed == 0 ? UInt64.max : xSeed // Seed cannot be all zeros.
        yS = ySeed
    }
    
    init() {
        xS = UInt64.random(in: 0..<UInt64.max)
        yS = xS
        while (yS == xS) {
            yS = UInt64.random(in: 0..<UInt64.max)
        }
    }
    
    mutating func next() -> UInt64 {
        var x = xS
        let y = yS
        xS = y
        x ^= x << 23 // a
        yS = x ^ y ^ (x >> 17) ^ (y >> 26) // b, c
        return yS &+ y
    }
}
