func integers(count: Int) -> [Int] {
    var integers = [Int]()
    for i in 0..<count {
        integers.append(i)
    }
    return integers
}

func parameters(count: Int, prefix: String, separator: String, drop: Int = 0) -> String {
    return separator.join(integers(count)[drop..<count].map { "\(prefix)\($0)" })
}

let upperPrefix = "T"
let lowerPrefix = "t"

let n = 16

print("infix operator <*> {")
print("    precedence 130")
print("    associativity left")
print("}")
print("infix operator <^> {")
print("    precedence 130")
print("    associativity left")
print("}")
print("")

for i in 2...n {
    let commpaSeparatedParameters = parameters(i, prefix: upperPrefix, separator: ", ")
    let arrowSeparatedParameters = parameters(i, prefix: upperPrefix, separator: " -> ")
    print("public func curry<\(commpaSeparatedParameters), R>(f: (\(commpaSeparatedParameters)) -> R) -> \(arrowSeparatedParameters) -> R {")
    print("    return { " + parameters(i, prefix: lowerPrefix, separator: " in { ") + " in f(" + parameters(i, prefix: lowerPrefix, separator: ", ") + ")" + "".join([String](count: i, repeatedValue: " }")))
    print("}")
    print("")
}

print("// Optional")
print("")
print("public func <*><T0, T1>(lhs: (T0 -> T1)?, rhs: T0?) -> T1? {")
print("    switch lhs {")
print("    case .None:")
print("        return nil")
print("    case .Some(let transform):")
print("        return rhs.map(transform)")
print("    }")
print("}")
print("")
print("public func <^><T0, R>(lhs: T0 -> R, rhs: T0?) -> R? {")
print("    return rhs.map { lhs($0) }")
print("}")
print("")

for i in 2...n {
    let commpaSeparatedParameters = parameters(i, prefix: upperPrefix, separator: ", ")
    let arrowSeparatedParameters = parameters(i, prefix: upperPrefix, separator: " -> ", drop: 1)
    print("public func <^><\(commpaSeparatedParameters), R>(lhs: (\(commpaSeparatedParameters)) -> R, rhs: \(upperPrefix)0?) -> (\(arrowSeparatedParameters) -> R)? {")
    print("    return curry(lhs) <^> rhs")
    print("}")
    print("")
}

print("// Array")
print("")
print("public func <*><T0, T1>(lhs: [T0 -> T1], rhs: [T0]) -> [T1] {")
print("    return lhs.flatMap { f in rhs.map { t0 in f(t0) } }")
print("}")
print("")
print("public func <^><T0, R>(lhs: T0 -> R, rhs: [T0]) -> [R] {")
print("    return rhs.map { lhs($0) }")
print("}")
print("")

for i in 2...n {
    let commpaSeparatedParameters = parameters(i, prefix: upperPrefix, separator: ", ")
    let arrowSeparatedParameters = parameters(i, prefix: upperPrefix, separator: " -> ", drop: 1)
    print("public func <^><\(commpaSeparatedParameters), R>(lhs: (\(commpaSeparatedParameters)) -> R, rhs: [\(upperPrefix)0]) -> [\(arrowSeparatedParameters) -> R] {")
    print("    return rhs.map { curry(lhs)($0) }")
    print("}")
    print("")
}
