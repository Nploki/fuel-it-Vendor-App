import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class profileMenuWidget extends StatelessWidget {
  const profileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    required this.endIcon,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)
            .apply(color: textColor),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: const Color.fromARGB(255, 222, 225, 228),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 18,
              ),
            )
          : null,
    );
  }
}
