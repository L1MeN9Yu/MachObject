//
// Created by Mengyu Li on 2020/12/30.
//

import Foundation
@_implementationOnly import MachLog

public enum Measurer {}

public extension Measurer {
    static func time<R>(label: String, action: () -> R) -> R {
        let start = Date()
        let result = action()
        let end = Date()

        logger.info("\(label) -- execution took \(end.timeIntervalSince(start)) seconds")

        return result
    }
}
