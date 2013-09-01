library chart;

import 'dart:html';
import 'dart:async';
import 'package:chart/chart.dart';
import 'package:web_ui/web_ui.dart';
import 'dart:collection';

@observable String socketAdr='';
ButtonElement connectButton;

var recData = new Queue<int>();
var recLabels;
var webSocket;
DivElement container = new DivElement();
var timer;
var chart;

void receiveHandler(MessageEvent e) {
  if (recData.length == 100) {
    recData.removeFirst();
  }
  recData.add(int.parse(e.data.toString().split(",")[1]));
}

void callback(Timer) {
  chart.data['datasets'][0]['data'] = recData.toList();
  chart.animateFrame();
}
 
void doNothing(num) {
  
}

void openHandler(Event e) {
  print("socket opened.");
  var txt1 = new ParagraphElement();
  txt1.text = 'opened, yo';
  document.body.children.add(txt1);
  timer = new Timer.periodic(const Duration(milliseconds: 1), callback);
}

void closeHandler(Event e) {
  timer.cancel();
}

void main() {
  for (int x = 0; x < 100; x++) {
    recData.add(0); 
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
}

void connect(){ 
  webSocket = new WebSocket(socketAdr);
  webSocket.onOpen.listen(openHandler);
  webSocket.onMessage.listen(receiveHandler);
  webSocket.onClose.listen(closeHandler);
}
