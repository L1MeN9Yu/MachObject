//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation

public protocol SectionContent {
    associatedtype Value
    var value: Value { get }
    init(machoData: Data, range: Range<UInt64>)
}
