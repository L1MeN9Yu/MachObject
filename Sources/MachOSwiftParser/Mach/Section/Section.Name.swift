//
// Created by Mengyu Li on 2020/12/28.
//

import Foundation
import MachOParser

public extension SectionName {
    /// This section contains an array of 32-bit signed integers.
    /// Each integer is a relative offset that points to a protocol descriptor in the `__TEXT.__const` section.
    ///
    /// A protocol descriptor has the following format:
    /// ```
    /// type ProtocolDescriptor struct {
    ///    Flags                      uint32
    ///    Parent                     int32
    ///    Name                       int32
    ///    NumRequirementsInSignature uint32
    ///    NumRequirements            uint32
    ///    AssociatedTypeNames        int32
    ///  }
    /// ```
    static let __swift5_protos = Self(rawValue: "__swift5_protos")

    /// This section contains an array of 32-bit signed integers.
    /// Each integer is a relative offset that points to a protocol conformance descriptor in the `__TEXT.__const` section.
    ///
    /// A protocol conformance descriptor has the following format:
    /// ```
    /// type ProtocolConformanceDescriptor struct {
    ///    ProtocolDescriptor    int32
    ///    NominalTypeDescriptor int32
    ///    ProtocolWitnessTable  int32
    ///    ConformanceFlags      uint32
    ///  }
    /// ```
    static let __swift5_proto = Self(rawValue: "__swift5_proto")

    /// This section contains an array of 32-bit signed integers.
    /// Each integer is a relative offset that points to a nominal type descriptor in the `__TEXT.__const` section.
    /// A nominal type descriptor can take different formats based on what type it represents.
    /// There are different structures for `Enum`, `Struct` and `Class` types. They have the following format:
    /// ```
    /// type EnumDescriptor struct {
    ///    Flags                               uint32
    ///    Parent                              int32
    ///    Name                                int32
    ///    AccessFunction                      int32
    ///    FieldDescriptor                     int32
    ///    NumPayloadCasesAndPayloadSizeOffset uint32
    ///    NumEmptyCases                       uint32
    ///  }
    ///
    ///  type StructDescriptor struct {
    ///    Flags                   uint32
    ///    Parent                  int32
    ///    Name                    int32
    ///    AccessFunction          int32
    ///    FieldDescriptor         int32
    ///    NumFields               uint32
    ///    FieldOffsetVectorOffset uint32
    ///  }
    ///
    ///  type ClassDescriptor struct {
    ///    Flags                       uint32
    ///    Parent                      int32
    ///    Name                        int32
    ///    AccessFunction              int32
    ///    FieldDescriptor             int32
    ///    SuperclassType              int32
    ///    MetadataNegativeSizeInWords uint32
    ///    MetadataPositiveSizeInWords uint32
    ///    NumImmediateMembers         uint32
    ///    NumFields                   uint32
    ///  }
    /// ```
    static let __swift5_types = Self(rawValue: "__swift5_types")

    /// This section contains an array of field descriptors.
    /// A field descriptor contains a collection of field records for a single class, struct or enum declaration.
    /// Each field descriptor can be a different length depending on how many field records the type contains.
    ///
    /// A field descriptor has the following format:
    /// ```
    /// type FieldRecord struct {
    ///    Flags           uint32
    ///    MangledTypeName int32
    ///    FieldName       int32
    ///  }
    ///
    ///  type FieldDescriptor struct {
    ///    MangledTypeName int32
    ///    Superclass      int32
    ///    Kind            uint16
    ///    FieldRecordSize uint16
    ///    NumFields       uint32
    ///    FieldRecords    []FieldRecord
    ///  }
    /// ```
    static let __swift5_fieldmd = Self(rawValue: "__swift5_fieldmd")

