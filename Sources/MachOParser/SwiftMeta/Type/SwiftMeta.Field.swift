//
// Created by Mengyu Li on 2020/8/10.
//

import Foundation

extension SwiftMeta {
    struct Field {
        let name: String
        let type: String

        let mangledTypeNameOffset: Int

        init(name: String, type: String, mangledTypeNameOffset: Int) {
            self.name = name
            self.type = type
            self.mangledTypeNameOffset = mangledTypeNameOffset
        }
    }
}
