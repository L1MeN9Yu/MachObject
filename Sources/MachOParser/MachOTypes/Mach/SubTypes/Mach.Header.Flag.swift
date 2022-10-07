//
// Created by Mengyu Li on 2020/7/28.
//

import Foundation
import MachO

public extension Mach.Header {
    enum Flag: Option {
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

        public var value: Int64 {
            switch self {
            case .noundefs:
                return Int64(MH_NOUNDEFS)
            case .incrlink:
                return Int64(MH_INCRLINK)
            case .dyldlink:
                return Int64(MH_DYLDLINK)
            case .bindatload:
                return Int64(MH_BINDATLOAD)
            case .prebound:
                return Int64(MH_PREBOUND)
            case .splitSegs:
                return Int64(MH_SPLIT_SEGS)
            case .lazyInit:
                return Int64(MH_LAZY_INIT)
            case .twolevel:
                return Int64(MH_TWOLEVEL)
            case .forceFlat:
                return Int64(MH_FORCE_FLAT)
            case .nomultidefs:
                return Int64(MH_NOMULTIDEFS)
            case .nofixprebinding:
                return Int64(MH_NOFIXPREBINDING)
            case .prebindable:
                return Int64(MH_PREBINDABLE)
            case .allmodsbound:
                return Int64(MH_ALLMODSBOUND)
            case .subsectionsViaSymbols:
                return Int64(MH_SUBSECTIONS_VIA_SYMBOLS)
            case .canonical:
                return Int64(MH_CANONICAL)
            case .weakDefines:
                return Int64(MH_WEAK_DEFINES)
            case .bindsToWeak:
                return Int64(MH_BINDS_TO_WEAK)
            case .allowStackExecution:
                return Int64(MH_ALLOW_STACK_EXECUTION)
            case .rootSafe:
                return Int64(MH_ROOT_SAFE)
            case .setuidSafe:
                return Int64(MH_SETUID_SAFE)
            case .noReexportedDylibs:
                return Int64(MH_NO_REEXPORTED_DYLIBS)
            case .pie:
                return Int64(MH_PIE)
            case .deadStrippableDylib:
                return Int64(MH_DEAD_STRIPPABLE_DYLIB)
            case .hasTlvDescriptors:
                return Int64(MH_HAS_TLV_DESCRIPTORS)
            case .noHeapExecution:
                return Int64(MH_NO_HEAP_EXECUTION)
            case .appExtensionSafe:
                return Int64(MH_APP_EXTENSION_SAFE)
            case .nlistOutofsyncWithDyldinfo:
                return Int64(MH_NLIST_OUTOFSYNC_WITH_DYLDINFO)
            case .simSupport:
                return Int64(MH_SIM_SUPPORT)
            case .dylibInCache:
                return Int64(MH_DYLIB_IN_CACHE)
            }
        }
    }
}

extension Mach.Header.Flag: CustomStringConvertible {
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

public extension Mach.Header {
    typealias Flags = Set<Flag>
}
