import 'package:flutter_sample/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sample/src/utils/dialog_utils.dart';
import 'package:flutter_sample/src/utils/route_utils.dart';
import 'package:flutter_sample/src/utils/snackbar_utils.dart';
import 'package:provider/provider.dart';

// ドロワーの共通部分
class CommonDrawer extends StatefulWidget {
  const CommonDrawer({ super.key });

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {

  void logout () async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    DialogUtils.showLoadingDialog(context);
    
    await authProvider.logout();

    if (!mounted) return;

    DialogUtils.hideLoadingDialog(context);
    if (authProvider.message != null) {
      SnackbarUtils.showSnackbar(context, authProvider.message!);
    } else {
      RouteUtils.navigateToAuthWrapper(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding:  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
              decoration: const BoxDecoration(
                color: Colors.pink,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      'Common Drawer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      return IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      );
                    },
                  )
                ],
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                logout();
              },
            ),
          ],
        )
      )
    );
  }
}