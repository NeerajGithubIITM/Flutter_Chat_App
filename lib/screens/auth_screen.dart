import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String userName,
    File userImage,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        // Log the user in
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // Sign the user up
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Storing extra user data -- here username and image .... and email also while we are at it :)
        final ref = FirebaseStorage.instance
            .ref() // Points at the root bucket
            .child('user_image') // Points at/creates a folder in the root bucket
            .child(authResult.user.uid + '.jpg'); // a file in the folder.

        await ref.putFile(userImage).onComplete;
        // putFile has a StorageMetadata argument one can use
        // putFile returns a StorageUploadTask, but onComplete returns a Future which we can await.

        final userImageUrl = await ref.getDownloadURL();

        await Firestore.instance
            .collection('users') // Automatically creates this collection.
            .document(authResult.user.uid)
            .setData({
          'username': userName,
          'email': email,
          'image_url' :userImageUrl,
        }); // Makes sense to set _isLoading to false after successful execution of try block also, but we'll navigate the user to somewhere else anyway so no big deal.

        // Sending the needed requests to the api, sending and managing the token, is all managed by firebase behind the scenes.
      }
    } on PlatformException catch (err) {
      // Catching a specific type of error
      var message = 'An error occurred, please check your credentials';

      if (err.message != null) {
        message = err.message;
      }

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      // Verry imp: Why do we need this ctx, why not context
      // The context passed must have a Scaffold ancestor, i.e the provided context must not be from the same StatefulWidget as that whose build function actually creates the Scaffold widget being sought.
      // So, we need the context i.e 'ctx' of the AuthForm() whose ancestor is Scaffold with 'context'.

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      // Catches any err other than the other type
      // There shouldn't be any, isn't likely to be any.
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo[900],
            Colors.deepPurple[800],
            Colors.pink[400],
            Colors.pink[100],
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor, // which is no color :)
        body: AuthForm(_submitAuthForm, _isLoading),
      ),
    );
  }
}
