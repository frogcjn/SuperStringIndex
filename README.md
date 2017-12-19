# SuperStringIndex
StringIndex with reference of string to calculate the offset

SuperString is a special version of String. Its index keeps a reference to the string, let the index calculate the offset.
```Swift
let a: SuperString = "01234"
let o = a.startIndex
let o1 = o + 4
print(a[o]) // 0
print(a[...]) // 01234
print(a[..<(o+2)]) // 01
print(a[...(o+2)]) // 012
print(a[(o+2)...]) // 234
print(a[o+2..<o+3]) // 2
print(a[o1-2...o1-1]) // 23

if let number = a.index(of: "1") {
    print(number) // 1
    print(a[number...]) // 1234
}

if let number = a.index(where: { $0 > "1" }) {
    print(number) // 2
}

let b = a[(o+1)...]
let z = b.startIndex
let z1 = z + 4
print(b[z]) // 1
print(b[...]) // 1234
print(b[..<(z+2)]) // 12
print(b[...(z+2)]) // 123
print(b[(z+2)...]) // 34
print(b[z+2...z+3]) // 34
print(b[z1-2...z1-2]) // 3

if let number = b.index(of: "1") {
    print(number) // 0
}

if let number = b.index(where: { $0 > "1" }) {
    print(number) // 1
}

print(a[o + (0...4)]) // 01234
print(a[o + ..<2 as PartialRangeUpTo]) // 01
print(a[o + ...2 as PartialRangeThrough]) // 012
print(a[o + 2... as PartialRangeFrom]) // 234
print(a[o + (2..<3)]) // 2
print(a[o1 - (1...2)]) // 23

```
