//
// Created by Mengyu Li on 2020/7/24.
//

import Foundation

public protocol LoadCommand {
	static var id: UInt32 { get }
	init(machData: Data, offset: Int)
}
