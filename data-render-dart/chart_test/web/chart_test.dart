library chart;

import 'dart:html';
import 'dart:async';
import 'package:chart/chart.dart';
import 'package:web_ui/web_ui.dart';
import 'dart:collection';
import 'emg.pb.dart';

@observable String socketAdr='';
@observable String subjectName='';
@observable String experimentName='';
@observable String gestureDuration='';
@observable String timeBetweenGestures='';
@observable String gestureName='';
@observable String force='';
@observable String description='';

ButtonElement connectButton;
ButtonElement startExperimentButton;

var recData = new Queue<int>();
var recLabels;
var webSocket;
DivElement container = new DivElement();
var timer;
var chart;
var phaseTwos = queryAll("#two"); // DOM elements to be enabled upon webSocket connect

void receiveHandler(MessageEvent e) {
  //print(e.data.toString());
  if (recData.length >= 100) {
    recData.removeFirst();
  }
  var tuples = e.data.toString().split("|");
  var average = 0;
  for (var pos = 0; pos < 100; pos++) {
    average += int.parse(tuples[pos].split(",")[1]);
  }
  recData.add((average / 100).toInt());
}

void callback(Timer) {
  chart.data['datasets'][0]['data'] = recData.toList();
  chart.animateFrame();
}

void openHandler(Event e) {
  //print("socket opened.");
  timer = new Timer.periodic(const Duration(milliseconds: 1), callback);
  phaseTwos.forEach((j) {j.attributes.remove('disabled');});
}

void closeHandler(Event e) {
  timer.cancel();
}

void main() {
  for (int x = 0; x < 100; x++) {
    recData.add(x);
  }
  recLabels = new List.from(recData.map((j) {return j.toString();}));
  connectButton = query("#connectButton");
  container.style.height ='400px';
  container.style.width =  '100%';
  document.body.children.add(container);
  chart = new Line({
    'labels' : recLabels,
    'datasets' : [{
      'fillColor' : "rgba(220,220,220,0.5)",
      'strokeColor' : "rgba(0,0,0,1)",
      'pointColor' : "rgba(220,220,220,1)",
      'pointStrokeColor' : "#fff",
      'pointDot' : false,
      'data' : recData.toList()
    }]
  }, {
    'scaleOverride' : true,
    'scaleMinValue' : 0.0,
    'scaleMaxValue' : 4095.0,
    'scaleStepValue' : null,
    'bezierCurve' : false,
    'animation' : false,
    'titleText' : 'emg real time data'
    });
  chart.show(container);
  phaseTwos.forEach((j) {j.attributes['disabled'] = 'true';});
}

void connect() {
  webSocket = new WebSocket(socketAdr);
  webSocket.onOpen.listen(openHandler);
  webSocket.onMessage.listen(receiveHandler);
  webSocket.onClose.listen(closeHandler);
}

void startExperiment() {
  // totally untested function
  StartExperiment startMsg = new StartExperiment();
  startMsg.subjectName = subjectName;
  startMsg.timestamp = new DateTime.now().millisecondsSinceEpoch;
  startMsg.experiment = new ExperimentDesc();
  startMsg.experiment.experimentName = experimentName;
  startMsg.experiment.gestureDuration = int.parse(gestureDuration);
  startMsg.experiment.timeBetweenGestures = int.parse(timeBetweenGestures);
  GestureDesc gDesc = new GestureDesc();
  gDesc.gestureName = gestureName;
  gDesc.force = double.parse(force);
  gDesc.description = description;
  startMsg.experiment.gesture.add(gDesc);
  webSocket.sendByteBuffer(startMsg.writeToBuffer()); // complete guess
}
