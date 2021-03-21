import 'package:cambiomoneda/src/services/api_client.dart';
import 'package:flutter/material.dart';

import 'package:cambiomoneda/src/widgets/dropDown_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiClient client = ApiClient();

  Color mainColor = Color(0xFF212936);
  Color secondColor = Color(0xFF2849E5);

  List<String> currencies;

  String from, to;

  double rate;
  String result = '';


  @override
  void initState() {
    super.initState();
    (() async {
      List<String> list = await client.getCurrencies();
      setState(() {
        currencies = list;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mainColor,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    width: 200,
                    child: Text('Currency Converter',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold))),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextField(
                            onSubmitted: (value) async {
                              rate = await client.getRate(from, to);
                              setState(() {
                                result = (rate * double.parse(value))
                                    .toStringAsFixed(3);
                              });
                            },
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: 'Input value to convert',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: secondColor)),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              customDropDown(currencies, from, (val) {
                                setState(() {
                                  from = val;
                                });
                              }),
                              FloatingActionButton(
                                  onPressed: () {
                                    String temp = from;
                                    setState(() {
                                      from = to;
                                      to = temp;
                                    });
                                  },
                                  child: Icon(Icons.swap_horiz),
                                  elevation: 0.0,
                                  backgroundColor: secondColor),
                              customDropDown(currencies, to, (val) {
                                setState(() {
                                  to = val;
                                });
                              }),
                            ],
                          ),
                          SizedBox(height: 50.0),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0)),
                            child: Column(
                              children: <Widget>[
                                Text("Result",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold)),
                                Text(result,
                                    style: TextStyle(
                                        color: secondColor,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
