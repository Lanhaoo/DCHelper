//
//  DCArray.swift
//  DCHelper
//
//  Created by Laura Torres on 2023/11/29.
//

import Foundation
public extension Array{
    
    func splitLength(length: Int) -> [[Element]] {
        stride(from: 0, to: count, by: length).map {
            Array(self[$0..<Swift.min($0 + length, count)])
        }
    }
    
    func get(at index: Int) -> Element? {
        guard index >= 0 && index < count else { return nil }
        return self[index]
    }
    
}
