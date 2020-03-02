// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: ConstraintSolving.proto

#define INTERNAL_SUPPRESS_PROTOBUF_FIELD_DEPRECATION
#include "ConstraintSolving.pb.h"

#include <algorithm>

#include <google/protobuf/stubs/common.h>
#include <google/protobuf/stubs/once.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/generated_message_reflection.h>
#include <google/protobuf/reflection_ops.h>
#include <google/protobuf/wire_format.h>
// @@protoc_insertion_point(includes)

namespace klee {
namespace data {

namespace {

const ::google::protobuf::Descriptor* SolverQuery_descriptor_ = NULL;
const ::google::protobuf::internal::GeneratedMessageReflection*
  SolverQuery_reflection_ = NULL;
const ::google::protobuf::Descriptor* SolverQuerySet_descriptor_ = NULL;
const ::google::protobuf::internal::GeneratedMessageReflection*
  SolverQuerySet_reflection_ = NULL;
const ::google::protobuf::EnumDescriptor* QueryReason_descriptor_ = NULL;
const ::google::protobuf::EnumDescriptor* QueryOperation_descriptor_ = NULL;

}  // namespace


void protobuf_AssignDesc_ConstraintSolving_2eproto() {
  protobuf_AddDesc_ConstraintSolving_2eproto();
  const ::google::protobuf::FileDescriptor* file =
    ::google::protobuf::DescriptorPool::generated_pool()->FindFileByName(
      "ConstraintSolving.proto");
  GOOGLE_CHECK(file != NULL);
  SolverQuery_descriptor_ = file->message_type(0);
  static const int SolverQuery_offsets_[8] = {
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuery, time_stamp_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuery, reason_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuery, operation_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuery, solving_time_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuery, debug_info_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuery, shadow_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuery, incremental_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuery, execution_state_),
  };
  SolverQuery_reflection_ =
    new ::google::protobuf::internal::GeneratedMessageReflection(
      SolverQuery_descriptor_,
      SolverQuery::default_instance_,
      SolverQuery_offsets_,
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuery, _has_bits_[0]),
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuery, _unknown_fields_),
      -1,
      ::google::protobuf::DescriptorPool::generated_pool(),
      ::google::protobuf::MessageFactory::generated_factory(),
      sizeof(SolverQuery));
  SolverQuerySet_descriptor_ = file->message_type(1);
  static const int SolverQuerySet_offsets_[1] = {
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuerySet, solver_query_),
  };
  SolverQuerySet_reflection_ =
    new ::google::protobuf::internal::GeneratedMessageReflection(
      SolverQuerySet_descriptor_,
      SolverQuerySet::default_instance_,
      SolverQuerySet_offsets_,
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuerySet, _has_bits_[0]),
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(SolverQuerySet, _unknown_fields_),
      -1,
      ::google::protobuf::DescriptorPool::generated_pool(),
      ::google::protobuf::MessageFactory::generated_factory(),
      sizeof(SolverQuerySet));
  QueryReason_descriptor_ = file->enum_type(0);
  QueryOperation_descriptor_ = file->enum_type(1);
}

namespace {

GOOGLE_PROTOBUF_DECLARE_ONCE(protobuf_AssignDescriptors_once_);
inline void protobuf_AssignDescriptorsOnce() {
  ::google::protobuf::GoogleOnceInit(&protobuf_AssignDescriptors_once_,
                 &protobuf_AssignDesc_ConstraintSolving_2eproto);
}

void protobuf_RegisterTypes(const ::std::string&) {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedMessage(
    SolverQuery_descriptor_, &SolverQuery::default_instance());
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedMessage(
    SolverQuerySet_descriptor_, &SolverQuerySet::default_instance());
}

}  // namespace

void protobuf_ShutdownFile_ConstraintSolving_2eproto() {
  delete SolverQuery::default_instance_;
  delete SolverQuery_reflection_;
  delete SolverQuerySet::default_instance_;
  delete SolverQuerySet_reflection_;
}

