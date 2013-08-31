library chart;

import 'dart:html';
import 'dart:async';
import 'package:chart/chart.dart';
import 'package:web_ui/web_ui.dart';

@observable String socketAdr='';
ButtonElement connectButton;

void main() {
  connectButton = query("#connectButton");
  int rcd = 0;
  List recData = [0,0];
  var recLabels = ["0","0"];
  
  DivElement container = new DivElement();
  container.style.height ='400px';
  container.style.width =  '100%';
  document.body.children.add(container);
  
  var chart = new Line({
    'labels' : ["1","2","3","4"],
    'datasets' : [{
      'fillColor' : "rgba(220,220,220,0.5)",
      'strokeColor' : "rgba(0,0,0,1)",
      'pointColor' : "rgba(220,220,220,1)",
      'pointStrokeColor' : "#fff",
      'pointDot' : false,
      'data' : [500,500,500,500]
    }]
  }, 
  {
    'scaleOverride' : true, 
    'scaleMinValue' : -4095.0, 
    'scaleMaxValue' : 4095.0, 
    'scaleStepValue' : null, 
    'bezierCurve' : true, 
    'animation' : false,
    'titleText' : 'you shouldnt be seing this'
  });
  
  void receiveHandler(MessageEvent e) {
    var nums = e.data.toString().split(",");
    var ts = nums[0];
    var value = nums[1];
    rcd++;
    if (rcd > 100) recData.removeAt(0);
    recData.add(int.parse(value));
  }

  var webSocket = new WebSocket('ws://0.0.0.0:9001/');
  webSocket.onMessage.listen(receiveHandler);

  void callback(Timer) {
    //print('CALLBACK');
    recLabels = new List.from(recData.map((j) {return j.toString();}));
    //print(recData);
    chart.hide();
    chart = new Line({
      'labels' : recLabels,
      'datasets' : [{
        'fillColor' : "rgba(220,220,220,0.5)",
        'strokeColor' : "rgba(0,0,0,1)",
        'pointColor' : "rgba(220,220,220,1)",
        'pointStrokeColor' : "#fff",
        'pointDot' : false,
        'data' : recData
      }]
    }, {
      'scaleOverride' : true,
      'scaleMinValue' : 0.0, 
      'scaleMaxValue' : 4095.0, 
      'scaleStepValue' : null, 
      'bezierCurve' : false, 
      'animation' : false,
      'titleText' : 'emg real time chart test'
    }
    );
    chart.show(container);
  }
 
  void openHandler(Event e) {
    var txt1 = new ParagraphElement();
    txt1.text = 'opened, yo';
    document.body.children.add(txt1);
    var timer = new Timer.periodic(const Duration(milliseconds: 40), callback);
  }

}