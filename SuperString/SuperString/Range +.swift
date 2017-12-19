//
//  File.swift
//  SuperString
//
//  Created by Cao, Jiannan on 2017/12/19.
//  Copyright © 2017年 Cao, Jiannan. All rights reserved.
//

// MARK: - Range +

protocol LowerPartialRangeExpression : RangeExpression {
    var lowerBound : Bound { get }
    init(_ lowerBound: Bound)
    func map<T, R: LowerPartialRangeExpression>(_ transform: (Bound) throws -> T) rethrows -> R where R.Bound == T
    func map<T, R: UpperPartialRangeExpression>(_ transform: (Bound) throws -> T) rethrows -> R where R.Bound == T
}

extension LowerPartialRangeExpression {
    func map<T, R: LowerPartialRangeExpression>(_ transform: (Bound) throws -> T) rethrows -> R where R.Bound == T {
        return try R(transform(lowerBound))
    }
    func map<T, R: UpperPartialRangeExpression>(_ transform: (Bound) throws -> T) rethrows -> R where R.Bound == T {
        return try R(transform(lowerBound))
    }
}

protocol UpperPartialRangeExpression : RangeExpression {
    var upperBound : Bound { get }
    init(_ lowerBound: Bound)
    func map<T, R: UpperPartialRangeExpression>(_ transform: (Bound) throws -> T) rethrows -> R where R.Bound == T
    func map<T, R: LowerPartialRangeExpression>(_ transform: (Bound) throws -> T) rethrows -> R where R.Bound == T
}

extension UpperPartialRangeExpression {
    func map<T, R: UpperPartialRangeExpression>(_ transform: (Bound) throws -> T) rethrows -> R where R.Bound == T {
        return try R(transform(upperBound))
    }
    func map<T, R: LowerPartialRangeExpression>(_ transform: (Bound) throws -> T) rethrows -> R where R.Bound == T {
        return try R(transform(upperBound))
    }
}

protocol CompletedRangeExpression : RangeExpression {
    var lowerBound : Bound { get }
    var upperBound : Bound { get }
    init(uncheckedBounds: (lower: Bound, upper: Bound))
    func map<T, R: CompletedRangeExpression>(_ transform: (Bound) throws -> T) rethrows -> R where R.Bound == T
}

extension CompletedRangeExpression {
    func map<T, R: CompletedRangeExpression>(_ transform: (Bound) throws -> T) rethrows -> R where R.Bound == T {
        let x = try transform(lowerBound)
        let y = try transform(upperBound)
        return R(uncheckedBounds: (lower: min(x,y),  upper: max(x, y)))
    }
}

extension CountablePartialRangeFrom : LowerPartialRangeExpression {
}
extension PartialRangeFrom : LowerPartialRangeExpression {
}

extension PartialRangeThrough : UpperPartialRangeExpression {
}
extension PartialRangeUpTo : UpperPartialRangeExpression {
}


extension CountableClosedRange : CompletedRangeExpression {
}
extension ClosedRange : CompletedRangeExpression {
}
extension CountableRange : CompletedRangeExpression {
}
extension Range : CompletedRangeExpression {
}

extension CompletedRangeExpression {
    static func +<T, R: CompletedRangeExpression>(lhs: T, rhs: Self) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return rhs.map { lhs.advanced(by: $0) }
    }
    static func +<T, R: CompletedRangeExpression>(lhs: Self, rhs: T) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return lhs.map { rhs.advanced(by: $0) }
    }
    static func -<T, R: CompletedRangeExpression>(lhs: T, rhs: Self) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return rhs.map { lhs.advanced(by: -$0) }
    }
    static func -<T, R: CompletedRangeExpression>(lhs: Self, rhs: T) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return lhs.map { rhs.advanced(by: -$0) }
    }
}

extension UpperPartialRangeExpression {
    static func +<T, R: UpperPartialRangeExpression>(lhs: T, rhs: Self) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return rhs.map { lhs.advanced(by: $0) }
    }
    static func +<T, R: UpperPartialRangeExpression>(lhs: Self, rhs: T) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return lhs.map { rhs.advanced(by: $0) }
    }
    static func -<T, R: LowerPartialRangeExpression>(lhs: T, rhs: Self) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return rhs.map { lhs.advanced(by: -$0) }
    }
    static func -<T, R: UpperPartialRangeExpression>(lhs: Self, rhs: T) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return lhs.map { rhs.advanced(by: -$0) }
    }
}

extension LowerPartialRangeExpression {
    static func +<T, R: LowerPartialRangeExpression>(lhs: T, rhs: Self) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return rhs.map { lhs.advanced(by: $0) }
    }
    static func +<T, R: LowerPartialRangeExpression>(lhs: Self, rhs: T) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return lhs.map { rhs.advanced(by: $0) }
    }
    static func -<T, R: LowerPartialRangeExpression>(lhs: T, rhs: Self) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return rhs.map { lhs.advanced(by: -$0) }
    }
    static func -<T, R: UpperPartialRangeExpression>(lhs: Self, rhs: T) -> R where R.Bound == T, T: Strideable, T.Stride == Bound {
        return lhs.map { rhs.advanced(by: -$0) }
    }
}
