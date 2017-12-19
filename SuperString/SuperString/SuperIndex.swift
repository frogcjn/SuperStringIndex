//
//  SuperIndex.swift
//  SuperString
//
//  Created by Cao, Jiannan on 2017/12/19.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

// MARK: - SuperIndex

struct SuperIndex : Comparable, Strideable, CustomStringConvertible {
    
    var owner: Substring
    var wrapped: String.Index
    
    init(_ wrapped: String.Index, _ owner: String) {
        self.wrapped = wrapped
        self.owner = owner[...]
    }
    
    init(_ wrapped: String.Index, _ owner: Substring) {
        self.wrapped = wrapped
        self.owner = owner
    }
    
    // Offset
    var offset: Int {
        return owner.distance(from: owner.startIndex, to: wrapped)
    }
    
    // Comparable
    static func <(lhs: SuperIndex, rhs: SuperIndex) -> Bool {
        return lhs.offset < rhs.offset
    }
    
    static func ==(lhs: SuperIndex, rhs: SuperIndex) -> Bool {
        return lhs.offset == rhs.offset
    }
    
    // Strideable
    typealias Stride = String.IndexDistance
    
    func distance(to other: SuperIndex) -> SuperIndex.Stride {
        return owner.distance(from: wrapped, to: other.wrapped)
    }
    
    func advanced(by n: SuperIndex.Stride) -> SuperIndex {
        return SuperIndex(owner.index(wrapped, offsetBy: n), owner)
    }
    
    static  func +(lhs: SuperIndex, rhs: SuperIndex.Stride) -> SuperIndex {
        return lhs.advanced(by: rhs)
    }
    
    static  func -(lhs: SuperIndex, rhs: SuperIndex.Stride) -> SuperIndex {
        return lhs.advanced(by: -rhs)
    }
    
    // CustomStringConvertible
    
    var description: String {
        return offset.description
    }
}

extension Int {
    init(_ superIndex:SuperIndex) {
        self = superIndex.offset
    }
}
