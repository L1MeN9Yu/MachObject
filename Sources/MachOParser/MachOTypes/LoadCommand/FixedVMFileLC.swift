//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct FixedVMFileLC: LoadCommand {
    public static let id = UInt32(LC_FVMFILE)

    public let name: String

    public let headerAddress: UInt32 /* files virtual address */

    public init(machData: Data, offset: Int) {
        let fvmfile: fvmfile_command = machData.get(atOffset: offset)
        headerAddress = fvmfile.header_addr
        name = String(data: machData, offset: offset, commandSize: Int(fvmfile.cmdsize), loadCommandString: fvmfile.name)
    }

    public init(pointer: UnsafeRawPointer) {
        let fvmfile: fvmfile_command = pointer.get()
        headerAddress = fvmfile.header_addr
        name = String(loadCommandPointer: pointer, commandSize: Int(fvmfile.cmdsize), loadCommandString: fvmfile.name)
    }
}
