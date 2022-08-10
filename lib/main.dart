import 'package:covid_19/constant.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:covid_19/widgets/weekly_chart.dart';
import 'package:covid_19/widgets/line_chart.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'dart:convert'; 

void main() => runApp(MyApp());

class MyData extends ChangeNotifier {
  // 초기값:0, 파싱이 완료되면:1
  String? xmlData;

  void change(String xmlData) async {
    print('change called...');
    this.xmlData = xmlData;
    // 데이터 변경 후 호출하면 변경을 반영할 수 있다.
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyData>(
      create: (_) => MyData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Covid 19',
        theme: ThemeData(
            scaffoldBackgroundColor: kBackgroundColor,
            fontFamily: "Poppins",
            textTheme: TextTheme(
              bodyText1: TextStyle(color: kBodyTextColor),
            )),
        home: HomeScreen(),
      )
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = ScrollController();
  double offset = 0;
  String _chosenValue = '서울';

  late MyData myData; // sssssssssss

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    myData = Provider.of<MyData>(context, listen: false);   //  ssssssssssss
    print('Page1 빌드됨...');

    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              data: 'main',
              image: "assets/icons/Drcorona.svg",
              textTop: "코로나 예방을 위해서",
              textBottom: "외출을 삼가해 주세요.",
              offset: offset,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                      value: _chosenValue,
                      items: [
                        '서울',
                        '경기',
                        '인천',
                        '강원',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        print('value : $value');
                        setState(() {
                          _chosenValue = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "금일 코로나 현황\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: "최종 업데이트 22년 1월 29일",
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Text(
                        "See details",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: kInfectedColor,
                          number: 1046,
                          title: "검사자수",
                        ),
                        Counter(
                          color: kDeathColor,
                          number: 87,
                          title: "확진자수",
                        ),
                        Counter(
                          color: kRecovercolor,
                          number: 46,
                          title: "사망자수",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "코로나19 확진자 추이",
                        style: kTitleTextstyle,
                      ),
                      Text(
                        "See details",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  //WeeklyChart(),
                  SizedBox(height: 20),
                  LineReportChart(),
                  SizedBox(height: 20),
                  // Container(
                  //   margin: EdgeInsets.only(top: 20),
                  //   padding: EdgeInsets.all(20),
                  //   height: 178,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20),
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         offset: Offset(0, 10),
                  //         blurRadius: 30,
                  //         color: kShadowColor,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Image.asset(
                  //     "assets/images/map.png",
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<String> _getRequestData() async {
    // 10일전부터 오늘까지의 날짜 지정
    String startDay = DateTime.now().add(Duration(days: -10)).toString();
    String endDay = DateTime.now().toString().substring(0, 10).replaceAll('-', '');
    print('$startDay -> $endDay');

    String dataUrl = "http://openapi.data.go.kr/openapi/service/rest/Covid19/getCovid19InfStateJson";
    String param1 = "";
    String param2 = "pageNo=1";
    String param3 = "numOfRows=10";
    String param4 = "startCreateDt=$startDay";
    String param5 = "endCreateDt=$endDay";

    var url = Uri.parse("$dataUrl?$param1&$param2&$param3&$param4&$param5");
    http.Response response = await http.get(
      url,
      headers: {"Accept" : "application/xml"}
    );

    var statusCode = response.statusCode;
    // var responseHeaders = response.headers;
    var responseBody = utf8.decode(response.bodyBytes);

    return responseBody.toString();
  }

  void _accDataParsing() async {
    String xmlData = await _getRequestData() as String;
    Xml2Json xml2json = Xml2Json();
    xml2json.parse(xmlData);
    var jsonData = xml2json.toParker();
    ///print(jsonData);
    var data1 = jsonDecode(jsonData);
    List data2 = data1['response']['body']['items']['item'];
    print("날짜 - 누적검사자 - 누적확진자 - 누적사망자");
    for(var item in data2){
      String stateDt = item['stateDt'];
      String createDt = item['createDt'];
      int examCnt = int.tryParse(item['accExamCnt']) ?? 0;
      int decideCnt = int.tryParse(item['decideCnt']) ?? 0;
      int deathCnt = int.tryParse(item['deathCnt']) ?? 0;
      print('$stateDt - $createDt - $examCnt - $decideCnt - $deathCnt');
    }
  }

}
