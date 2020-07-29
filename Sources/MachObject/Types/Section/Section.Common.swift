//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation

extension Section {
	public struct Common: SectionContent {
		public typealias Value = Data
		public let value: Value

		public init(machoData: Data, range: Range<UInt64>) {
			value = machoData.subdata(in: range.intRange)
		}
	}
}