void protobuf_AddDesc_ConstraintSolving_2eproto() {
  static bool already_here = false;
  if (already_here) return;
  already_here = true;
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::klee::data::protobuf_AddDesc_DebugInfo_2eproto();
  ::klee::data::protobuf_AddDesc_States_2eproto();
  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
    "\n\027ConstraintSolving.proto\022\tklee.data\032\017De"
    "bugInfo.proto\032\014States.proto\"\220\002\n\013SolverQu"
    "ery\022\022\n\ntime_stamp\030\001 \002(\004\022&\n\006reason\030\007 \002(\0162"
    "\026.klee.data.QueryReason\022,\n\toperation\030\010 \002"
    "(\0162\031.klee.data.QueryOperation\022\024\n\014solving"
    "_time\030\006 \002(\004\022(\n\ndebug_info\030\n \001(\0132\024.klee.d"
    "ata.DebugInfo\022\016\n\006shadow\030\t \001(\010\022\023\n\013increme"
    "ntal\030\013 \001(\010\0222\n\017execution_state\030\014 \001(\0132\031.kl"
    "ee.data.ExecutionState\">\n\016SolverQuerySet"
    "\022,\n\014solver_query\030\001 \003(\0132\026.klee.data.Solve"
    "rQuery*\365\002\n\013QueryReason\022\t\n\005OTHER\020\000\022\026\n\022BRA"
    "NCH_FEASIBILITY\020\001\022\026\n\022SWITCH_FEASIBILITY\020"
    "\006\022\035\n\031EXPRESSION_CONCRETIZATION\020\004\022#\n\037BRAN"
    "CH_CONDITION_CONCRETIZATION\020\002\022 \n\034EXTERNA"
    "L_CALL_CONCRETIZATION\020\010\022\024\n\020CHECK_UNIQUEN"
    "ESS\020\003\022\024\n\020CHECK_ASSUMPTION\020\014\022\022\n\016USER_GET_"
    "VALUE\020\005\022\035\n\031SINGLE_ADDRESS_RESOLUTION\020\007\022\034"
    "\n\030MULTI_ADDRESS_RESOLUTION\020\r\022\027\n\023FUNCTION"
    "_RESOLUTION\020\n\022\025\n\021ALLOC_RANGE_CHECK\020\t\022\030\n\024"
    "TEST_CASE_GENERATION\020\013*\234\001\n\016QueryOperatio"
    "n\022\014\n\010EVALUATE\020\001\022\020\n\014MUST_BE_TRUE\020\002\022\021\n\rMUS"
    "T_BE_FALSE\020\003\022\017\n\013MAY_BE_TRUE\020\004\022\020\n\014MAY_BE_"
    "FALSE\020\005\022\r\n\tGET_VALUE\020\006\022\026\n\022GET_INITIAL_VA"
    "LUES\020\007\022\r\n\tGET_RANGE\020\010", 941);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "ConstraintSolving.proto", &protobuf_RegisterTypes);
  SolverQuery::default_instance_ = new SolverQuery();
  SolverQuerySet::default_instance_ = new SolverQuerySet();
  SolverQuery::default_instance_->InitAsDefaultInstance();
  SolverQuerySet::default_instance_->InitAsDefaultInstance();
  ::google::protobuf::internal::OnShutdown(&protobuf_ShutdownFile_ConstraintSolving_2eproto);
}

// Force AddDescriptors() to be called at static initialization time.
struct StaticDescriptorInitializer_ConstraintSolving_2eproto {
  StaticDescriptorInitializer_ConstraintSolving_2eproto() {
    protobuf_AddDesc_ConstraintSolving_2eproto();
  }
} static_descriptor_initializer_ConstraintSolving_2eproto_;
const ::google::protobuf::EnumDescriptor* QueryReason_descriptor() {
  protobuf_AssignDescriptorsOnce();
  return QueryReason_descriptor_;
}
bool QueryReason_IsValid(int value) {
  switch(value) {
    case 0:
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
    case 11:
    case 12:
    case 13:
      return true;
    default:
      return false;
  }
}

