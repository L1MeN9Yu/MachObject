//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct ThreadLC: LoadCommand {
    public static let id = UInt32(LC_THREAD)

    public init(machData: Data, offset: Int) {}

    public init(pointer: UnsafeRawPointer) {}
}
