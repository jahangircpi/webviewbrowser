import 'package:flutter/material.dart';
import 'package:webviewflutter/Screens/homescreen.dart';

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  TextEditingController urlController = TextEditingController();
  double radius = 20.0;
  @override
  Widget build(BuildContext context) {
    SnackBar snackBar = SnackBar(content: Text('Enter a Valid website!'));
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Container(
                height: size.height * 0.25,
                width: size.width,
                child: Image.asset(
                  'assets/searchlogo.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.purple),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(radius),
                              bottomLeft: Radius.circular(radius),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "BROWSE",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your Url",
                                hintStyle:
                                    TextStyle(color: Colors.purple.shade400),
                              ),
                              controller: urlController,
                              onSubmitted: (v) {
                                if (urlController.text.isEmpty) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  if (!urlController.text.contains('.') ||
                                      urlController.text.contains(' ')) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MyHomePage(
                                            selectedUrl:
                                                "www.google.com/search?q=" +
                                                    '${urlController.text}',
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MyHomePage(
                                            selectedUrl: urlController.text ??
                                                'google.com',
                                          );
                                        },
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                splashColor: Colors.blue,
                onTap: () {
                  //https://www.google.com/search?q=" + 'jahangir'
                  if (urlController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    if (!urlController.text.contains('.') ||
                        urlController.text.contains(' ')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MyHomePage(
                              selectedUrl: "www.google.com/search?q=" +
                                  '${urlController.text}',
                            );
                          },
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return MyHomePage(
                              selectedUrl: urlController.text ?? 'google.com',
                            );
                          },
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60.0, vertical: 12),
                    child: Text(
                      "Go",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.15,
              ),
              Text(
                'Explore',
                style: TextStyle(
                    fontSize: 70,
                    color: Colors.purple,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
