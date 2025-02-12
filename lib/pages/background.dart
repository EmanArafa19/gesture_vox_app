import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        
        _buildGradientCircle(-70, 350, context),
        _buildGradientCircle(200, -100, context),
        _buildGradientCircle(300, -70, context),
        _buildGradientCircle(500, 250, context),
        
        Positioned.fill(child: child), 
      ],
    );
  }

  Widget _buildGradientCircle(double top, double left, BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: 244,
        height: 244,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: isDarkMode
                ? [
                    Color.fromRGBO(198, 151, 228, 1).withOpacity(0.06),
                    Color.fromRGBO(159, 102, 198, 0.4).withOpacity(0.05),
                    Colors.black.withOpacity(0.05),
                  ]
                : [
                    Color.fromRGBO(159, 102, 198, 0.4).withOpacity(0.04),
                    Color.fromRGBO(198, 151, 228, 1).withOpacity(0.08),
                    Colors.white.withOpacity(0.05),
                  ],
            stops: [0.3, 0.7, 1.0],
          ),
        ),
      ),
    );
  }
}
