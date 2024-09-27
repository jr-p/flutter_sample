import 'package:flutter/material.dart';

class BottomSheetUtils {
  // ボトムシートを表示する
  static void showBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.93,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close, color: Colors.black),
              ),
              Expanded(child: child),
            ],
          )
        );
      },
    );
  }
}