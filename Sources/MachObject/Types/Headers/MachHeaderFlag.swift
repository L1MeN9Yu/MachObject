//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

public enum MachHeaderFlag: Option {
	case noundefs
	case incrlink
	case dyldlink
	case bindatload
	case prebound
	case splitSegs
	case lazyInit
	case twolevel
	case forceFlat
	case nomultidefs
	case nofixprebinding
	case prebindable
	case allmodsbound
	case subsectionsViaSymbols
	case canonical
	case weakDefines
	case bindsToWeak
	case allowStackExecution
	case rootSafe
	case setuidSafe
	case noReexportedDylibs
	case pie
	case deadStrippableDylib
	case hasTlvDescriptors
	case noHeapExecution
	case appExtensionSafe
	case nlistOutofsyncWithDyldinfo
	case simSupport
	case dylibInCache

	public var value: Int {
		switch self {
		case .noundefs:
			return Int(MH_NOUNDEFS)
		case .incrlink:
			return Int(MH_INCRLINK)
		case .dyldlink:
			return Int(MH_DYLDLINK)
		case .bindatload:
			return Int(MH_BINDATLOAD)
		case .prebound:
			return Int(MH_PREBOUND)
		case .splitSegs:
			return Int(MH_SPLIT_SEGS)
		case .lazyInit:
			return Int(MH_LAZY_INIT)
		case .twolevel:
			return Int(MH_TWOLEVEL)
		case .forceFlat:
			return Int(MH_FORCE_FLAT)
		case .nomultidefs:
			return Int(MH_NOMULTIDEFS)
		case .nofixprebinding:
			return Int(MH_NOFIXPREBINDING)
		case .prebindable:
			return Int(MH_PREBINDABLE)
		case .allmodsbound:
			return Int(MH_ALLMODSBOUND)
		case .subsectionsViaSymbols:
			return Int(MH_SUBSECTIONS_VIA_SYMBOLS)
		case .canonical:
			return Int(MH_CANONICAL)
		case .weakDefines:
			return Int(MH_WEAK_DEFINES)
		case .bindsToWeak:
			return Int(MH_BINDS_TO_WEAK)
		case .allowStackExecution:
			return Int(MH_ALLOW_STACK_EXECUTION)
		case .rootSafe:
			return Int(MH_ROOT_SAFE)
		case .setuidSafe:
			return Int(MH_SETUID_SAFE)
		case .noReexportedDylibs:
			return Int(MH_NO_REEXPORTED_DYLIBS)
		case .pie:
			return Int(MH_PIE)
		case .deadStrippableDylib:
			return Int(MH_DEAD_STRIPPABLE_DYLIB)
		case .hasTlvDescriptors:
			return Int(MH_HAS_TLV_DESCRIPTORS)
		case .noHeapExecution:
			return Int(MH_NO_HEAP_EXECUTION)
		case .appExtensionSafe:
			return Int(MH_APP_EXTENSION_SAFE)
		case .nlistOutofsyncWithDyldinfo:
			return Int(MH_NLIST_OUTOFSYNC_WITH_DYLDINFO)
		case .simSupport:
			return Int(MH_SIM_SUPPORT)
		case .dylibInCache:
			return Int(MH_DYLIB_IN_CACHE)
		}
	}
}

extension MachHeaderFlag: CustomStringConvertible {
	public var description: String {
		switch self {
		case .noundefs:
			return "MH_NOUNDEFS"
		case .incrlink:
			return "MH_INCRLINK"
		case .dyldlink:
			return "MH_DYLDLINK"
		case .bindatload:
			return "MH_BINDATLOAD"
		case .prebound:
			return "MH_PREBOUND"
		case .splitSegs:
			return "MH_SPLIT_SEGS"
		case .lazyInit:
			return "MH_LAZY_INIT"
		case .twolevel:
			return "MH_TWOLEVEL"
		case .forceFlat:
			return "MH_FORCE_FLAT"
		case .nomultidefs:
			return "MH_NOMULTIDEFS"
		case .nofixprebinding:
			return "MH_NOFIXPREBINDING"
		case .prebindable:
			return "MH_PREBINDABLE"
		case .allmodsbound:
			return "MH_ALLMODSBOUND"
		case .subsectionsViaSymbols:
			return "MH_SUBSECTIONS_VIA_SYMBOLS"
		case .canonical:
			return "MH_CANONICAL"
		case .weakDefines:
			return "MH_WEAK_DEFINES"
		case .bindsToWeak:
			return "MH_BINDS_TO_WEAK"
		case .allowStackExecution:
			return "MH_ALLOW_STACK_EXECUTION"
		case .rootSafe:
			return "MH_ROOT_SAFE"
		case .setuidSafe:
			return "MH_SETUID_SAFE"
		case .noReexportedDylibs:
			return "MH_NO_REEXPORTED_DYLIBS"
		case .pie:
			return "MH_PIE"
		case .deadStrippableDylib:
			return "MH_DEAD_STRIPPABLE_DYLIB"
		case .hasTlvDescriptors:
			return "MH_HAS_TLV_DESCRIPTORS"
		case .noHeapExecution:
			return "MH_NO_HEAP_EXECUTION"
		case .appExtensionSafe:
			return "MH_APP_EXTENSION_SAFE"
		case .nlistOutofsyncWithDyldinfo:
			return "MH_NLIST_OUTOFSYNC_WITH_DYLDINFO"
		case .simSupport:
			return "MH_SIM_SUPPORT"
		case .dylibInCache:
			return "MH_DYLIB_IN_CACHE"
		}
	}
}
