//
//  SuperString.swift
//  SuperString
//
//  Created by Cao, Jiannan on 2017/12/19.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

// MARK: - SuperString

public struct SuperString : StringWrapperProtocol {
    public var wrapped: String
    public init(wrapped: String) {
        self.wrapped = wrapped
    }
    
    public typealias Index = SuperIndex<Substring>
    public typealias SubSequence = SuperSubstring
    
    public var startIndex: Index {
        return SuperIndex(wrapped.startIndex, wrapped)
    }
    
    public var endIndex: Index {
        return SuperIndex(wrapped.endIndex, wrapped)
    }
    
    public func index(after i: Index) -> Index {
        return SuperIndex(wrapped.index(after: i.wrapped), wrapped)
    }
    
    // BidrectionalCollection
    
    public func index(before i: Index) -> Index {
        return SuperIndex(wrapped.index(before: i.wrapped), wrapped)
    }
    
    // start, end, index(after i: Int) -> indices: DefaultIndices
    
    public subscript(position: Index) -> Character {
        return wrapped[position.wrapped]
    }
    
    public subscript(bounds: Range<Index>) -> SuperSubstring {
        return SuperSubstring(wrapped: wrapped[bounds.map { $0.wrapped }])
    }
}

// MARK: - SuperSubstring

public struct SuperSubstring : StringWrapperProtocol {
    public var wrapped: Substring
    public init(wrapped: Substring) {
        self.wrapped = wrapped
    }
    
    public typealias Index = SuperIndex<Substring>
    public typealias SubSequence = SuperSubstring
    
    public var startIndex: Index {
        return SuperIndex(wrapped.startIndex, wrapped)
    }
    
    public var endIndex: Index {
        return SuperIndex(wrapped.endIndex, wrapped)
    }
    
    public func index(after i: Index) -> Index {
        return SuperIndex(wrapped.index(after: i.wrapped), wrapped)
    }
    
    // BidrectionalCollection
    
    public func index(before i: Index) -> Index {
        return SuperIndex(wrapped.index(before: i.wrapped), wrapped)
    }
    
    // start, end, index(after i: Int) -> indices: DefaultIndices
    
    public subscript(position: Index) -> Character {
        return wrapped[position.wrapped]
    }
    
    public subscript(bounds: Range<Index>) -> SuperSubstring {
        return SuperSubstring(wrapped: wrapped[bounds.map { $0.wrapped }])
    }
}

// MARK: - StringWrapperProtocol

public protocol StringWrapperProtocol : StringProtocol {
    associatedtype Wrapped : StringProtocol
    
    var wrapped: Wrapped { get set }
    init(wrapped: Wrapped)
}

public extension StringWrapperProtocol {
    
    /* Collection

        typealias SubSequence = Substring
        typealias Index = SuperIndex
        var startIndex: Index
        var endIndex: Index
        func index(after i: Index) -> Index
        func index(before i: Index) -> Index
        subscript(position: Index) -> Character
    */
    
    // CustomStringConvertible
    var description: String {
        return wrapped.description
    }
    
    
    // LosslessStringConvertible
    init?(_ description: String) {
        if let wrapped = Wrapped(description) {
            self.init(wrapped: wrapped)
        } else {
            return nil
        }
    }
    
    // ExpressibleByExtendedGraphemeClusterLiteral
    init(extendedGraphemeClusterLiteral value: Wrapped.ExtendedGraphemeClusterLiteralType) {
        self.init(wrapped: Wrapped(extendedGraphemeClusterLiteral: value))
    }
    
    /* ExpressibleByUnicodeScalarLiteral:
     init(unicodeScalarLiteral value: Wrapped.UnicodeScalarLiteralType)
     */
    
    // ExpressibleByStringLiteral
    init(stringLiteral value: Wrapped.StringLiteralType) {
        self.init(wrapped: Wrapped(stringLiteral: value))
    }
    
    // TextOutputStream
    mutating func write(_ string: String) {
        wrapped.write(string)
    }
    
    // TextOutputStreamable
    func write<Target>(to target: inout Target) where Target : TextOutputStream {
        return wrapped.write(to: &target)
    }
    
    // StringProtocol
    var utf8: Wrapped.UTF8View {
        return wrapped.utf8
    }
    
    var utf16: Wrapped.UTF16View {
        return wrapped.utf16
    }
    
    var unicodeScalars: Wrapped.UnicodeScalarView {
        return wrapped.unicodeScalars
    }
    
    func hasPrefix(_ prefix: String) -> Bool {
        return wrapped.hasPrefix(prefix)
    }
    
    func hasSuffix(_ prefix: String) -> Bool {
        return wrapped.hasSuffix(prefix)
    }
    
    func lowercased() -> String {
        return wrapped.lowercased()
    }
    
    func uppercased() -> String {
        return wrapped.uppercased()
    }
    
    init<C, Encoding>(decoding codeUnits: C, as sourceEncoding: Encoding.Type) where C : Collection, Encoding : _UnicodeEncoding, C.Element == Encoding.CodeUnit {
        self.init(wrapped: Wrapped(decoding: codeUnits, as: sourceEncoding))
    }
    
    init(cString nullTerminatedUTF8: UnsafePointer<CChar>) {
        self.init(wrapped: Wrapped(cString: nullTerminatedUTF8))
    }
    
    init<Encoding>(decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>, as sourceEncoding: Encoding.Type) where Encoding : _UnicodeEncoding {
        self.init(wrapped: Wrapped(decodingCString: nullTerminatedCodeUnits, as: sourceEncoding))
    }
    
    func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
        return try wrapped.withCString(body)
    }
    
    func withCString<Result, Encoding>(encodedAs targetEncoding: Encoding.Type, _ body: (UnsafePointer<Encoding.CodeUnit>) throws -> Result) rethrows -> Result where Encoding : _UnicodeEncoding {
        return try wrapped.withCString(encodedAs: targetEncoding, body)
    }
}