const ::google::protobuf::EnumDescriptor* QueryOperation_descriptor() {
  protobuf_AssignDescriptorsOnce();
  return QueryOperation_descriptor_;
}
bool QueryOperation_IsValid(int value) {
  switch(value) {
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
      return true;
    default:
      return false;
  }
}


// ===================================================================

#ifndef _MSC_VER
const int SolverQuery::kTimeStampFieldNumber;
const int SolverQuery::kReasonFieldNumber;
const int SolverQuery::kOperationFieldNumber;
const int SolverQuery::kSolvingTimeFieldNumber;
const int SolverQuery::kDebugInfoFieldNumber;
const int SolverQuery::kShadowFieldNumber;
const int SolverQuery::kIncrementalFieldNumber;
const int SolverQuery::kExecutionStateFieldNumber;
#endif  // !_MSC_VER

SolverQuery::SolverQuery()
  : ::google::protobuf::Message() {
  SharedCtor();
}

void SolverQuery::InitAsDefaultInstance() {
  debug_info_ = const_cast< ::klee::data::DebugInfo*>(&::klee::data::DebugInfo::default_instance());
  execution_state_ = const_cast< ::klee::data::ExecutionState*>(&::klee::data::ExecutionState::default_instance());
}

SolverQuery::SolverQuery(const SolverQuery& from)
  : ::google::protobuf::Message() {
  SharedCtor();
  MergeFrom(from);
}

void SolverQuery::SharedCtor() {
  _cached_size_ = 0;
  time_stamp_ = GOOGLE_ULONGLONG(0);
  reason_ = 0;
  operation_ = 1;
  solving_time_ = GOOGLE_ULONGLONG(0);
  debug_info_ = NULL;
  shadow_ = false;
  incremental_ = false;
  execution_state_ = NULL;
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
}

SolverQuery::~SolverQuery() {
  SharedDtor();
}

void SolverQuery::SharedDtor() {
  if (this != default_instance_) {
    delete debug_info_;
    delete execution_state_;
  }
}

void SolverQuery::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* SolverQuery::descriptor() {
  protobuf_AssignDescriptorsOnce();
  return SolverQuery_descriptor_;
}

const SolverQuery& SolverQuery::default_instance() {
  if (default_instance_ == NULL) protobuf_AddDesc_ConstraintSolving_2eproto();
  return *default_instance_;
}

SolverQuery* SolverQuery::default_instance_ = NULL;

SolverQuery* SolverQuery::New() const {
  return new SolverQuery;
}

void SolverQuery::Clear() {
  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    time_stamp_ = GOOGLE_ULONGLONG(0);
    reason_ = 0;
    operation_ = 1;
    solving_time_ = GOOGLE_ULONGLONG(0);
    if (has_debug_info()) {
      if (debug_info_ != NULL) debug_info_->::klee::data::DebugInfo::Clear();
    }
    shadow_ = false;
    incremental_ = false;
    if (has_execution_state()) {
      if (execution_state_ != NULL) execution_state_->::klee::data::ExecutionState::Clear();
    }
  }
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
  mutable_unknown_fields()->Clear();
}

