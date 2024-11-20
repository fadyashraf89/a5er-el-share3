import "package:flutter/material.dart";

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const RoundedAppBar({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: Stack(children: [
        LayoutBuilder(builder: (context, constraint) {
          final width = constraint.maxWidth * 6;
          return ClipRect(
            child: OverflowBox(
              maxHeight: double.infinity,
              maxWidth: double.infinity,
              child: SizedBox(
                width: width,
                height: width,
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: width / 2 - preferredSize.height / 2),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xff1d198b),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: "Archivo"
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(130.0);
}
