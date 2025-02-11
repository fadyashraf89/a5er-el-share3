import 'package:a5er_elshare3/core/utils/Constants/constants.dart';
import 'package:flutter/material.dart';

class RoundedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double? height;
  final Color? color;
  final String? imagePath; // Add this to allow image customization

  const RoundedAppBar({
    super.key,
    this.title = "",
    this.height,
    this.color,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: Stack(
        children: [
          // Background Circle
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
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),

          // Image
          if (imagePath != null)
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  imagePath!,
                  fit: BoxFit.contain,
                  width: 300,
                  height: 300,
                ),
              ),
            ),

          // Title
          Center(
            child: Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: kFontFamilyArchivo,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height!);
}