bool SolverQuery::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!(EXPRESSION)) return false
  ::google::protobuf::uint32 tag;
  while ((tag = input->ReadTag()) != 0) {
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // required uint64 time_stamp = 1;
      case 1: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::uint64, ::google::protobuf::internal::WireFormatLite::TYPE_UINT64>(
                 input, &time_stamp_)));
          set_has_time_stamp();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(48)) goto parse_solving_time;
        break;
      }

      // required uint64 solving_time = 6;
      case 6: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_solving_time:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::uint64, ::google::protobuf::internal::WireFormatLite::TYPE_UINT64>(
                 input, &solving_time_)));
          set_has_solving_time();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(56)) goto parse_reason;
        break;
      }

      // required .klee.data.QueryReason reason = 7;
      case 7: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_reason:
          int value;
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   int, ::google::protobuf::internal::WireFormatLite::TYPE_ENUM>(
                 input, &value)));
          if (::klee::data::QueryReason_IsValid(value)) {
            set_reason(static_cast< ::klee::data::QueryReason >(value));
          } else {
            mutable_unknown_fields()->AddVarint(7, value);
          }
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(64)) goto parse_operation;
        break;
      }

      // required .klee.data.QueryOperation operation = 8;
      case 8: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_operation:
          int value;
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   int, ::google::protobuf::internal::WireFormatLite::TYPE_ENUM>(
                 input, &value)));
          if (::klee::data::QueryOperation_IsValid(value)) {
            set_operation(static_cast< ::klee::data::QueryOperation >(value));
          } else {
            mutable_unknown_fields()->AddVarint(8, value);
          }
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(72)) goto parse_shadow;
        break;
      }

      // optional bool shadow = 9;
      case 9: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_shadow:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   bool, ::google::protobuf::internal::WireFormatLite::TYPE_BOOL>(
                 input, &shadow_)));
          set_has_shadow();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(82)) goto parse_debug_info;
        break;
      }

      // optional .klee.data.DebugInfo debug_info = 10;
      case 10: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
         parse_debug_info:
          DO_(::google::protobuf::internal::WireFormatLite::ReadMessageNoVirtual(
               input, mutable_debug_info()));
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(88)) goto parse_incremental;
        break;
      }

      // optional bool incremental = 11;
      case 11: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_incremental:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   bool, ::google::protobuf::internal::WireFormatLite::TYPE_BOOL>(
                 input, &incremental_)));
          set_has_incremental();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(98)) goto parse_execution_state;
        break;
      }

      // optional .klee.data.ExecutionState execution_state = 12;
      case 12: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
         parse_execution_state:
          DO_(::google::protobuf::internal::WireFormatLite::ReadMessageNoVirtual(
               input, mutable_execution_state()));
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectAtEnd()) return true;
        break;
      }

      default: {
      handle_uninterpreted:
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_END_GROUP) {
          return true;
        }
        DO_(::google::protobuf::internal::WireFormat::SkipField(
              input, tag, mutable_unknown_fields()));
        break;
      }
    }
  }
  return true;
#undef DO_
}

void SolverQuery::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // required uint64 time_stamp = 1;
  if (has_time_stamp()) {
    ::google::protobuf::internal::WireFormatLite::WriteUInt64(1, this->time_stamp(), output);
  }

  // required uint64 solving_time = 6;
  if (has_solving_time()) {
    ::google::protobuf::internal::WireFormatLite::WriteUInt64(6, this->solving_time(), output);
  }

  // required .klee.data.QueryReason reason = 7;
  if (has_reason()) {
    ::google::protobuf::internal::WireFormatLite::WriteEnum(
      7, this->reason(), output);
  }

  // required .klee.data.QueryOperation operation = 8;
  if (has_operation()) {
    ::google::protobuf::internal::WireFormatLite::WriteEnum(
      8, this->operation(), output);
  }

  // optional bool shadow = 9;
  if (has_shadow()) {
    ::google::protobuf::internal::WireFormatLite::WriteBool(9, this->shadow(), output);
  }

  // optional .klee.data.DebugInfo debug_info = 10;
  if (has_debug_info()) {
    ::google::protobuf::internal::WireFormatLite::WriteMessageMaybeToArray(
      10, this->debug_info(), output);
  }

  // optional bool incremental = 11;
  if (has_incremental()) {
    ::google::protobuf::internal::WireFormatLite::WriteBool(11, this->incremental(), output);
  }

  // optional .klee.data.ExecutionState execution_state = 12;
  if (has_execution_state()) {
    ::google::protobuf::internal::WireFormatLite::WriteMessageMaybeToArray(
      12, this->execution_state(), output);
  }

  if (!unknown_fields().empty()) {
    ::google::protobuf::internal::WireFormat::SerializeUnknownFields(
        unknown_fields(), output);
  }
}

