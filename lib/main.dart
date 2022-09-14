import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Navigation Basics',
    home: MainLogin(),
  ));
}
var Counter = false;

final GlobalKey<ScaffoldState> globalkey1 = GlobalKey();
final GlobalKey<ScaffoldState> globalkey2 = GlobalKey();
final GlobalKey<ScaffoldState> globalkey3 = GlobalKey();
final GlobalKey<ScaffoldState> globalkey4 = GlobalKey();
final GlobalKey<ScaffoldState> globalkey5 = GlobalKey();


String base_url = 'http://127:0.0.1:8000/';
Future<void> GetMealInfo(int timecode, int mealcode) async {
  try {
    http.Response response = await http.get(Uri.parse(base_url + 'mealtable/'));
    var data = jsonDecode(response.body.toString());


    var info = data['info'];
    if (response.statusCode == 200);
    print(data['info']);

  }
  catch (error){
    print(error);
  }
}

var user_id;

class MainLogin extends StatelessWidget { //시작화면
  const MainLogin({Key? key}) : super(key: key);

  static const String _title = 'COM_ON';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        appBar: AppBar(backgroundColor: Color(0xFFFFEE7E),
          title: const Text(_title ,style: TextStyle(color: Color(0xAF854540), fontSize: 20),
          ),

        ),
        body: const LoginSetting(),

      ),
    );


  }
}

class LoginSetting extends StatefulWidget { //로그인
  const LoginSetting({Key? key}) : super(key: key);

  @override
  State<LoginSetting> createState() => _LoginSetting();
}

class _LoginSetting extends State<LoginSetting> {
  bool visible = false;
  //로그인 관련
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> login(String id, String password) async {
    var code, status, message;
    try {
      http.Response response = await http.post(
          Uri.parse('http://127.0.0.1:8000/login/'),
          headers: {"Content-Type": "application/json; charset=UTF-8"},
          body: jsonEncode(
              <String, dynamic>{'user_id': id, 'password': password}));
      var data = jsonDecode(response.body.toString());

      code = data['code'];
      status = data['status'];
      message = data['message'];

      if (response.statusCode == 200) {
        print(data['info']);
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: Color(0xFFFFEE7E),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text("로그인이 완료되었습니다."),
                    ],
                  ),
                ),
              );
            }
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
      }
      else {
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: Color(0xFFFFEE7E),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text("해당하는 사용자 아이디 또는 비밀번호가 존재하지 않습니다."),
                    ],
                  ),
                ),
              );
            }
        );

      }
    } catch (error) {
      print(error.toString());

    }
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  '학생 비서앱',
                  style: TextStyle(
                      color: Color(0xAF854540),
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  '로그인',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ID',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),
              ),
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () => Navigator.push(context, FadeRoute1(FindPassword())),
              child: const Text('비밀번호 찾기',
                  style: TextStyle(color: Colors.brown)),
            ),
            const SizedBox(height: 5),



            Center( child :
            ElevatedButton( style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFEE7E),
                minimumSize: const Size(250, 50),
                maximumSize: const Size(250, 50)),



                child: const Text('로그인',
                  style: TextStyle(color: Color(0xAF854540), fontSize: 18), ),
                onPressed: () {
                  login(emailController.text.toString(), passwordController.text.toString());
                }
            ),
            ),
            const SizedBox(height: 5),




            Row(
              children: <Widget>[
                const Text('처음이신가요?'),
                TextButton(
                    child: const Text(
                      '회원가입',
                      style: TextStyle(color: Color(0xAF854540), fontSize: 20),
                    ),
                    onPressed: () => Navigator.push(context, FadeRoute1(Sign_Up()))
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ],
        ));
  }
}

class FadeRoute1 extends PageRouteBuilder { //페이지 넘기는거
  final Widget page;

  FadeRoute1(this.page)
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        FadeTransition(
          opacity: animation,
          child: page,
        ),
  );
}

class FindPassword extends StatelessWidget { //비번 찾는거

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Color(0xFFFFEE7E),
        centerTitle: true,
        title: Text('비밀번호 찾기', style: TextStyle(color: Color(0xAF854540), fontSize: 20)),

      ),
      body: const Finding(),
    );
  }
}

class Finding extends StatefulWidget { //비번 찾기 body 부분
  const Finding({Key? key}) : super(key: key);

  @override
  State<Finding> createState() => _Finding();
}

class _Finding extends State<Finding> { //비번 찾기 상세 창
  bool visible = false ;

  var user_idController = TextEditingController();
  var emailController = TextEditingController();
  var nameController = TextEditingController();

