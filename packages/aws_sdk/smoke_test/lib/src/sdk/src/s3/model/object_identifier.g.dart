// GENERATED CODE - DO NOT MODIFY BY HAND

part of smoke_test.s3.model.object_identifier;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ObjectIdentifier extends ObjectIdentifier {
  @override
  final String key;
  @override
  final String? versionId;

  factory _$ObjectIdentifier(
          [void Function(ObjectIdentifierBuilder)? updates]) =>
      (new ObjectIdentifierBuilder()..update(updates))._build();

  _$ObjectIdentifier._({required this.key, this.versionId}) : super._() {
    BuiltValueNullFieldError.checkNotNull(key, r'ObjectIdentifier', 'key');
  }

  @override
  ObjectIdentifier rebuild(void Function(ObjectIdentifierBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ObjectIdentifierBuilder toBuilder() =>
      new ObjectIdentifierBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ObjectIdentifier &&
        key == other.key &&
        versionId == other.versionId;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, key.hashCode), versionId.hashCode));
  }
}

class ObjectIdentifierBuilder
    implements Builder<ObjectIdentifier, ObjectIdentifierBuilder> {
  _$ObjectIdentifier? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  String? _versionId;
  String? get versionId => _$this._versionId;
  set versionId(String? versionId) => _$this._versionId = versionId;

  ObjectIdentifierBuilder() {
    ObjectIdentifier._init(this);
  }

  ObjectIdentifierBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _versionId = $v.versionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ObjectIdentifier other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ObjectIdentifier;
  }

  @override
  void update(void Function(ObjectIdentifierBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ObjectIdentifier build() => _build();

  _$ObjectIdentifier _build() {
    final _$result = _$v ??
        new _$ObjectIdentifier._(
            key: BuiltValueNullFieldError.checkNotNull(
                key, r'ObjectIdentifier', 'key'),
            versionId: versionId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