::google::protobuf::uint8* SolverQuery::SerializeWithCachedSizesToArray(
    ::google::protobuf::uint8* target) const {
  // required uint64 time_stamp = 1;
  if (has_time_stamp()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteUInt64ToArray(1, this->time_stamp(), target);
  }

  // required uint64 solving_time = 6;
  if (has_solving_time()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteUInt64ToArray(6, this->solving_time(), target);
  }

  // required .klee.data.QueryReason reason = 7;
  if (has_reason()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteEnumToArray(
      7, this->reason(), target);
  }

  // required .klee.data.QueryOperation operation = 8;
  if (has_operation()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteEnumToArray(
      8, this->operation(), target);
  }

  // optional bool shadow = 9;
  if (has_shadow()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteBoolToArray(9, this->shadow(), target);
  }

  // optional .klee.data.DebugInfo debug_info = 10;
  if (has_debug_info()) {
    target = ::google::protobuf::internal::WireFormatLite::
      WriteMessageNoVirtualToArray(
        10, this->debug_info(), target);
  }

  // optional bool incremental = 11;
  if (has_incremental()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteBoolToArray(11, this->incremental(), target);
  }

  // optional .klee.data.ExecutionState execution_state = 12;
  if (has_execution_state()) {
    target = ::google::protobuf::internal::WireFormatLite::
      WriteMessageNoVirtualToArray(
        12, this->execution_state(), target);
  }

  if (!unknown_fields().empty()) {
    target = ::google::protobuf::internal::WireFormat::SerializeUnknownFieldsToArray(
        unknown_fields(), target);
  }
  return target;
}

int SolverQuery::ByteSize() const {
  int total_size = 0;

  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    // required uint64 time_stamp = 1;
    if (has_time_stamp()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::UInt64Size(
          this->time_stamp());
    }

    // required .klee.data.QueryReason reason = 7;
    if (has_reason()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::EnumSize(this->reason());
    }

    // required .klee.data.QueryOperation operation = 8;
    if (has_operation()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::EnumSize(this->operation());
    }

    // required uint64 solving_time = 6;
    if (has_solving_time()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::UInt64Size(
          this->solving_time());
    }

    // optional .klee.data.DebugInfo debug_info = 10;
    if (has_debug_info()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::MessageSizeNoVirtual(
          this->debug_info());
    }

    // optional bool shadow = 9;
    if (has_shadow()) {
      total_size += 1 + 1;
    }

    // optional bool incremental = 11;
    if (has_incremental()) {
      total_size += 1 + 1;
    }

    // optional .klee.data.ExecutionState execution_state = 12;
    if (has_execution_state()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::MessageSizeNoVirtual(
          this->execution_state());
    }

  }
  if (!unknown_fields().empty()) {
    total_size +=
      ::google::protobuf::internal::WireFormat::ComputeUnknownFieldsSize(
        unknown_fields());
  }
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = total_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void SolverQuery::MergeFrom(const ::google::protobuf::Message& from) {
  GOOGLE_CHECK_NE(&from, this);
  const SolverQuery* source =
    ::google::protobuf::internal::dynamic_cast_if_available<const SolverQuery*>(
      &from);
  if (source == NULL) {
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
    MergeFrom(*source);
  }
}