  Future<void> find_pw(String user_id, String email, String name) async {
    var code, status, message;
    try {
      http.Response response = await http.post(
          Uri.parse('http://127.0.0.1:8000/find_pw/'),
          headers: {"Content-Type" : "application/json; charset=UTF-8"},
          body: jsonEncode(<String, dynamic>{
            'user_id' : user_id,
            'email' : email,
            'name' : name,
          }));
      var data = jsonDecode(response.body.toString());

      code = data['code'];
      status = data['status'];
      message = data['message'];

      if (response.statusCode == 200) {
        print(data['info']);
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: Color(0xFFFFEE7E),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text("사용자의 이메일로 비밀번호를 전송하였습니다."),
                    ],
                  ),
                ),
              );
            }
        );
      } else {
        showDialog(context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Color(0xFFFFEE7E),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text("해당하는 사용자가 존재하지 않습니다."),
                    ],
                  ),
                ),
              );
            }
        );
      }
    } catch (error) {
      print(error.toString());
    }
    print(message);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: user_idController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'ID',
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'e-mail',
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이름',
              ),
            ),
          ),

          const SizedBox(height: 5),

          Center(child:
          ElevatedButton(style: ElevatedButton.styleFrom(
              primary: Color(0xFFFFEE7E),
              minimumSize: const Size(250, 50),
              maximumSize: const Size(250, 50)),


              child: const Text('찾기',
                style: TextStyle(color: Color(0xAF854540), fontSize: 18),),
              onPressed: () {
                find_pw(user_idController.text.toString(), emailController.text.toString(), nameController.text.toString());
                Navigator.push(context, FadeRoute1(MainLogin()));
              }
          ),
          ),
        ],
      ),

    );

  }
}




class Sign_Up extends StatelessWidget { // 회원가입
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Color(0xFFFFEE7E),
        centerTitle: true,
        title: Text('회원가입', style: TextStyle(color: Color(0xAF854540), fontSize: 20)),

      ),
      body: const SignUpExample(),
    );
  }
}

class SignUpExample extends StatefulWidget { //회원가입 body 부분
  const SignUpExample({Key? key}) : super(key: key);

  @override
  State<SignUpExample> createState() => _SignUpExampleState();
}

class _SignUpExampleState extends State<SignUpExample> {// 회원가입 관련 창

  bool Sh = false;
  bool visible = false;

  var user_idController = TextEditingController();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordCheckController = TextEditingController();
  var gradeController = TextEditingController();
  var class_numberController = TextEditingController();
  var numberController = TextEditingController();

