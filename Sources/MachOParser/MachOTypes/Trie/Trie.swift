//
// Created by Mengyu Li on 2020/9/29.
//

import Foundation
@_implementationOnly import MachCore

public struct Trie {
    public let exportsSymbol: Bool
    public let labelRange: Range<UInt64>
    public private(set) var label: [UInt8]
    public private(set) var children: [Trie]

    init(data: Data, rootNodeOffset: Int) {
        self.init(data: data, rootNodeOffset: rootNodeOffset, nodeOffset: rootNodeOffset, label: [], labelRange: 0..<0)
    }

    private init(data: Data, rootNodeOffset: Int, nodeOffset: Int, label: [UInt8], labelRange: Range<UInt64>) {
        precondition(labelRange.count == label.count)
        self.label = label
        self.labelRange = labelRange
        (exportsSymbol, children) = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> (Bool, [Trie]) in
            var cursorPtr = bytes.baseAddress!.advanced(by: nodeOffset) // cursorPtr at node start
            let terminalSize = cursorPtr.readUleb128() // cursorPtr after terminal size
            let exportsSymbol = terminalSize != 0
            cursorPtr = cursorPtr.advanced(by: Int(terminalSize)) // cursorPtr at children count
            let childrenCount = cursorPtr.load(as: UInt8.self)
            cursorPtr = cursorPtr.advanced(by: 1) // cursorPtr at first child count
            var children: [Trie] = []
            for _ in 0..<childrenCount {
                let childLabelStart = bytes.baseAddress!.distance(to: cursorPtr)
                let childLabel = cursorPtr.readStringBytes()
                let childLabelRange = Range(offset: UInt64(childLabelStart), count: UInt64(childLabel.count))
                precondition(childLabelRange.upperBound <= data.count)
                let childOffset = rootNodeOffset + Int(cursorPtr.readUleb128())
                children.append(Trie(data: data, rootNodeOffset: rootNodeOffset, nodeOffset: childOffset, label: childLabel, labelRange: childLabelRange))
            }
            return (exportsSymbol, children)
        }
    }
}

extension Trie {
    var exportedLabelStrings: [String] {
        exportedLabels.compactMap { String(bytes: $0, encoding: .utf8) }
    }

    private var exportedLabels: [[UInt8]] {
        let childrenLabels = children.flatMap(\.exportedLabels).map { label + $0 }
        if exportsSymbol {
            return [label] + childrenLabels
        } else {
            return childrenLabels
        }
    }

    var flatNodes: [Trie] {
        var result = [self]
        var queue = [self]
        while let nextNode = queue.popLast() {
            let children = nextNode.children
            result += children
            queue += children
        }
        return result
    }
}

public extension Trie {
    struct FillResult {
        public var finalFillValue: UInt8
    }

    @discardableResult
    mutating func fillRecursively(startingWithFillValue initialFillValue: UInt8, minimumFillValue: UInt8) -> FillResult {
        label = Array(repeating: initialFillValue, count: label.count)
        var childFillValue = label.isEmpty
            ? initialFillValue // children won't get any prefix from their parent, need to iterate the parent's fillValue
            : minimumFillValue // children are safe to be filled with independent enumeration
        for childIdx in children.indices {
            let fillResult = children[childIdx].fillRecursively(startingWithFillValue: childFillValue,
                                                                minimumFillValue: minimumFillValue)
            childFillValue = fillResult.finalFillValue // child decides about syncing the iterator back
        }

        if label.isEmpty {
            // need to sync parent fillValue iterator back
            return FillResult(finalFillValue: childFillValue)
        } else {
            // children use independent iteration, just increment parent's fillValue iterator
            let addResult = initialFillValue.addingReportingOverflow(1)
            guard !addResult.overflow else {
                fatalError("Trie label values probably exhausted at \(labelRange)")
            }
            return FillResult(finalFillValue: addResult.partialValue)
        }
    }
}