void SolverQuery::MergeFrom(const SolverQuery& from) {
  GOOGLE_CHECK_NE(&from, this);
  if (from._has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (from.has_time_stamp()) {
      set_time_stamp(from.time_stamp());
    }
    if (from.has_reason()) {
      set_reason(from.reason());
    }
    if (from.has_operation()) {
      set_operation(from.operation());
    }
    if (from.has_solving_time()) {
      set_solving_time(from.solving_time());
    }
    if (from.has_debug_info()) {
      mutable_debug_info()->::klee::data::DebugInfo::MergeFrom(from.debug_info());
    }
    if (from.has_shadow()) {
      set_shadow(from.shadow());
    }
    if (from.has_incremental()) {
      set_incremental(from.incremental());
    }
    if (from.has_execution_state()) {
      mutable_execution_state()->::klee::data::ExecutionState::MergeFrom(from.execution_state());
    }
  }
  mutable_unknown_fields()->MergeFrom(from.unknown_fields());
}

void SolverQuery::CopyFrom(const ::google::protobuf::Message& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void SolverQuery::CopyFrom(const SolverQuery& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool SolverQuery::IsInitialized() const {
  if ((_has_bits_[0] & 0x0000000f) != 0x0000000f) return false;

  if (has_execution_state()) {
    if (!this->execution_state().IsInitialized()) return false;
  }
  return true;
}

void SolverQuery::Swap(SolverQuery* other) {
  if (other != this) {
    std::swap(time_stamp_, other->time_stamp_);
    std::swap(reason_, other->reason_);
    std::swap(operation_, other->operation_);
    std::swap(solving_time_, other->solving_time_);
    std::swap(debug_info_, other->debug_info_);
    std::swap(shadow_, other->shadow_);
    std::swap(incremental_, other->incremental_);
    std::swap(execution_state_, other->execution_state_);
    std::swap(_has_bits_[0], other->_has_bits_[0]);
    _unknown_fields_.Swap(&other->_unknown_fields_);
    std::swap(_cached_size_, other->_cached_size_);
  }
}

::google::protobuf::Metadata SolverQuery::GetMetadata() const {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::Metadata metadata;
  metadata.descriptor = SolverQuery_descriptor_;
  metadata.reflection = SolverQuery_reflection_;
  return metadata;
}


// ===================================================================

#ifndef _MSC_VER
const int SolverQuerySet::kSolverQueryFieldNumber;
#endif  // !_MSC_VER

SolverQuerySet::SolverQuerySet()
  : ::google::protobuf::Message() {
  SharedCtor();
}

void SolverQuerySet::InitAsDefaultInstance() {
}

SolverQuerySet::SolverQuerySet(const SolverQuerySet& from)
  : ::google::protobuf::Message() {
  SharedCtor();
  MergeFrom(from);
}

void SolverQuerySet::SharedCtor() {
  _cached_size_ = 0;
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
}

SolverQuerySet::~SolverQuerySet() {
  SharedDtor();
}

void SolverQuerySet::SharedDtor() {
  if (this != default_instance_) {
  }
}

void SolverQuerySet::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* SolverQuerySet::descriptor() {
  protobuf_AssignDescriptorsOnce();
  return SolverQuerySet_descriptor_;
}

const SolverQuerySet& SolverQuerySet::default_instance() {
  if (default_instance_ == NULL) protobuf_AddDesc_ConstraintSolving_2eproto();
  return *default_instance_;
}

SolverQuerySet* SolverQuerySet::default_instance_ = NULL;

SolverQuerySet* SolverQuerySet::New() const {
  return new SolverQuerySet;
}

void SolverQuerySet::Clear() {
  solver_query_.Clear();
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
  mutable_unknown_fields()->Clear();
}

bool SolverQuerySet::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!(EXPRESSION)) return false
  ::google::protobuf::uint32 tag;
  while ((tag = input->ReadTag()) != 0) {
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // repeated .klee.data.SolverQuery solver_query = 1;
      case 1: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
         parse_solver_query:
          DO_(::google::protobuf::internal::WireFormatLite::ReadMessageNoVirtual(
                input, add_solver_query()));
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(10)) goto parse_solver_query;
        if (input->ExpectAtEnd()) return true;
        break;
      }

      default: {
      handle_uninterpreted:
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_END_GROUP) {
          return true;
        }
        DO_(::google::protobuf::internal::WireFormat::SkipField(
              input, tag, mutable_unknown_fields()));
        break;
      }
    }
  }
  return true;