  Future<void> sign_up(String user_id, String email, String name, String password, int grade, int class_number, int number) async {
    var code, status, message;
    try {
      http.Response response = await http.post(
          Uri.parse('http://127.0.0.1:8000/users/'),
          headers: {"Content-Type" : "application/json; charset=UTF-8"},
          body: jsonEncode(<String, dynamic>{
            'user_id' : user_id,
            'email' : email,
            'name' : name,
            'password' : password,
            'grade_number' : grade,
            'class_number' : class_number,
            'student_number' : number
          }));
      var data = jsonDecode(response.body.toString());

      code = data['code'];
      status = data['status'];
      message = data['message'];

      if (response.statusCode == 200) {
        print(data['info']);
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: Color(0xFFFFEE7E),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text("회원가입을 성공하였습니다."),
                    ],
                  ),
                ),
              );
            }
        );
      } else {
        showDialog(context: context,
            builder: (BuildContext context){
              return AlertDialog(
                backgroundColor: Color(0xFFFFEE7E),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      Text("Sign up failed"),
                    ],
                  ),
                ),
              );
            }
        );
      }
    } catch (error) {
      print(error.toString());
    }
    print(message);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 15),
           Expandable(
              firstChild: const Text('개인정보 제공・활용 동의서'),
              secondChild: Center(child: const Text(
                  '개인정보보호법에 따라 개인 비서 어플에 회원가입 신청하시는 분께 수집하는 개인정보의 항목, 개인정보의 수집 및 이용목적, 개인정보 보유 및 이용기간, 동의 거부권 및 동의 거부 시 불이익에 관한 사항을 안내 드리오니 자세히 읽은 후 동의하여 주시기 바랍니다.'


                      ' 1. 수집하는 개인정보.'
                      '  회원가입 시점에 COM_ON이 이용자로부터 수집하는 개인정보는 아래와 같습니다.'
                      ' (회원 가입 시에''아이디, 비밀번호, 이름 , 학번, 메일 주소''를 필수항목으로 수집합니다.)'

                      ' 서비스 이용 과정에서 이용자로부터 수집하는 개인정보는 아래와 같습니다.'
                      ' (회원정보 또는 개별 서비스에서 프로필 정보(이름, 학번, 프로필 사진)를 설정할 수 있습니다.)'

                      ' 서비스 이용 과정에서 IP 주소, 서비스 이용 기록 등 이 생성되어 수집될 수 있습니다.'


                      ' 2. 수집한 개인정보의 이용.'
                      ' 개인 비서 어플의 회원관리, 서비스 개발・제공 및 향상, 안전한 어플리케이션 이용환경 구축 등 아래의 목적으로만 개인정보를 이용합니다.'
                      ' (법령 및 개인 비서 어플 이용약관을 위반하는 회원에 대한 이용 제한 조치, 부정 이용 행위를 포함하여 서비스의 원활한 운영에 지장을 주는 행위에 대한 방지 및 제대, 계정도용 및 부정거래 방지, 약관 개정 등의 고지사항 전달, 분쟁조정을 위한 기록 보존 등 이용자 보호 및 서비스 운영을 위하여 개인정보를 이용합니다.'
                      ' 보안, 프라이버시, 안전 측면에서 이용자가 안심하고 이용할 수 있는 서비스 이용환경 구축을 위해 개인정보를 이용합니다.)'


                      ' 3. 개인정보의 보관기간.'
                      ' COM_ON은 이용자가 졸업을 하는 날로부터 이용자의 개인정보를 지체없이 파기하고 있습니다.'


                      ' 4. 개인정보 수집 및 이용 동의를 거부할 권리.'
                      ' 이용자는 개인정보의 수집 및 이용 동의를 거부할 권리가 있습니다. 회원가입 시 수집하는 최소한의 개인정보, 즉, 필수 항목에 대한 수집 및 이용 동의를 거부하실 경우, 회원가입이 어려울 수 있습니다.')),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                '개인정보 제공・활용에 동의를 한다면 아래의 버튼을 눌러주세요.', style: TextStyle(fontSize: 15),
              ),
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Switch(
                    value:Sh,
                    onChanged: (value) {
                      setState((){
                        Sh = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text('회원 정보 입력란',
                  style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 2),

            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: user_idController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'user ID',
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'e-mail',
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordCheckController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password check',
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이름',
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: gradeController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '학년(1~3)'
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: class_numberController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '반(1~7)'
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: numberController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '번호'
                ),
              ),
            ),
            const SizedBox(height: 5),

            Center( child:
            ElevatedButton(style: ElevatedButton.styleFrom(
                primary: Color(0xFFFFEE7E),
                minimumSize: const Size(250, 50),
                maximumSize: const Size(250, 50)),


                child: const Text('회원가입',
                  style: TextStyle(color: Color(0xAF854540), fontSize: 18),),
                onPressed: () {
                  if ( Sh == false) {
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("경고!",
                                style: TextStyle(color: Color(0xAF854540))),
                            backgroundColor: Color(0xFFFFEE7E),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: [
                                  Text("이용약관 동의를 하지 않았습니다."),
                                ],
                              ),
                            ),
                          );
                        }
                    );
                  }
                  else if(passwordController.text == passwordCheckController.text){
                    sign_up(user_idController.text.toString(), emailController.text.toString(), nameController.text.toString(), passwordController.text.toString(),
                        int.parse(gradeController.text.toString()), int.parse(class_numberController.text.toString()), int.parse(numberController.text.toString()));
                    Navigator.push(context, FadeRoute1(MainLogin()));
                    setState( () {Counter = true;} );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("비밀번호 불일치",
                              style: TextStyle(color: Color(0xAF854540))),
                          backgroundColor: Color(0xFFFFEE7E),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Text("비밀번호가 일치하지 않습니다."),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                  }
                }
            ),
            ),
            const SizedBox(height: 40),
          ],
        )
    );



  }
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);
  InitState(){
    GetMealInfo(0, 0);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            canvasColor: Color(0xFFFFEE7E),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xAF854540),
            ),
            appBarTheme: const AppBarTheme(
              shadowColor: null,
              backgroundColor: Color(0xFFFFEE7E),
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(color: Color(0xAF854540)),
              bodyText1: TextStyle(color: Color(0xAF854540)),
              bodyText2: TextStyle(color: Color(0xAF854540)),
            )),
        home: Scaffold(
          drawerEnableOpenDragGesture: false,
          key: globalkey1,
          appBar: AppBar(
            title: Text("진량고등학교", style: TextStyle(color: Color(0xAF854540))),
            centerTitle: false,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Color(0xAF854540),
              onPressed: () => globalkey1.currentState!.openDrawer(),
            ),
          ),
          body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 13),
                  child: Text("오늘의 급식",
                      style: TextStyle(color: Color(0xAF854540))),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: const Text("공백"),
                        onPressed: () {
                          print("추후공개");
                        },
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 5.0, color: Color(0xAF854540)),
                            shadowColor: Color(0xFFFFE5A2),
                            primary: Color(0xFFFFE5A2),
                            maximumSize: const Size(120, 200),
                            minimumSize: const Size(120, 200)),
                      ),
                      ElevatedButton(
                        child: const Text("공백"),
                        onPressed: () {
                          print("추후공개");
                        },
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 5.0, color: Color(0xAF854540)),
                            shadowColor: Color(0xFFFFE5A2),
                            primary: Color(0xFFFFE5A2),
                            maximumSize: const Size(120, 200),
                            minimumSize: const Size(120, 200)),
                      ),
                      ElevatedButton(
                        child: const Text("공백"),
                        onPressed: () {
                          print("추후공개");
                        },
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 5.0, color: Color(0xAF854540)),
                            shadowColor: Color(0xFFFFE5A2),
                            primary: Color(0xFFFFE5A2),
                            maximumSize: const Size(120, 200),
                            minimumSize: const Size(120, 200)),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 13, top: 70),
                  child:
                      Text("시간표", style: TextStyle(color: Color(0xAF854540))),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: ElevatedButton(
                    child: const Text("공백"),
                    onPressed: () {
                      print("추후공개");
                    },
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 5.0, color: Color(0xAF854540)),
                        shadowColor: Color(0xFFFFE5A2),
                        primary: Color(0xFFFFE5A2),
                        maximumSize: const Size(double.infinity, 200),
                        minimumSize: const Size(double.infinity, 200)),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomAppBar(),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    child: Center(
                        child: _image == null
                            ? CircleAvatar(
                          radius: 45,
                          backgroundImage:
                          AssetImage('assets/KakaoTalk_계정.png'),
                        )
                            : Image.file(File(_image!.path))),
                  ),
                  accountEmail: Text('ghdrlfehd@naver.com'),
                  accountName: Text('홍길동'),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE5A2),
                  ),
                ),
                ListTile(
                  title: Text('메인'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('급식표'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => bob()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('시간표'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => time()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('커뮤니티'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => comunitiy()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('환경설정'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => account()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Color(0xAF854540),
                      ),
                      title: Text('로그아웃'),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
class bob extends StatelessWidget {
  const bob({Key? key}) : super(key: key);
  InitState(){
    GetMealInfo(0, 0);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            canvasColor: Color(0xFFFFEE7E),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xAF854540),
            ),
            appBarTheme: const AppBarTheme(
              shadowColor: null,
              backgroundColor: Color(0xFFFFEE7E),
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(color: Color(0xAF854540)),
              bodyText1: TextStyle(color: Color(0xAF854540)),
              bodyText2: TextStyle(color: Color(0xAF854540)),
            )),
        home: Scaffold(
          drawerEnableOpenDragGesture: false,
          key: globalkey1,
          appBar: AppBar(
            title: Text("급식정보", style: TextStyle(color: Color(0xAF854540))),
            centerTitle: false,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Color(0xAF854540),
              onPressed: () => globalkey1.currentState!.openDrawer(),
            ),
          ),
          body: Container(
                        width:double.infinity,
                        height:double.infinity,
                        child: Text("공사중"),
                        color: Colors.amberAccent,

          ),
          bottomNavigationBar: BottomAppBar(),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    child: Center(
                        child: _image == null
                            ? CircleAvatar(
                          radius: 45,
                          backgroundImage:
                          AssetImage('assets/KakaoTalk_계정.png'),
                        )
                            : Image.file(File(_image!.path))),
                  ),
                  accountEmail: Text('ghdrlfehd@naver.com'),
                  accountName: Text('홍길동'),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE5A2),
                  ),
                ),
                ListTile(
                  title: Text('메인'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('급식표'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => bob()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('시간표'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => time()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('커뮤니티'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => comunitiy()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('환경설정'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => account()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Color(0xAF854540),
                      ),
                      title: Text('로그아웃'),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
class  time extends StatelessWidget {
  const time({Key? key}) : super(key: key);
  InitState(){
    GetMealInfo(0, 0);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            canvasColor: Color(0xFFFFEE7E),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xAF854540),
            ),
            appBarTheme: const AppBarTheme(
              shadowColor: null,
              backgroundColor: Color(0xFFFFEE7E),
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(color: Color(0xAF854540)),
              bodyText1: TextStyle(color: Color(0xAF854540)),
              bodyText2: TextStyle(color: Color(0xAF854540)),
            )),
        home: Scaffold(
          drawerEnableOpenDragGesture: false,
          key: globalkey1,
          appBar: AppBar(
            title: Text("시간표", style: TextStyle(color: Color(0xAF854540))),
            centerTitle: false,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Color(0xAF854540),
              onPressed: () => globalkey1.currentState!.openDrawer(),
            ),
          ),
          body: Container(
            width:double.infinity,
            height:double.infinity,
            child: Text("공사중"),
            color: Colors.amberAccent,
          ),
          bottomNavigationBar: BottomAppBar(),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    child: Center(
                        child: _image == null
                            ? CircleAvatar(
                          radius: 45,
                          backgroundImage:
                          AssetImage('assets/KakaoTalk_계정.png'),
                        )
                            : Image.file(File(_image!.path))),
                  ),
                  accountEmail: Text('ghdrlfehd@naver.com'),
                  accountName: Text('홍길동'),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE5A2),
                  ),
                ),
                ListTile(
                  title: Text('메인'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('급식표'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => bob()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('시간표'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => time()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('커뮤니티'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => comunitiy()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('환경설정'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => account()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Color(0xAF854540),
                      ),
                      title: Text('로그아웃'),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
class  comunitiy extends StatelessWidget {
  const comunitiy({Key? key}) : super(key: key);
  InitState(){
    GetMealInfo(0, 0);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            canvasColor: Color(0xFFFFEE7E),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xAF854540),
            ),
            appBarTheme: const AppBarTheme(
              shadowColor: null,
              backgroundColor: Color(0xFFFFEE7E),
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(color: Color(0xAF854540)),
              bodyText1: TextStyle(color: Color(0xAF854540)),
              bodyText2: TextStyle(color: Color(0xAF854540)),
            )),
        home: Scaffold(
          drawerEnableOpenDragGesture: false,
          key: globalkey1,
          appBar: AppBar(
            title: Text("커뮤니티", style: TextStyle(color: Color(0xAF854540))),
            centerTitle: false,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Color(0xAF854540),
              onPressed: () => globalkey1.currentState!.openDrawer(),
            ),
          ),
          body: Container(
            width:double.infinity,
            height:double.infinity,
            child: Text("공사중"),
            color: Colors.amberAccent,
          ),
          bottomNavigationBar: BottomAppBar(),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    child: Center(
                        child: _image == null
                            ? CircleAvatar(
                          radius: 45,
                          backgroundImage:
                          AssetImage('assets/KakaoTalk_계정.png'),
                        )
                            : Image.file(File(_image!.path))),
                  ),
                  accountEmail: Text('ghdrlfehd@naver.com'),
                  accountName: Text('홍길동'),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE5A2),
                  ),
                ),
                ListTile(
                  title: Text('메인'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('급식표'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => bob()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('시간표'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => time()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('커뮤니티'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => comunitiy()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('환경설정'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => account()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Color(0xAF854540),
                      ),
                      title: Text('로그아웃'),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
class account extends StatefulWidget {
  const account({Key? key}) : super(key: key);

  @override
  _account createState() => _account();
}

File? _image;
//이미지 저장소


class _account extends State<account> {
  var UserName = TextEditingController();
  var UserAccount = TextEditingController();
  //유저 데이터
  final picker = ImagePicker();
  var switchValue = false;
  //스위치 관련

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);
    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFFFE5A2),
            canvasColor: Color(0xFFFFEE7E),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color(0xAF854540),
            ),
            appBarTheme: const AppBarTheme(
              shadowColor: null,
              backgroundColor: Color(0xFFFFEE7E),
            ),
            textTheme: const TextTheme(
              headline1: TextStyle(color: Color(0xAF854540)),
              bodyText1: TextStyle(color: Color(0xAF854540)),
              bodyText2: TextStyle(color: Color(0xAF854540)),
            )),
        home: Scaffold(
          drawerEnableOpenDragGesture: false,
          key: globalkey3,
          appBar: AppBar(
            title: Text("환경설정", style: TextStyle(color: Color(0xAF854540))),
            centerTitle: false,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(Icons.menu),
              color: Color(0xAF854540),
              onPressed: () => globalkey3.currentState!.openDrawer(),
            ),
          ),
          body: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        child: Center(
                          child: _image == null
                              ? CircleAvatar(
                                  radius: 45,
                                  backgroundImage:
                                      AssetImage('assets/KakaoTalk_계정.png'),
                                )
                              : Image.file(File(_image!.path)),
                        ),
                      ),
                      Container(
                        height: 60,
                        child: Column(
                          children: [
                            Text('홍길동',
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xAF854540))),
                            Text('ghdrlfehd@naver.com',
                                style: TextStyle(
                                    fontSize: 20, color: Color(0xAF854540))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Column(
                          children: <Widget>[
                            Image.asset('assets/KakaoTalk_계정.png'),
                            Text('프로필사진 변경',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xAF854540))),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 5.0, color: Color(0xAF854540)),
                            alignment: Alignment.center,
                            elevation: 0,
                            shadowColor: Color(0xFFFFE5A2),
                            primary: Color(0xFFFFEE7E),
                            maximumSize: const Size(150, 150),
                            minimumSize: const Size(150, 150),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(" 프로필 사진 변경",
                                    style: TextStyle(color: Color(0xAF854540))),
                                backgroundColor: Color(0xFFFFEE7E),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      ElevatedButton(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 15,
                                              height: 60,
                                            ),
                                            Container(
                                                child: Text('갤러리에서 찾아오기',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color(
                                                            0xAF854540)))),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            alignment: Alignment.centerLeft,
                                            elevation: 0,
                                            shadowColor: Color(0xFFFFE5A2),
                                            primary: Color(0xFFFFE5A2),
                                            maximumSize:
                                                const Size(double.infinity, 70),
                                            minimumSize: const Size(
                                                double.infinity, 70)),
                                        onPressed: () {
                                          getImage(ImageSource.gallery);
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 15,
                                              height: 60,
                                            ),
                                            Container(
                                                child: Text('사진 찍기',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color(
                                                            0xAF854540)))),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            alignment: Alignment.centerLeft,
                                            elevation: 0,
                                            shadowColor: Color(0xFFFFE5A2),
                                            primary: Color(0xFFFFE5A2),
                                            maximumSize:
                                                const Size(double.infinity, 70),
                                            minimumSize: const Size(
                                                double.infinity, 70)),
                                        onPressed: () {
                                          getImage(ImageSource.camera);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      ElevatedButton(
                        child: Column(
                          children: [
                            Image.asset('assets/KakaoTalk_개인정보 보호.png'),
                            Text('계정 설정',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xAF854540))),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 5.0, color: Color(0xAF854540)),
                            alignment: Alignment.center,
                            elevation: 0,
                            shadowColor: Color(0xFFFFE5A2),
                            primary: Color(0xFFFFEE7E),
                            maximumSize: const Size(150, 150),
                            minimumSize: const Size(150, 150),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => authentication()));
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        child: Column(
                          children: [
                            Image.asset('assets/User_image.png'),
                            Text('알람 설정',
                                style: TextStyle(
                                    fontSize: 16, color: Color(0xAF854540))),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 5.0, color: Color(0xAF854540)),
                            alignment: Alignment.center,
                            elevation: 0,
                            shadowColor: Color(0xFFFFE5A2),
                            primary: Color(0xFFFFEE7E),
                            maximumSize: const Size(150, 150),
                            minimumSize: const Size(150, 150),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("계정 변경",
                                    style: TextStyle(color: Color(0xAF854540))),
                                backgroundColor: Color(0xFFFFEE7E),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      TextField(
                                          controller: UserAccount,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: '계정 변경',
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      ElevatedButton(
                        child: Column(
                          children: [
                            Image.asset('assets/User_image.png'),
                            Text('회원 탈퇴',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xAF854540))),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(
                                width: 5.0, color: Color(0xAF854540)),
                            alignment: Alignment.center,
                            elevation: 0,
                            shadowColor: Color(0xFFFFE5A2),
                            primary: Color(0xFFFFEE7E),
                            maximumSize: const Size(150, 150),
                            minimumSize: const Size(150, 150),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("회원탈퇴",
                                    style: TextStyle(color: Color(0xAF854540))),
                                backgroundColor: Color(0xFFFFEE7E),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Text("정말 회원탈퇴를 하시겠습니까?",
                                          style: TextStyle(
                                              color: Color(0xAF854540))),
                                      ElevatedButton(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 15,
                                              height: 60,
                                            ),
                                            Container(
                                                child: Text('예',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color(
                                                            0xAF854540)))),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            alignment: Alignment.centerLeft,
                                            elevation: 0,
                                            shadowColor: Color(0xFFFFE5A2),
                                            primary: Color(0xFFFFE5A2),
                                            maximumSize:
                                                const Size(double.infinity, 70),
                                            minimumSize: const Size(
                                                double.infinity, 70)),
                                        onPressed: () {},
                                      ),
                                      ElevatedButton(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              width: 15,
                                              height: 60,
                                            ),
                                            Container(
                                                child: Text('아니오',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Color(
                                                            0xAF854540)))),
                                          ],
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            alignment: Alignment.centerLeft,
                                            elevation: 0,
                                            shadowColor: Color(0xFFFFE5A2),
                                            primary: Color(0xFFFFE5A2),
                                            maximumSize:
                                                const Size(double.infinity, 70),
                                            minimumSize: const Size(
                                                double.infinity, 70)),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children:<Widget>[
                      Container(width:15,height:100,),
                      Switch(
                        value:switchValue,
                        onChanged:(value){
                          setState( () {switchValue = value;} );
                        },
                      ),
                      Container(width:10,height:100,),
                      Container(child:Text('알람 설정',style:TextStyle(fontSize:20,color:Color(0xAF854540)))),
                    ],
                  ),
                  alignment: Alignment.centerLeft,
                  color:Color(0xFFFFE5A2),
                  width:double.infinity,
                  height:70,
                ),
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    child: Center(
                        child: _image == null
                            ? CircleAvatar(
                          radius: 45,
                          backgroundImage:
                          AssetImage('assets/KakaoTalk_계정.png'),
                        )
                            : Image.file(File(_image!.path))),
                  ),
                  accountEmail: Text('ghdrlfehd@naver.com'),
                  accountName: Text('홍길동'),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE5A2),
                  ),
                ),
                ListTile(
                  title: Text('메인'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Main()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('급식표'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => bob()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('시간표'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => time()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('커뮤니티'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => comunitiy()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    height: 1.0,
                    width: 150.0,
                    color: Color(0xAF854540),
                  ),
                ),
                ListTile(
                  title: Text('환경설정'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => account()));
                    globalkey1.currentState!.closeDrawer();
                    globalkey2.currentState!.closeDrawer();
                    globalkey3.currentState!.closeDrawer();
                    globalkey4.currentState!.closeDrawer();
                    globalkey5.currentState!.closeDrawer();
                  },
                ),
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: Color(0xAF854540),
                      ),
                      title: Text('로그아웃'),
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}



