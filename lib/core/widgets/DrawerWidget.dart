import 'package:a5er_elshare3/features/AuthService/data/Database/FirebaseAuthentication.dart';
import 'package:flutter/material.dart';

abstract class DrawerWidget{
  AuthService authentication = AuthService();
  Widget OpenDrawer();
}