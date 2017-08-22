import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

var httpClient = createHttpClient();
var _apiAIClientAccessToken = 'REPLACE_THIS_WHIT_YOUR_API_AI_CLIENT_ACCESS_TOKEN_HERE';
var contextsName = 'talks';
var sessionId = 'flutterchatrobot_v001';
var language = 'en';
int lifeSpan = 4;

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Chat Robot',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Chat Robot'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var userInput = '';
  var responseOutput = '';
  final TextEditingController _chatMsg = new TextEditingController();

  postData() async {
    String url = Uri.encodeFull("https://api.api.ai/v1/query?v=20150910");
    var msg = _chatMsg.text;
    
    // Read more at https://api.ai/docs/reference/agent/query
    var restBody = '{"query": ["$msg"], "contexts": { "name": "$contextsName", "lifespan": $lifeSpan }, "lang": "$language", "sessionId": "$sessionId" }';

    var response = await httpClient.post(
        url, 
        headers: {
          "Content-Type": "application/json", 
          "Authorization": "Bearer $_apiAIClientAccessToken"
        }, 
        body: restBody,
      );
    
    var _response = JSON.decode(response.body);
    var _responseMessage = _response['result']['fulfillment']['speech'];
    
    setState((){
      responseOutput = _responseMessage;
      userInput = msg;
      _chatMsg.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    

    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.title), centerTitle: true),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Align(
              alignment: FractionalOffset.centerLeft,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.all(20.0),
                  ),
                  new Text(
                    '''
                    You: $userInput
                    ''',
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                  new Text(
                    '''
                    Robot: $responseOutput
                    ''',
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new TextField(
                    controller: _chatMsg,
                    decoration: new InputDecoration(
                      hintText: 'Talk to the Robot',
                    ),
                  ),
                  new RaisedButton(
                    onPressed: postData,
                    child: new Text('Send'),
                  ),                  
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
