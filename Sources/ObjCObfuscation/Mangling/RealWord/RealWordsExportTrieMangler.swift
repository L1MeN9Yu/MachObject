//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation
import MachOParser

final class RealWordsExportTrieMangler: RealWordsExportTrieMangling {
    private let minimumFillValue: UInt8 = 1

    init() {}

    func mangle(trie: Trie) -> Trie {
        // In case of Mach-O trie binary-representation, a root trie node doesn't even have a space to store its label.
        // That's why it is always empty in the `Trie` struct. But it feels unsafe to pass `0` for
        // `fillingRootLabelWith`, because `0` is a cstring end marker.
        var mutableTrie = trie
        mutableTrie.fillRecursively(startingWithFillValue: minimumFillValue,
                                    minimumFillValue: minimumFillValue)
        return mutableTrie
    }
}
