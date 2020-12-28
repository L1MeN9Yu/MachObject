//
// Created by Mengyu Li on 2020/12/28.
//

import Foundation
import MachOParser

extension Mach {
    func fileOffset<I: UnsignedInteger>(fromVmOffset vmOffset: I) -> Int {
        var self = self
        guard let segment = segments.first(where: { $0.vmRange.contains(UInt64(vmOffset)) }) else {
            fatalError("vmOffset \(vmOffset) does not exist in the image")
        }

        let fileOffset = Int(segment.fileRange.lowerBound + (UInt64(vmOffset) - segment.vmRange.lowerBound))
        return fileOffset
    }
}
