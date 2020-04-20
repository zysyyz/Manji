import 'package:flutter/material.dart';

import 'package:apple_sign_in/apple_sign_in.dart';

import 'components/furigana_text.dart';
import 'package:kanji_dictionary/resource/repository.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: FuriganaText(
          text: '設定',
          tokens: [Token(text: '設定', furigana: 'せってい')],
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: ListView(
        children: <Widget>[
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            child: FutureBuilder(
              future: repo.getIsUpdated(),
              builder: (_, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  var isUpdated = snapshot.data;
                  if (isUpdated) {
                    return ListTile(
                      leading: Icon(Icons.wrap_text, color: Colors.white),
                      title: Text('Update database', style: TextStyle(color: Colors.white)),
                      subtitle: Text('Keeping dictionary database up to date increases the accuracy and reliability \n(Your database is up to date)',
                          style: TextStyle(color: Colors.white54)),
                      onTap: () {
                        scaffoldKey.currentState.hideCurrentSnackBar();
                        scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                            'Your database is up to date',
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: Theme.of(context).accentColor,
                          action: SnackBarAction(
                            label: 'Dismiss',
                            onPressed: () => scaffoldKey.currentState.hideCurrentSnackBar(),
                            textColor: Colors.blueGrey,
                          ),
                        ));
                      },
                    );
                  } else {
                    return ListTile(
                        leading: Icon(Icons.wrap_text, color: Colors.white),
                        title: Text('Update database', style: TextStyle(color: Colors.white)),
                        subtitle: Text(
                            'Keeping dictionary database up to date increases the accuracy and reliability \n(Your database needs to be updated)',
                            style: TextStyle(color: Colors.white54)),
                        onTap: () {
                          repo.fetchUpdates().whenComplete(() {
                            scaffoldKey.currentState.hideCurrentSnackBar();
                            scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(
                                'Database has been updated successfully',
                                style: TextStyle(color: Colors.black),
                              ),
                              backgroundColor: Theme.of(context).accentColor,
                              action: SnackBarAction(
                                label: 'Dismiss',
                                onPressed: () => scaffoldKey.currentState.hideCurrentSnackBar(),
                                textColor: Colors.blueGrey,
                              ),
                            ));
                          });
                        });
                  }
                } else {
                  return ListTile(
                    leading: Icon(Icons.wrap_text, color: Colors.white),
                    title: Text('Update database', style: TextStyle(color: Colors.white)),
                    subtitle: Text('Keeping dictionary database up to date increases the accuracy and reliability',
                        style: TextStyle(color: Colors.white54)),
                  );
                }
              },
            ),
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.swap_horiz, color: Colors.white),
            title: Text('Transfer my data', style: TextStyle(color: Colors.white)),
            subtitle: Text(
              'Transfer your data to a another device',
              style: TextStyle(color: Colors.white54),
            ),
            onTap: () {
              scaffoldKey.currentState.hideCurrentSnackBar();
              scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(
                  'Data Transfer is not yet availible',
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.yellow,
                action: SnackBarAction(label: 'Dismiss', onPressed: () => scaffoldKey.currentState.hideCurrentSnackBar()),
              ));
            },
          ),
          Divider(height: 0),
          ListTileTheme(
            textColor: Colors.white70,
            child: AboutListTile(
              applicationIcon: Container(
                height: 100,
                width: 100,
                child: Center(child: Image.asset('data/1024.png', fit: BoxFit.contain)),
              ),
              applicationVersion: '2.2.0',
              aboutBoxChildren: <Widget>[SizedBox(height: 24,),Text('Manji helps Japanese learners learn Japanese Kanji')],
            ),
          ),
//          Divider(),
//          AppleSignInButton(
//            style: ButtonStyle.black,
//            type: ButtonType.signIn,
//            onPressed: appleLogIn,
//          )
        ],
      ),
    );
  }

  void appleLogIn() async {
    if (await AppleSignIn.isAvailable()) {
      final result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential.user ?? "null"); //All the required credentials
          print(result.credential.fullName.familyName);
          break;
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    } else {
      print('Apple SignIn is not available for your device');
    }
  }
}
