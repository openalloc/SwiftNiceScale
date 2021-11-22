# SwiftNiceScale

Generate 'nice' numbers for label ticks over a range, such as for y-axis on a chart.

Adapted from pseudo-code in *Graphics Gems, Volume 1* by Andrew S. Glassner (1995). See also Tufte (1983) for a discussion of topic.

Available as an open source Swift library to be incorporated in other apps.

_SwiftNiceScale_ is part of the [OpenAlloc](https://github.com/openalloc) family of open source Swift software tools.

## NiceScale

<img src="https://github.com/openalloc/SwiftNiceScale/blob/main/Images/naive_nice.png" width="525" height="160"/>

```swift
let ns = NiceScale(105...543, desiredTicks: 5)

print("nice range=\(ns.range)")

=> "nice range=100.0...600.0"

print("tick interval=\(ns.tickInterval)")

=> "tick interval=100.0"

print("labels=\(ns.tickValues)")

=> "labels=[100.0, 200.0, 300.0, 400.0, 500.0, 600.0]"
```

## Types

The `ValueRange` type is declared within `NiceScale`, where `T` is your `BinaryFloatingPoint` data type:

```swift
typealias ValueRange = ClosedRange<T>
```

## Instance Properties and Methods

#### Initializer

- `init?(_ rawRange: NiceScale<T>.ValueRange, desiredTicks: Int)` - create a new `NiceScale` instance

Initialization will fail and return `nil` if provided nonsense parameters, such as a range with zero extent, or a desired tick count less than 2.

The initialization values are also available as properties:

- `let rawRange: NiceScale<T>.ValueRange` - the source range from which to calculate a nice scaling

- `let desiredTicks: Int` - the desired number of ticks in the scaling (default: 10)

#### Instance Properties

Computed properties are lazy, meaning that they are only calculated when first needed.

The basic set of properties...

- `var range: NiceScale<T>.ValueRange` - The calculated ‘nice’ range, which should include the ‘raw’ range used to initialize this object.

- `var extent: T` - The distance between bounds of the range.

- `var ticks: Int` - The number of ticks in the range. This may differ from the `desiredTicks` used to initialize the object.

- `var tickInterval: T` - The distance between ticks in the range.

- `var tickValues: [T]` - The values for the ticks in the range.

- `var tickFractionDigits: Int` - Number of fractional digits to show in tick label values.

More specialized properties dealing with positive and negative portions of scale...

- `var hasNegativeRange: Bool` - If true, the range includes negative values.

- `var hasPositiveRange: Bool` - If true, the range includes positive values.

- `var negativeRange: NiceScale<T>.ValueRange` - The portion of the range that is negative. `0…0` if none.

- `var positiveRange: NiceScale<T>.ValueRange` - The portion of the range that is positive. `0…0` if none.

- `var negativeExtent: T` - If there’s a negative portion of range, the distance between its lower bound and 0. A non-negative value.

- `var positiveExtent: T` - If there’s a positive portion of range, the distance between its upper bound and 0. A non-negative value.

- `var negativeExtentUnit: T?` - The negativeExtent, expressed as unit value in the range `0…1`.

- `var positiveExtentUnit: T?` - The positiveExtent, expressed as unit value in the range `0…1`.

#### Instance Methods

- `func scaleToUnit(T) -> T` - Scale value to `0…1` in the range. 

- `func scaleToUnitNegative(T) -> T` - Scale value to `0…1` in the negative portion of range, if any.

- `func scaleToUnitPositive(T) -> T` - Scale value to `0…1` in the positive portion of range, if any.

## See Also

Swift open-source libraries (by the same author):

* [AllocData](https://github.com/openalloc/AllocData) - standardized data formats for investing-focused apps and tools
* [FINporter](https://github.com/openalloc/FINporter) - library and command-line tool to transform various specialized finance-related formats to the standardized schema of AllocData
* [SwiftCompactor](https://github.com/openalloc/SwiftCompactor) - formatters for the concise display of Numbers, Currency, and Time Intervals
* [SwiftModifiedDietz](https://github.com/openalloc/SwiftModifiedDietz) - A tool for calculating portfolio performance using the Modified Dietz method
* [SwiftRegressor](https://github.com/openalloc/SwiftRegressor) - a linear regression tool that’s flexible and easy to use
* [SwiftSeriesResampler](https://github.com/openalloc/SwiftSeriesResampler) - transform a series of coordinate values into a new series with uniform intervals
* [SwiftSimpleTree](https://github.com/openalloc/SwiftSimpleTree) - a nested data structure that’s flexible and easy to use

And commercial apps using this library (by the same author):

* [FlowAllocator](https://flowallocator.app/FlowAllocator/index.html) - portfolio rebalancing tool for macOS
* [FlowWorth](https://flowallocator.app/FlowWorth/index.html) - a new portfolio performance and valuation tracking tool for macOS


## License

Copyright 2021 FlowAllocator LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

## Contributing

Other contributions are welcome too. You are encouraged to submit pull requests to fix bugs, improve documentation, or offer new features. 

The pull request need not be a production-ready feature or fix. It can be a draft of proposed changes, or simply a test to show that expected behavior is buggy. Discussion on the pull request can proceed from there.

Contributions should ultimately have adequate test coverage. See tests for current entities to see what coverage is expected.
