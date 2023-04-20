//
// NiceScale.swift
//
// Copyright 2021, 2022 OpenAlloc LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import Numerics

public final class NiceScale<T: BinaryFloatingPoint & Real> {
    public typealias ValueRange = ClosedRange<T>

    public let rawRange: ValueRange
    public let desiredTicks: Int

    public init?(_ rawRange: ValueRange, desiredTicks: Int = 10) {
        guard rawRange.lowerBound < rawRange.upperBound, desiredTicks > 1 else { return nil }
        self.rawRange = rawRange
        self.desiredTicks = desiredTicks
    }

    // MARK: - Range

    /// The calculated 'nice' range, which should include the 'raw' range used to initialize this object.
    public lazy var range: ValueRange = {
        guard tickInterval != 0 else { return 0 ... 0 } // avoid NaN error in creating range
        let min = floor(rawRange.lowerBound / tickInterval) * tickInterval
        let max = ceil(rawRange.upperBound / tickInterval) * tickInterval
        return min ... max
    }()

    /// The distance between bounds of the range.
    public lazy var extent: T = range.upperBound - range.lowerBound

    // MARK: - Ticks

    /// The number of ticks in the range. This may differ from the desiredTicks used to initialize the object.
    public lazy var ticks: Int = {
        guard tickInterval > 0 else { return 0 }
        return Int(extent / tickInterval) + 1
    }()

    /// The values for the ticks in the range.
    public lazy var tickValues: [T] = (0 ..< ticks).map {
        range.lowerBound + (T($0) * tickInterval)
    }

    /// The distance between ticks in the range.
    public lazy var tickInterval: T = {
        let rawExtent = rawRange.upperBound - rawRange.lowerBound
        let niceExtent = niceify(rawExtent, round: false)
        return niceify(niceExtent / T(desiredTicks - 1), round: true)
    }()

    /// Number of fractional digits to show in tick label values.
    public lazy var tickFractionDigits: Int = {
        let exponent = floor(T.log10(tickInterval))
        let nfrac = max(-1 * exponent, 0.0)
        return Int(nfrac)
    }()

    // MARK: - Positive/Negative Range

    /// If true, the range includes positive values.
    public lazy var hasPositiveRange: Bool = range.upperBound > 0

    /// If true, the range includes negative values.
    public lazy var hasNegativeRange: Bool = range.lowerBound < 0

    /// The portion of the range that is positive. 0...0 if none.
    public lazy var positiveRange: ValueRange = max(0, range.lowerBound) ... max(0, range.upperBound)

    /// The portion of the range that is negative. 0...0 if none.
    public lazy var negativeRange: ValueRange = min(0, range.lowerBound) ... min(0, range.upperBound)

    /// If there's a positive portion of range, the distance between its upper bound and 0. A non-negative value.
    public lazy var positiveExtent: T = positiveRange.upperBound - positiveRange.lowerBound

    /// If there's a negative portion of range, the distance between its lower bound and 0. A non-negative value.
    public lazy var negativeExtent: T = negativeRange.upperBound - negativeRange.lowerBound

    /// The positiveExtent, expressed as unit value in the range 0...1.
    public lazy var positiveExtentUnit: T? = {
        guard extent != T.zero else { return nil }
        return positiveExtent / extent
    }()

    /// The negativeExtent, expressed as unit value in the range 0...1.
    public lazy var negativeExtentUnit: T? = {
        guard extent != T.zero else { return nil }
        return negativeExtent / extent
    }()
}

extension NiceScale {
    /// Returns a "nice" number approximately equal to range.
    /// If round = true, rounds the number, otherwise returns its ceiling.
    private func niceify(_ x: T, round: Bool) -> T {
        let exp = floor(T.log10(x)) // exponent of x
        let f = x / T.pow(10, exp) // fractional part of x, in 1...10
        let niceFraction: T = {
            if round {
                if f < 1.5 {
                    return 1
                } else if f < 3 {
                    return 2
                } else if f < 7 {
                    return 5
                } else {
                    return 10
                }
            } else {
                if f <= 1 {
                    return 1
                } else if f <= 2 {
                    return 2
                } else if f <= 5 {
                    return 5
                } else {
                    return 10
                }
            }
        }()
        return niceFraction * T.pow(10, exp)
    }
}

// MARK: - Scaling methods

public extension NiceScale {
    /// Scale value to 0...1 in the range.
    @inlinable
    func scaleToUnit(_ val: T) -> T {
        (val - range.lowerBound) / extent
    }

    /// Scale value to 0...1 in the positive portion of range, if any.
    @inlinable
    func scaleToUnitPositive(_ val: T) -> T {
        (val - positiveRange.lowerBound) / positiveExtent
    }

    /// Scale value to 0...1 in the negative portion of range, if any.
    @inlinable
    func scaleToUnitNegative(_ val: T) -> T {
        1 - ((val - negativeRange.lowerBound) / negativeExtent)
    }
}
