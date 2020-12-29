//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation
import MachOParser

struct ObfuscationSymbols {
    let whiteList: ObjCSymbols
    let blackList: ObjCSymbols
    let removedList: ObjCSymbols
    let exportTriesPerCpuIdPerURL: [URL: [CpuId: Trie]]
}