class authentication  extends StatelessWidget {
  var password = TextEditingController();
  var user = '123456';
  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFFE5A2),
          canvasColor: Color(0xFFFFEE7E),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xAF854540),
          ),
          appBarTheme: const AppBarTheme(
            shadowColor:null,
            backgroundColor: Color(0xFFFFEE7E),
          ),

          textTheme:const TextTheme(
            headline1: TextStyle(color: Color(0xAF854540)),
            bodyText1: TextStyle(color: Color(0xAF854540)),
            bodyText2: TextStyle(color: Color(0xAF854540)),
          )
      ),
      home:Scaffold(
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          title:Text("본인인증",style:TextStyle(color:Color(0xAF854540))),
          centerTitle: false,
          elevation: 0.0,
        ),
        body:Container(
          child: Column(
            children:[
              Container(
                height:40,
              ),
              TextField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '비밀번호 확인',
                  )),
              Container(
                height:40,
              ),
              ElevatedButton(
                child: Center(
                  child:Text('확인',style:TextStyle(fontSize:20,color:Color(0xAF854540))),
                ),
                style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft,elevation: 0,shadowColor:Color(0xFFFFE5A2),primary:Color(0xFFFFEE7E), maximumSize:const Size(200,60), minimumSize:const Size(200,60)),
                onPressed:(){
                  if(password.text == user){
                    //&&:'그리고'라는 성질이 뜸,=!:그 값과 같지 않을떄
                    Navigator.push(context,MaterialPageRoute(builder: (context) => setting()));
                  }
                  else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("비밀번호 불일치",
                              style: TextStyle(color: Color(0xAF854540))),
                          backgroundColor: Color(0xFFFFEE7E),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                               Text("비밀번호가 일치하지 않습니다."),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class setting extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFFE5A2),
          canvasColor: Color(0xFFFFEE7E),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xAF854540),
          ),
          appBarTheme: const AppBarTheme(
            shadowColor:null,
            backgroundColor: Color(0xFFFFEE7E),
          ),

          textTheme:const TextTheme(
            headline1: TextStyle(color: Color(0xAF854540)),
            bodyText1: TextStyle(color: Color(0xAF854540)),
            bodyText2: TextStyle(color: Color(0xAF854540)),
          )
      ),
      home:Scaffold(
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          title:Text("계정 설정",style:TextStyle(color:Color(0xAF854540))),
          centerTitle: false,
          elevation: 0.0,
        ),
        body:Container(
          child: Column(
            children:[
              ElevatedButton(
                child: Row(
                  children: [
                    Container(width:30,height:100,),
                    Container(child:Text('닉네임 설정',style:TextStyle(fontSize:20,color:Color(0xAF854540)))),
                  ],
                ),
                onPressed:(){Navigator.push(context,MaterialPageRoute(builder: (context) => account()));},
                style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft,elevation: 0,shadowColor:Color(0xFFFFE5A2),primary:Color(0xFFFFE5A2), maximumSize:const Size(double.infinity,70), minimumSize:const Size(double.infinity,70)),
              ),
              Padding(
                padding:EdgeInsets.symmetric(horizontal:10.0),
                child:Container(
                  height:3.0,
                  width:double.infinity,
                  color:Color(0xAF854540),
                ),
              ),
              ElevatedButton(
                child: Row(
                  children: [
                    Container(width:30,height:100,),
                    Container(child:Text('이메일 변경',style:TextStyle(fontSize:20,color:Color(0xAF854540)))),
                  ],
                ),
                style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft,elevation: 0,shadowColor:Color(0xFFFFE5A2),primary:Color(0xFFFFE5A2), maximumSize:const Size(double.infinity,70), minimumSize:const Size(double.infinity,70)),
                onPressed:(){},
              ),
              Padding(
                padding:EdgeInsets.symmetric(horizontal:10.0),
                child:Container(
                  height:3.0,
                  width:double.infinity,
                  color:Color(0xAF854540),
                ),
              ),
              ElevatedButton(
                child: Row(
                  children: [
                    Container(width:30,height:100,),
                    Container(child:Text('비밀번호 변경',style:TextStyle(fontSize:20,color:Color(0xAF854540)))),
                  ],
                ),
                style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft,elevation: 0,shadowColor:Color(0xFFFFE5A2),primary:Color(0xFFFFE5A2), maximumSize:const Size(double.infinity,70), minimumSize:const Size(double.infinity,70)),
                onPressed:(){Navigator.push(context,MaterialPageRoute(builder: (context) => password()));},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CorrectWordParameter {
  bool is8Characters;
  bool is1Symbol;
  bool is1Letter;
  bool is1Number;

  CorrectWordParameter(
      {this.is8Characters = false,
      this.is1Symbol = false,
      this.is1Letter = false,
      this.is1Number = false});

  bool get isCorrectWord =>
      (is8Characters && is1Symbol && is1Letter && is1Number);
}

CorrectWordParameter checkPossiblePasswordText(String value) {
  var correctWordParameter = CorrectWordParameter();
  final validNumbers = RegExp(r'(\d+)');
  final validAlphabet = RegExp(r'[a-zA-Z]');
  final validSpecial = RegExp(r'^[a-zA-Z0-9 ]+$');

  //문자가 비었는지 확인
  if (value.isEmpty) {
    // 문자가 비었다면 모드 false로 리턴
    return CorrectWordParameter();
  }

  //8자 이상인지 확인
  if (value.length >= 8) {
    correctWordParameter.is8Characters = true;
  } else {
    correctWordParameter.is8Characters = false;
  }

  //특수기호가 있는지 확인
  if (!validSpecial.hasMatch(value)) {
    correctWordParameter.is1Symbol = true;
  } else {
    correctWordParameter.is1Symbol = false;
  }

  //문자가 있는지 확인
  if (!validAlphabet.hasMatch(value)) {
    correctWordParameter.is1Letter = false;
  } else {
    correctWordParameter.is1Letter = true;
  }

  //숫자가 있는지 확인
  if (validNumbers.hasMatch(value)) {
    correctWordParameter.is1Number = true;
  } else {
    correctWordParameter.is1Number = false;
  }
  return correctWordParameter;
}
//인터넷에서 배꼈지만 반박할수가 없었다...








class password extends StatefulWidget {
  const password({Key? key}) : super(key: key);

  @override
  State<password> createState() => _repassword();
}

class _repassword extends State<password> {

  var re_password=TextEditingController();
  final ValueKey1 = GlobalKey<FormState>();
  String password = '';
  void _validator(){
    final isValid = ValueKey1.currentState!.validate();
    if(isValid){
      ValueKey1.currentState!.save();
      Navigator.push(context,MaterialPageRoute(builder: (context) => setting()));
    }
    else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("경고",
                style: TextStyle(color: Color(0xAF854540))),
            backgroundColor: Color(0xFFFFEE7E),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text("비밀번호 양식이 틀렸습니다."),
                ],
              ),
            ),
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final validNumbers = RegExp(r'(\d+)');
    final validAlphabet = RegExp(r'[a-zA-Z]');

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
    },

      child:MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFFE5A2),
          canvasColor: Color(0xFFFFEE7E),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xAF854540),
          ),
          appBarTheme: const AppBarTheme(
            shadowColor: null,
            backgroundColor: Color(0xFFFFEE7E),
          ),
          textTheme: const TextTheme(
            headline1: TextStyle(color: Color(0xAF854540)),
            bodyText1: TextStyle(color: Color(0xAF854540)),
            bodyText2: TextStyle(color: Color(0xAF854540)),
          )),
      home: Scaffold(
        appBar: AppBar(
          title: Text("비밀번호 변경", style: TextStyle(color: Color(0xAF854540))),
          centerTitle: false,
          elevation: 0.0,
        ),

        body: Form(
          child: Column(
            children:<Widget>[
              Container(height:30,),
              TextFormField(
                  obscureText: true,
                  key:ValueKey1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    // 입력값이 없으면 메시지 출력
                    print ('validater :');
                    print(value);
                    if (value!.isEmpty) {
                      return '입력값이 없습니다.';
                    }
                    else if (!validAlphabet.hasMatch(value)) {
                      return '알파벳이 최소 1개 이상이 있어야 합니다.';
                    }
                    else if (!validNumbers.hasMatch(value)) {
                      return '숫자가 최소 1개 이상이 있어야 합니다.';
                    }
                    else if(value.length < 8){
                      return '비밀번호는 8자 이상이여야 합니다.';
                    }
                    else if (value.length > 15) {
                      return '비밀번호는 최대 15개 이하이여야 합니다.';
                    }
                    else {
                      return null;
                    }
                  },
                  onSaved: (value){
                    setState(() {
                      password = value!;
                    });
                  },
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '비밀번호 변경',
                  )
              ),
              Container(height:30,child:Text(password),),
              ElevatedButton(
                child: Center(
                  child:Text('확인',style:TextStyle(fontSize:20,color:Color(0xAF854540))),
                ),
                style: ElevatedButton.styleFrom(alignment: Alignment.centerLeft,elevation: 0,shadowColor:Color(0xFFFFE5A2),primary:Color(0xFFFFEE7E), maximumSize:const Size(120,60), minimumSize:const Size(120,60)),
                onPressed:(){
                  _validator();
                },
              ),
            ],
          ),
        ),
      ),
     ),
    );
  }
}
