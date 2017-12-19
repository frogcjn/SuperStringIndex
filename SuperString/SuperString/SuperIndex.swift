//
//  SuperIndex.swift
//  SuperString
//
//  Created by Cao, Jiannan on 2017/12/19.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

// MARK: - SuperIndex

public struct SuperIndex : Comparable, Strideable, CustomStringConvertible {
    
    public let owner: Substring
    public let wrapped: String.Index
    
    public init(_ wrapped: String.Index, _ owner: String) {
        self.wrapped = wrapped
        self.owner = owner[...]
    }
    
    public init(_ wrapped: String.Index, _ owner: Substring) {
        self.wrapped = wrapped
        self.owner = owner
    }
    
    // Offset
    public var offset: Int {
        return owner.distance(from: owner.startIndex, to: wrapped)
    }
    
    // Comparable
    public static func <(lhs: SuperIndex, rhs: SuperIndex) -> Bool {
        return lhs.offset < rhs.offset
    }
    
    public static func ==(lhs: SuperIndex, rhs: SuperIndex) -> Bool {
        return lhs.offset == rhs.offset
    }
    
    // Strideable
    public typealias Stride = String.IndexDistance
    
    public func distance(to other: SuperIndex) -> SuperIndex.Stride {
        return owner.distance(from: wrapped, to: other.wrapped)
    }
    
    public func advanced(by n: SuperIndex.Stride) -> SuperIndex {
        return SuperIndex(owner.index(wrapped, offsetBy: n), owner)
    }
    
    public static  func +(lhs: SuperIndex, rhs: SuperIndex.Stride) -> SuperIndex {
        return lhs.advanced(by: rhs)
    }
    
    public static  func -(lhs: SuperIndex, rhs: SuperIndex.Stride) -> SuperIndex {
        return lhs.advanced(by: -rhs)
    }
    
    // CustomStringConvertible
    
    public var description: String {
        return offset.description
    }
}

public extension Int {
    init(_ superIndex:SuperIndex) {
        self = superIndex.offset
    }
}
