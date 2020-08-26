//
// Created by Mengyu Li on 2020/8/6.
//

import Foundation

func globalFunc() -> Int {
    let a = SwiftStruct(value: 0)
    print("\(a)")
    let b = SwiftStruct.Inner(value: 1)
    print("\(b)")
    print("\(SwiftStruct.innerType)")
    return 0
}

exit(Int32(globalFunc()))
