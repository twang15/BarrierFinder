// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: Statistics.proto

#ifndef PROTOBUF_Statistics_2eproto__INCLUDED
#define PROTOBUF_Statistics_2eproto__INCLUDED

#include <string>

#include <google/protobuf/stubs/common.h>

#if GOOGLE_PROTOBUF_VERSION < 2005000
#error This file was generated by a newer version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please update
#error your headers.
#endif
#if 2005000 < GOOGLE_PROTOBUF_MIN_PROTOC_VERSION
#error This file was generated by an older version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please
#error regenerate this file with a newer version of protoc.
#endif

#include <google/protobuf/generated_message_util.h>
#include <google/protobuf/message.h>
#include <google/protobuf/repeated_field.h>
#include <google/protobuf/extension_set.h>
#include <google/protobuf/unknown_field_set.h>
// @@protoc_insertion_point(includes)

namespace klee {
namespace data {

// Internal implementation detail -- do not call these.
void  protobuf_AddDesc_Statistics_2eproto();
void protobuf_AssignDesc_Statistics_2eproto();
void protobuf_ShutdownFile_Statistics_2eproto();

class Statistic;
class StatisticSet;

// ===================================================================

class Statistic : public ::google::protobuf::Message {
 public:
  Statistic();
  virtual ~Statistic();

  Statistic(const Statistic& from);

  inline Statistic& operator=(const Statistic& from) {
    CopyFrom(from);
    return *this;
  }

  inline const ::google::protobuf::UnknownFieldSet& unknown_fields() const {
    return _unknown_fields_;
  }

  inline ::google::protobuf::UnknownFieldSet* mutable_unknown_fields() {
    return &_unknown_fields_;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const Statistic& default_instance();

  void Swap(Statistic* other);

  // implements Message ----------------------------------------------

  Statistic* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const Statistic& from);
  void MergeFrom(const Statistic& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const;
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // required uint64 time_stamp = 1;
  inline bool has_time_stamp() const;
  inline void clear_time_stamp();
  static const int kTimeStampFieldNumber = 1;
  inline ::google::protobuf::uint64 time_stamp() const;
  inline void set_time_stamp(::google::protobuf::uint64 value);

  // optional int64 instructions = 2;
  inline bool has_instructions() const;
  inline void clear_instructions();
  static const int kInstructionsFieldNumber = 2;
  inline ::google::protobuf::int64 instructions() const;
  inline void set_instructions(::google::protobuf::int64 value);

  // optional int64 full_branches = 3;
  inline bool has_full_branches() const;
  inline void clear_full_branches();
  static const int kFullBranchesFieldNumber = 3;
  inline ::google::protobuf::int64 full_branches() const;
  inline void set_full_branches(::google::protobuf::int64 value);

  // optional int64 partial_branches = 4;
  inline bool has_partial_branches() const;
  inline void clear_partial_branches();
  static const int kPartialBranchesFieldNumber = 4;
  inline ::google::protobuf::int64 partial_branches() const;
  inline void set_partial_branches(::google::protobuf::int64 value);

  // optional double user_time = 5;
  inline bool has_user_time() const;
  inline void clear_user_time();
  static const int kUserTimeFieldNumber = 5;
  inline double user_time() const;
  inline void set_user_time(double value);

  // optional int32 num_states = 6;
  inline bool has_num_states() const;
  inline void clear_num_states();
  static const int kNumStatesFieldNumber = 6;
  inline ::google::protobuf::int32 num_states() const;
  inline void set_num_states(::google::protobuf::int32 value);

  // optional int64 num_queries = 7;
  inline bool has_num_queries() const;
  inline void clear_num_queries();
  static const int kNumQueriesFieldNumber = 7;
  inline ::google::protobuf::int64 num_queries() const;
  inline void set_num_queries(::google::protobuf::int64 value);

  // optional int64 num_query_constructs = 8;
  inline bool has_num_query_constructs() const;
  inline void clear_num_query_constructs();
  static const int kNumQueryConstructsFieldNumber = 8;
  inline ::google::protobuf::int64 num_query_constructs() const;
  inline void set_num_query_constructs(::google::protobuf::int64 value);

  // optional double wall_time = 9;
  inline bool has_wall_time() const;
  inline void clear_wall_time();
  static const int kWallTimeFieldNumber = 9;
  inline double wall_time() const;
  inline void set_wall_time(double value);

  // optional int64 covered_instructions = 10;
  inline bool has_covered_instructions() const;
  inline void clear_covered_instructions();
  static const int kCoveredInstructionsFieldNumber = 10;
  inline ::google::protobuf::int64 covered_instructions() const;
  inline void set_covered_instructions(::google::protobuf::int64 value);

  // optional int64 uncovered_instructions = 11;
  inline bool has_uncovered_instructions() const;
  inline void clear_uncovered_instructions();
  static const int kUncoveredInstructionsFieldNumber = 11;
  inline ::google::protobuf::int64 uncovered_instructions() const;
  inline void set_uncovered_instructions(::google::protobuf::int64 value);

  // @@protoc_insertion_point(class_scope:klee.data.Statistic)
 private:
  inline void set_has_time_stamp();
  inline void clear_has_time_stamp();
  inline void set_has_instructions();
  inline void clear_has_instructions();
  inline void set_has_full_branches();
  inline void clear_has_full_branches();
  inline void set_has_partial_branches();
  inline void clear_has_partial_branches();
  inline void set_has_user_time();
  inline void clear_has_user_time();
  inline void set_has_num_states();
  inline void clear_has_num_states();
  inline void set_has_num_queries();
  inline void clear_has_num_queries();
  inline void set_has_num_query_constructs();
  inline void clear_has_num_query_constructs();
  inline void set_has_wall_time();
  inline void clear_has_wall_time();
  inline void set_has_covered_instructions();
  inline void clear_has_covered_instructions();
  inline void set_has_uncovered_instructions();
  inline void clear_has_uncovered_instructions();

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::google::protobuf::uint64 time_stamp_;
  ::google::protobuf::int64 instructions_;
  ::google::protobuf::int64 full_branches_;
  ::google::protobuf::int64 partial_branches_;
  double user_time_;
  ::google::protobuf::int64 num_queries_;
  ::google::protobuf::int64 num_query_constructs_;
  double wall_time_;
  ::google::protobuf::int64 covered_instructions_;
  ::google::protobuf::int64 uncovered_instructions_;
  ::google::protobuf::int32 num_states_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(11 + 31) / 32];

