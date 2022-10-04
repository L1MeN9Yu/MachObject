//
// Created by Mengyu Li on 2020/7/29.
//

import Foundation

extension Data {
    mutating func nullify(range: Range<Int>) {
        let nullReplacement = Data(repeating: 0, count: range.count)
        replaceSubrange(range, with: nullReplacement)
    }
}

extension Data {
    mutating func replaceString(range: Range<Int>, filter: (String) -> Bool = { _ in true }, mapping: (String) -> String) {
        func stringRanges(in range: Range<Int>) -> [String: [Range<Int>]] {
            let enumeratedBytes: ArraySlice<(offset: Int, element: UInt8)> = Array(enumerated())[range]
            let chunksOfEnumeratedBytes = enumeratedBytes.split { _, data in data == 0 }
            let stringWithRangePairs: [(String, Range<Int>)] = chunksOfEnumeratedBytes.compactMap { chunk in
                let chunkBytes = chunk.map { _, data in data }
                guard let string = String(bytes: chunkBytes, encoding: .utf8) else { return nil }
                let chunkArray = Array(chunk)
                let range = (chunkArray.first!.offset..<(chunkArray.last!.offset + 1))
                return (string, range)
            }
            return Dictionary(grouping: stringWithRangePairs) { string, _ in string }
                .mapValues { $0.map { _, range in range } }
        }

        let rangesPerString = stringRanges(in: range)
        rangesPerString.filter { filter($0.key) }
            .forEach { (originalString: String, ranges: [Range<Int>]) in
                let mappedString = mapping(originalString)
                precondition(originalString.utf8.count >= mappedString.utf8.count)
                guard let mappedData = mappedString.data(using: .utf8) else { return }
                ranges.forEach { replaceWithPadding(range: $0, data: mappedData) }
            }
    }
}

extension Data {
    mutating func replaceWithPadding(range: Range<Int>, data: Data) {
        precondition(range.count >= data.count)
        let targetDataWithPadding = data + Array(repeating: UInt8(0), count: range.count - data.count)
        assert(range.count == targetDataWithPadding.count)
        replaceSubrange(range, with: targetDataWithPadding)
    }

    mutating func replaceWithPadding(range: Range<Int>, string: String) {
        guard let data = string.data(using: .utf8) else { fatalError() }
        replaceWithPadding(range: range, data: data)
    }
}
