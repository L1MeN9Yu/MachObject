//
// Created by Mengyu Li on 2020/12/29.
//

import Foundation
import MachOParser

protocol RealWordsExportTrieMangling: AnyObject {
    func mangle(trie: Trie) -> Trie
}