  friend void  protobuf_AddDesc_Statistics_2eproto();
  friend void protobuf_AssignDesc_Statistics_2eproto();
  friend void protobuf_ShutdownFile_Statistics_2eproto();

  void InitAsDefaultInstance();
  static Statistic* default_instance_;
};
// -------------------------------------------------------------------

class StatisticSet : public ::google::protobuf::Message {
 public:
  StatisticSet();
  virtual ~StatisticSet();

  StatisticSet(const StatisticSet& from);

  inline StatisticSet& operator=(const StatisticSet& from) {
    CopyFrom(from);
    return *this;
  }

  inline const ::google::protobuf::UnknownFieldSet& unknown_fields() const {
    return _unknown_fields_;
  }

  inline ::google::protobuf::UnknownFieldSet* mutable_unknown_fields() {
    return &_unknown_fields_;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const StatisticSet& default_instance();

  void Swap(StatisticSet* other);

  // implements Message ----------------------------------------------

  StatisticSet* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const StatisticSet& from);
  void MergeFrom(const StatisticSet& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const;
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // repeated .klee.data.Statistic statistic = 1;
  inline int statistic_size() const;
  inline void clear_statistic();
  static const int kStatisticFieldNumber = 1;
  inline const ::klee::data::Statistic& statistic(int index) const;
  inline ::klee::data::Statistic* mutable_statistic(int index);
  inline ::klee::data::Statistic* add_statistic();
  inline const ::google::protobuf::RepeatedPtrField< ::klee::data::Statistic >&
      statistic() const;
  inline ::google::protobuf::RepeatedPtrField< ::klee::data::Statistic >*
      mutable_statistic();

  // @@protoc_insertion_point(class_scope:klee.data.StatisticSet)
 private:

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::google::protobuf::RepeatedPtrField< ::klee::data::Statistic > statistic_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(1 + 31) / 32];

  friend void  protobuf_AddDesc_Statistics_2eproto();
  friend void protobuf_AssignDesc_Statistics_2eproto();
  friend void protobuf_ShutdownFile_Statistics_2eproto();

