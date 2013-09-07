///
//  Generated code. Do not modify.
///
library Emg.pb;

import 'dart:typed_data';

import 'package:protobuf/protobuf.dart';

class Reading extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Reading')
    ..a(1, 'timestamp', GeneratedMessage.OD)
    ..a(2, 'value', GeneratedMessage.O3)
    ..hasRequiredFields = false
  ;

  Reading() : super();
  Reading.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Reading.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Reading clone() => new Reading()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;

  double get timestamp => getField(1);
  void set timestamp(double v) { setField(1, v); }
  bool hasTimestamp() => hasField(1);
  void clearTimestamp() => clearField(1);

  int get value => getField(2);
  void set value(int v) { setField(2, v); }
  bool hasValue() => hasField(2);
  void clearValue() => clearField(2);
}

class ReadingChunk extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ReadingChunk')
    ..m(3, 'readings', () => new Reading(), () => new PbList<Reading>())
    ..hasRequiredFields = false
  ;

  ReadingChunk() : super();
  ReadingChunk.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ReadingChunk.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ReadingChunk clone() => new ReadingChunk()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;

  List<Reading> get readings => getField(3);
}

class GestureDesc extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('GestureDesc')
    ..a(1, 'gestureName', GeneratedMessage.OS)
    ..a(2, 'force', GeneratedMessage.OD)
    ..a(3, 'description', GeneratedMessage.OS)
    ..hasRequiredFields = false
  ;

  GestureDesc() : super();
  GestureDesc.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  GestureDesc.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  GestureDesc clone() => new GestureDesc()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;

  String get gestureName => getField(1);
  void set gestureName(String v) { setField(1, v); }
  bool hasGestureName() => hasField(1);
  void clearGestureName() => clearField(1);

  double get force => getField(2);
  void set force(double v) { setField(2, v); }
  bool hasForce() => hasField(2);
  void clearForce() => clearField(2);

  String get description => getField(3);
  void set description(String v) { setField(3, v); }
  bool hasDescription() => hasField(3);
  void clearDescription() => clearField(3);
}

class ExperimentDesc extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ExperimentDesc')
    ..a(1, 'experimentName', GeneratedMessage.OS)
    ..a(2, 'gestureDuration', GeneratedMessage.O3)
    ..a(3, 'timeBetweenGestures', GeneratedMessage.O3)
    ..m(4, 'gesture', () => new GestureDesc(), () => new PbList<GestureDesc>())
    ..hasRequiredFields = false
  ;

  ExperimentDesc() : super();
  ExperimentDesc.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ExperimentDesc.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ExperimentDesc clone() => new ExperimentDesc()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;

  String get experimentName => getField(1);
  void set experimentName(String v) { setField(1, v); }
  bool hasExperimentName() => hasField(1);
  void clearExperimentName() => clearField(1);

  int get gestureDuration => getField(2);
  void set gestureDuration(int v) { setField(2, v); }
  bool hasGestureDuration() => hasField(2);
  void clearGestureDuration() => clearField(2);

  int get timeBetweenGestures => getField(3);
  void set timeBetweenGestures(int v) { setField(3, v); }
  bool hasTimeBetweenGestures() => hasField(3);
  void clearTimeBetweenGestures() => clearField(3);

  List<GestureDesc> get gesture => getField(4);
}

class ExperimentInstance extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ExperimentInstance')
    ..a(1, 'subjectName', GeneratedMessage.OS)
    ..a(2, 'timestamp', GeneratedMessage.O3)
    ..a(3, 'experiment', GeneratedMessage.OM, () => new ExperimentDesc(), () => new ExperimentDesc())
    ..m(4, 'readingChunks', () => new ReadingChunk(), () => new PbList<ReadingChunk>())
    ..hasRequiredFields = false
  ;

  ExperimentInstance() : super();
  ExperimentInstance.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ExperimentInstance.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ExperimentInstance clone() => new ExperimentInstance()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;

  String get subjectName => getField(1);
  void set subjectName(String v) { setField(1, v); }
  bool hasSubjectName() => hasField(1);
  void clearSubjectName() => clearField(1);

  int get timestamp => getField(2);
  void set timestamp(int v) { setField(2, v); }
  bool hasTimestamp() => hasField(2);
  void clearTimestamp() => clearField(2);

  ExperimentDesc get experiment => getField(3);
  void set experiment(ExperimentDesc v) { setField(3, v); }
  bool hasExperiment() => hasField(3);
  void clearExperiment() => clearField(3);

  List<ReadingChunk> get readingChunks => getField(4);
}

class StartExperiment extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('StartExperiment')
    ..a(1, 'subjectName', GeneratedMessage.OS)
    ..a(2, 'experiment', GeneratedMessage.OM, () => new ExperimentDesc(), () => new ExperimentDesc())
    ..a(3, 'timestamp', GeneratedMessage.O3)
    ..hasRequiredFields = false
  ;

  StartExperiment() : super();
  StartExperiment.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  StartExperiment.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  StartExperiment clone() => new StartExperiment()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;

  String get subjectName => getField(1);
  void set subjectName(String v) { setField(1, v); }
  bool hasSubjectName() => hasField(1);
  void clearSubjectName() => clearField(1);

  ExperimentDesc get experiment => getField(2);
  void set experiment(ExperimentDesc v) { setField(2, v); }
  bool hasExperiment() => hasField(2);
  void clearExperiment() => clearField(2);

  int get timestamp => getField(3);
  void set timestamp(int v) { setField(3, v); }
  bool hasTimestamp() => hasField(3);
  void clearTimestamp() => clearField(3);
}

class FinishExperiment extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FinishExperiment')
    ..a(1, 'saveToKiji', GeneratedMessage.OB)
    ..a(2, 'timestamp', GeneratedMessage.O3)
    ..a(3, 'subjectName', GeneratedMessage.OS)
    ..hasRequiredFields = false
  ;

  FinishExperiment() : super();
  FinishExperiment.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FinishExperiment.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FinishExperiment clone() => new FinishExperiment()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;

  bool get saveToKiji => getField(1);
  void set saveToKiji(bool v) { setField(1, v); }
  bool hasSaveToKiji() => hasField(1);
  void clearSaveToKiji() => clearField(1);

  int get timestamp => getField(2);
  void set timestamp(int v) { setField(2, v); }
  bool hasTimestamp() => hasField(2);
  void clearTimestamp() => clearField(2);

  String get subjectName => getField(3);
  void set subjectName(String v) { setField(3, v); }
  bool hasSubjectName() => hasField(3);
  void clearSubjectName() => clearField(3);
}

class DartToPythonMessage extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DartToPythonMessage')
    ..a(1, 'messageType', GeneratedMessage.QS)
    ..a(2, 'start', GeneratedMessage.OM, () => new StartExperiment(), () => new StartExperiment())
    ..a(3, 'finish', GeneratedMessage.OM, () => new FinishExperiment(), () => new FinishExperiment())
  ;

  DartToPythonMessage() : super();
  DartToPythonMessage.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DartToPythonMessage.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DartToPythonMessage clone() => new DartToPythonMessage()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;

  String get messageType => getField(1);
  void set messageType(String v) { setField(1, v); }
  bool hasMessageType() => hasField(1);
  void clearMessageType() => clearField(1);

  StartExperiment get start => getField(2);
  void set start(StartExperiment v) { setField(2, v); }
  bool hasStart() => hasField(2);
  void clearStart() => clearField(2);

  FinishExperiment get finish => getField(3);
  void set finish(FinishExperiment v) { setField(3, v); }
  bool hasFinish() => hasField(3);
  void clearFinish() => clearField(3);
}

