//
// Created by Mengyu Li on 2020/8/10.
//

import Foundation

extension SwiftMeta {
    struct ClassType {
        let name: String
        let superName: String?

        let mangledName: String

        let fields: [Field]
    }
}