    /// This section contains an array of associated type descriptors.
    /// An associated type descriptor contains a collection of associated type records for a conformance.
    /// An associated type records describe the mapping from an associated type to the type witness of a conformance.
    ///
    /// An associated type descriptor has the following format:
    /// ```
    /// type AssociatedTypeRecord struct {
    ///    Name                int32
    ///    SubstitutedTypeName int32
    ///  }
    ///
    ///  type AssociatedTypeDescriptor struct {
    ///    ConformingTypeName       int32
    ///    ProtocolTypeName         int32
    ///    NumAssociatedTypes       uint32
    ///    AssociatedTypeRecordSize uint32
    ///    AssociatedTypeRecords    []AssociatedTypeRecord
    ///  }
    /// ```
    static let __swift5_assocty = Self(rawValue: "__swift5_assocty")

    /// This section contains an array of builtin type descriptors.
    /// A builtin type descriptor describes the basic layout information about any builtin types referenced from other sections.
    ///
    /// A builtin type descriptor has the following format:
    /// ```
    /// type BuiltinTypeDescriptor struct {
    ///    TypeName            int32
    ///    Size                uint32
    ///    AlignmentAndFlags   uint32
    ///    Stride              uint32
    ///    NumExtraInhabitants uint32
    ///  }
    /// ```
    static let __swift5_builtin = Self(rawValue: "__swift5_builtin")

    /// Capture descriptors describe the layout of a closure context object.
    /// Unlike nominal types, the generic substitutions for a closure context come from the object, and not the metadata.
    ///
    /// A capture descriptor has the following format:
    /// ```
    /// type CaptureTypeRecord struct {
    ///    MangledTypeName int32
    ///  }
    ///
    ///  type MetadataSourceRecord struct {
    ///    MangledTypeName       int32
    ///    MangledMetadataSource int32
    ///  }
    ///
    ///  type CaptureDescriptor struct {
    ///    NumCaptureTypes       uint32
    ///    NumMetadataSources    uint32
    ///    NumBindings           uint32
    ///    CaptureTypeRecords    []CaptureTypeRecord
    ///    MetadataSourceRecords []MetadataSourceRecord
    ///  }
    /// ```
    static let __swift5_capture = Self(rawValue: "__swift5_capture")

    /// This section contains a list of mangled type names that are referenced from other sections.
    /// This is essentially all the different types that are used in the application.
    /// The Swift docs and code are the best places to find out more information about mangled type names.
    /// * https:///github.com/apple/swift/blob/master/docs/ABI/Mangling.rst
    /// * https:///github.com/apple/swift/blob/master/lib/Demangling/Demangler.cpp
    static let __swift5_typeref = Self(rawValue: "__swift5_typeref")

    /// This section contains an array of C strings.
    /// The strings are field names for the properties of the metadata defined in other sections.
    static let __swift5_reflstr = Self(rawValue: "__swift5_reflstr")

    /// This section contains dynamic replacement information.
    /// This is essentially the Swift equivalent of Objective-C method swizzling.
    /// You can read more about this Swift feature [here](https:///forums.swift.org/t/dynamic-method-replacement/16619).
    ///
    /// The dynamic replacement information has the following format:
    /// ```
    /// type Replacement struct {
    ///    ReplacedFunctionKey int32
    ///    NewFunction         int32
    ///    Replacement         int32
    ///    Flags               uint32
    ///  }
    ///
    ///  type ReplacementScope struct {
    ///    Flags uint32
    ///    NumReplacements uint32
    ///
    ///  }
    ///
    ///  type AutomaticReplacements struct {
    ///    Flags            uint32
    ///    NumReplacements  uint32 /// hard coded to 1
    ///    Replacements     int32
    ///  }
    /// ```
    static let __swift5_replace = Self(rawValue: "__swift5_replace")

    /// This section contains dynamic replacement information for opaque types.
    /// It’s not clear why this additional section was created instead of __swift5_replace but you can see the original pull request that implemented it [here](https:///github.com/apple/swift/pull/24781).
    ///
    /// The dynamic replacement information for opaque types has the following format:
    /// ```
    /// type Replacement struct {
    ///    Original    int32
    ///    Replacement int32
    ///  }
    ///
    ///  type AutomaticReplacementsSome struct {
    ///    Flags uint32
    ///    NumReplacements uint32
    ///    Replacements    []Replacement
    ///  }
    /// ```
    static let __swift5_replac2 = Self(rawValue: "__swift5_replac2")
}
