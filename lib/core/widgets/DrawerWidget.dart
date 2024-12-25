import 'package:flutter/material.dart';

import '../../features/Authentication/data/Database/FirebaseAuthentication.dart';

abstract class DrawerWidget{
  Authentication authentication = Authentication();
  Widget OpenDrawer();
}