#undef DO_
}

void SolverQuerySet::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // repeated .klee.data.SolverQuery solver_query = 1;
  for (int i = 0; i < this->solver_query_size(); i++) {
    ::google::protobuf::internal::WireFormatLite::WriteMessageMaybeToArray(
      1, this->solver_query(i), output);
  }

  if (!unknown_fields().empty()) {
    ::google::protobuf::internal::WireFormat::SerializeUnknownFields(
        unknown_fields(), output);
  }
}

::google::protobuf::uint8* SolverQuerySet::SerializeWithCachedSizesToArray(
    ::google::protobuf::uint8* target) const {
  // repeated .klee.data.SolverQuery solver_query = 1;
  for (int i = 0; i < this->solver_query_size(); i++) {
    target = ::google::protobuf::internal::WireFormatLite::
      WriteMessageNoVirtualToArray(
        1, this->solver_query(i), target);
  }

  if (!unknown_fields().empty()) {
    target = ::google::protobuf::internal::WireFormat::SerializeUnknownFieldsToArray(
        unknown_fields(), target);
  }
  return target;
}

int SolverQuerySet::ByteSize() const {
  int total_size = 0;

  // repeated .klee.data.SolverQuery solver_query = 1;
  total_size += 1 * this->solver_query_size();
  for (int i = 0; i < this->solver_query_size(); i++) {
    total_size +=
      ::google::protobuf::internal::WireFormatLite::MessageSizeNoVirtual(
        this->solver_query(i));
  }

  if (!unknown_fields().empty()) {
    total_size +=
      ::google::protobuf::internal::WireFormat::ComputeUnknownFieldsSize(
        unknown_fields());
  }
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = total_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void SolverQuerySet::MergeFrom(const ::google::protobuf::Message& from) {
  GOOGLE_CHECK_NE(&from, this);
  const SolverQuerySet* source =
    ::google::protobuf::internal::dynamic_cast_if_available<const SolverQuerySet*>(
      &from);
  if (source == NULL) {
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
    MergeFrom(*source);
  }
}

void SolverQuerySet::MergeFrom(const SolverQuerySet& from) {
  GOOGLE_CHECK_NE(&from, this);
  solver_query_.MergeFrom(from.solver_query_);
  mutable_unknown_fields()->MergeFrom(from.unknown_fields());
}

void SolverQuerySet::CopyFrom(const ::google::protobuf::Message& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void SolverQuerySet::CopyFrom(const SolverQuerySet& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool SolverQuerySet::IsInitialized() const {

  for (int i = 0; i < solver_query_size(); i++) {
    if (!this->solver_query(i).IsInitialized()) return false;
  }
  return true;
}

void SolverQuerySet::Swap(SolverQuerySet* other) {
  if (other != this) {
    solver_query_.Swap(&other->solver_query_);
    std::swap(_has_bits_[0], other->_has_bits_[0]);
    _unknown_fields_.Swap(&other->_unknown_fields_);
    std::swap(_cached_size_, other->_cached_size_);
  }
}

::google::protobuf::Metadata SolverQuerySet::GetMetadata() const {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::Metadata metadata;
  metadata.descriptor = SolverQuerySet_descriptor_;
  metadata.reflection = SolverQuerySet_reflection_;
  return metadata;
}


// @@protoc_insertion_point(namespace_scope)

}  // namespace data
}  // namespace klee

// @@protoc_insertion_point(global_scope)
