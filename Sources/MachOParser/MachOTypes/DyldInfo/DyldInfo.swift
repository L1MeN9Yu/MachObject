//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation

public struct DyldInfo: Equatable {
    let rebase: Range<UInt64>
    let bind: Range<UInt64>
    let weakBind: Range<UInt64>
    let lazyBind: Range<UInt64>
    let exportRange: Range<UInt64>
}

public extension DyldInfo {
    init(dyldInfoOnlyLC: DyldInfoOnlyLC) {
        rebase = Range(offset: UInt64(dyldInfoOnlyLC.rebaseOffset), count: UInt64(dyldInfoOnlyLC.rebaseSize))
        bind = Range(offset: UInt64(dyldInfoOnlyLC.bindOffset), count: UInt64(dyldInfoOnlyLC.bindSize))
        lazyBind = Range(offset: UInt64(dyldInfoOnlyLC.weakBindOffset), count: UInt64(dyldInfoOnlyLC.weakBindSize))
        weakBind = Range(offset: UInt64(dyldInfoOnlyLC.lazyBindOffset), count: UInt64(dyldInfoOnlyLC.lazyBindSize))
        exportRange = Range(offset: UInt64(dyldInfoOnlyLC.exportOffset), count: UInt64(dyldInfoOnlyLC.exportSize))
    }

    init(dyldInfoLC: DyldInfoLC) {
        rebase = Range(offset: UInt64(dyldInfoLC.rebaseOffset), count: UInt64(dyldInfoLC.rebaseSize))
        bind = Range(offset: UInt64(dyldInfoLC.bindOffset), count: UInt64(dyldInfoLC.bindSize))
        lazyBind = Range(offset: UInt64(dyldInfoLC.weakBindOffset), count: UInt64(dyldInfoLC.weakBindSize))
        weakBind = Range(offset: UInt64(dyldInfoLC.lazyBindOffset), count: UInt64(dyldInfoLC.lazyBindSize))
        exportRange = Range(offset: UInt64(dyldInfoLC.exportOffset), count: UInt64(dyldInfoLC.exportSize))
    }
}
