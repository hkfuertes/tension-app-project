import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget(this._text);
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /// Loader Animation Widget
          SizedBox(
            width: 128.0,
            height: 128.0,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.brown),
            ),
          ),
          Container(
            height: 32.0,
          ),
          Text(_text, style: TextStyle(fontSize: 16.0, color: Colors.brown),),
        ],
      ),
    );
  }
}
