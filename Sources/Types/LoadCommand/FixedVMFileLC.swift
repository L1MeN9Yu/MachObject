//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation
import MachO

public struct FixedVMFileLC: LoadCommand {
    public static let id: UInt32 = UInt32(LC_FVMFILE)

    public let name: String

    public let headerAddress: UInt32 /* files virtual address */

    public init(machData: Data, offset: Int) {
        let fvmfile: fvmfile_command = machData.get(atOffset: offset)
        name = String(data: machData, offset: offset, commandSize: MemoryLayout<fvmfile_command>.size, loadCommandString: fvmfile.name)
        headerAddress = fvmfile.header_addr
    }
}
