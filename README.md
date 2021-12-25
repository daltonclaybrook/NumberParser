# NumberParser

A utility used to parse number strings, e.g. "eight thousand four hundred seventy-three"

## Usage

```swift
let input = "eight thousand four hundred seventy-three"
let result = Parser().parse(string: input)
switch result {
case .success(let value):
	print("Number: \(value)") // Number: 8473
case .failure(let error):
	// handle failure...
}
```

> More examples can be found in [ParserTests.swift](https://github.com/daltonclaybrook/NumberParser/blob/main/Tests/NumberParserTests/ParserTests.swift)

## Installation

In Xcode, you can add this package to your project by selecting File -> Swift Packages -> Add Package Dependency… Enter the NumberParser GitHub URL and follow the prompts.

If you use a Package.swift file instead, add the following line inside of your package dependencies array:

```swift
.package(url: "https://github.com/daltonclaybrook/NumberParser", from: "0.1.0"),
```

Now add NumberParser as a dependency of any relevant targets:

```swift
.target(name: "MyApp", dependencies: ["NumberParser"]),
```

## License

NumberParser is available under the MIT license. See [LICENSE.md](https://github.com/daltonclaybrook/NumberParser/blob/main/LICENSE.md) for more information.