  void InitAsDefaultInstance();
  static StatisticSet* default_instance_;
};
// ===================================================================


// ===================================================================

// Statistic

// required uint64 time_stamp = 1;
inline bool Statistic::has_time_stamp() const {
  return (_has_bits_[0] & 0x00000001u) != 0;
}
inline void Statistic::set_has_time_stamp() {
  _has_bits_[0] |= 0x00000001u;
}
inline void Statistic::clear_has_time_stamp() {
  _has_bits_[0] &= ~0x00000001u;
}
inline void Statistic::clear_time_stamp() {
  time_stamp_ = GOOGLE_ULONGLONG(0);
  clear_has_time_stamp();
}
inline ::google::protobuf::uint64 Statistic::time_stamp() const {
  return time_stamp_;
}
inline void Statistic::set_time_stamp(::google::protobuf::uint64 value) {
  set_has_time_stamp();
  time_stamp_ = value;
}

// optional int64 instructions = 2;
inline bool Statistic::has_instructions() const {
  return (_has_bits_[0] & 0x00000002u) != 0;
}
inline void Statistic::set_has_instructions() {
  _has_bits_[0] |= 0x00000002u;
}
inline void Statistic::clear_has_instructions() {
  _has_bits_[0] &= ~0x00000002u;
}
inline void Statistic::clear_instructions() {
  instructions_ = GOOGLE_LONGLONG(0);
  clear_has_instructions();
}
inline ::google::protobuf::int64 Statistic::instructions() const {
  return instructions_;
}
inline void Statistic::set_instructions(::google::protobuf::int64 value) {
  set_has_instructions();
  instructions_ = value;
}

// optional int64 full_branches = 3;
inline bool Statistic::has_full_branches() const {
  return (_has_bits_[0] & 0x00000004u) != 0;
}
inline void Statistic::set_has_full_branches() {
  _has_bits_[0] |= 0x00000004u;
}
inline void Statistic::clear_has_full_branches() {
  _has_bits_[0] &= ~0x00000004u;
}
inline void Statistic::clear_full_branches() {
  full_branches_ = GOOGLE_LONGLONG(0);
  clear_has_full_branches();
}
inline ::google::protobuf::int64 Statistic::full_branches() const {
  return full_branches_;
}
inline void Statistic::set_full_branches(::google::protobuf::int64 value) {
  set_has_full_branches();
  full_branches_ = value;
}

// optional int64 partial_branches = 4;
inline bool Statistic::has_partial_branches() const {
  return (_has_bits_[0] & 0x00000008u) != 0;
}
inline void Statistic::set_has_partial_branches() {
  _has_bits_[0] |= 0x00000008u;
}
inline void Statistic::clear_has_partial_branches() {
  _has_bits_[0] &= ~0x00000008u;
}
inline void Statistic::clear_partial_branches() {
  partial_branches_ = GOOGLE_LONGLONG(0);
  clear_has_partial_branches();
}
inline ::google::protobuf::int64 Statistic::partial_branches() const {
  return partial_branches_;
}
inline void Statistic::set_partial_branches(::google::protobuf::int64 value) {
  set_has_partial_branches();
  partial_branches_ = value;
}

// optional double user_time = 5;
inline bool Statistic::has_user_time() const {
  return (_has_bits_[0] & 0x00000010u) != 0;
}
inline void Statistic::set_has_user_time() {
  _has_bits_[0] |= 0x00000010u;
}
inline void Statistic::clear_has_user_time() {
  _has_bits_[0] &= ~0x00000010u;
}
inline void Statistic::clear_user_time() {
  user_time_ = 0;
  clear_has_user_time();
}
inline double Statistic::user_time() const {
  return user_time_;
}
inline void Statistic::set_user_time(double value) {
  set_has_user_time();
  user_time_ = value;
}

// optional int32 num_states = 6;
inline bool Statistic::has_num_states() const {
  return (_has_bits_[0] & 0x00000020u) != 0;
}
inline void Statistic::set_has_num_states() {
  _has_bits_[0] |= 0x00000020u;
}
inline void Statistic::clear_has_num_states() {
  _has_bits_[0] &= ~0x00000020u;
}
inline void Statistic::clear_num_states() {
  num_states_ = 0;
  clear_has_num_states();
}
inline ::google::protobuf::int32 Statistic::num_states() const {
  return num_states_;
}
inline void Statistic::set_num_states(::google::protobuf::int32 value) {
  set_has_num_states();
  num_states_ = value;
}

// optional int64 num_queries = 7;
inline bool Statistic::has_num_queries() const {
  return (_has_bits_[0] & 0x00000040u) != 0;
}
inline void Statistic::set_has_num_queries() {
  _has_bits_[0] |= 0x00000040u;
}
inline void Statistic::clear_has_num_queries() {
  _has_bits_[0] &= ~0x00000040u;
}
inline void Statistic::clear_num_queries() {
  num_queries_ = GOOGLE_LONGLONG(0);
  clear_has_num_queries();
}
inline ::google::protobuf::int64 Statistic::num_queries() const {
  return num_queries_;
}
inline void Statistic::set_num_queries(::google::protobuf::int64 value) {
  set_has_num_queries();
  num_queries_ = value;
}

// optional int64 num_query_constructs = 8;
inline bool Statistic::has_num_query_constructs() const {
  return (_has_bits_[0] & 0x00000080u) != 0;
}
inline void Statistic::set_has_num_query_constructs() {
  _has_bits_[0] |= 0x00000080u;
}
inline void Statistic::clear_has_num_query_constructs() {
  _has_bits_[0] &= ~0x00000080u;
}
inline void Statistic::clear_num_query_constructs() {
  num_query_constructs_ = GOOGLE_LONGLONG(0);
  clear_has_num_query_constructs();
}
inline ::google::protobuf::int64 Statistic::num_query_constructs() const {
  return num_query_constructs_;
}
inline void Statistic::set_num_query_constructs(::google::protobuf::int64 value) {
  set_has_num_query_constructs();
  num_query_constructs_ = value;
}

// optional double wall_time = 9;
inline bool Statistic::has_wall_time() const {
  return (_has_bits_[0] & 0x00000100u) != 0;
}
inline void Statistic::set_has_wall_time() {
  _has_bits_[0] |= 0x00000100u;
}
inline void Statistic::clear_has_wall_time() {
  _has_bits_[0] &= ~0x00000100u;
}
inline void Statistic::clear_wall_time() {
  wall_time_ = 0;
  clear_has_wall_time();
}
inline double Statistic::wall_time() const {
  return wall_time_;
}
inline void Statistic::set_wall_time(double value) {
  set_has_wall_time();
  wall_time_ = value;
}

// optional int64 covered_instructions = 10;
inline bool Statistic::has_covered_instructions() const {
  return (_has_bits_[0] & 0x00000200u) != 0;
}
inline void Statistic::set_has_covered_instructions() {
  _has_bits_[0] |= 0x00000200u;
}
inline void Statistic::clear_has_covered_instructions() {
  _has_bits_[0] &= ~0x00000200u;
}
inline void Statistic::clear_covered_instructions() {
  covered_instructions_ = GOOGLE_LONGLONG(0);
  clear_has_covered_instructions();
}
inline ::google::protobuf::int64 Statistic::covered_instructions() const {
  return covered_instructions_;
}
inline void Statistic::set_covered_instructions(::google::protobuf::int64 value) {
  set_has_covered_instructions();
  covered_instructions_ = value;
}

// optional int64 uncovered_instructions = 11;
inline bool Statistic::has_uncovered_instructions() const {
  return (_has_bits_[0] & 0x00000400u) != 0;
}
inline void Statistic::set_has_uncovered_instructions() {
  _has_bits_[0] |= 0x00000400u;
}
inline void Statistic::clear_has_uncovered_instructions() {
  _has_bits_[0] &= ~0x00000400u;
}
inline void Statistic::clear_uncovered_instructions() {
  uncovered_instructions_ = GOOGLE_LONGLONG(0);
  clear_has_uncovered_instructions();
}
inline ::google::protobuf::int64 Statistic::uncovered_instructions() const {
  return uncovered_instructions_;
}
inline void Statistic::set_uncovered_instructions(::google::protobuf::int64 value) {
  set_has_uncovered_instructions();
  uncovered_instructions_ = value;
}

// -------------------------------------------------------------------

// StatisticSet

// repeated .klee.data.Statistic statistic = 1;
inline int StatisticSet::statistic_size() const {
  return statistic_.size();
}
inline void StatisticSet::clear_statistic() {
  statistic_.Clear();
}
inline const ::klee::data::Statistic& StatisticSet::statistic(int index) const {
  return statistic_.Get(index);
}
inline ::klee::data::Statistic* StatisticSet::mutable_statistic(int index) {
  return statistic_.Mutable(index);
}
inline ::klee::data::Statistic* StatisticSet::add_statistic() {
  return statistic_.Add();
}
inline const ::google::protobuf::RepeatedPtrField< ::klee::data::Statistic >&
StatisticSet::statistic() const {
  return statistic_;
}
inline ::google::protobuf::RepeatedPtrField< ::klee::data::Statistic >*
StatisticSet::mutable_statistic() {
  return &statistic_;
}


// @@protoc_insertion_point(namespace_scope)

}  // namespace data
}  // namespace klee

#ifndef SWIG
namespace google {
namespace protobuf {


}  // namespace google
}  // namespace protobuf
#endif  // SWIG

// @@protoc_insertion_point(global_scope)

#endif  // PROTOBUF_Statistics_2eproto__INCLUDED
