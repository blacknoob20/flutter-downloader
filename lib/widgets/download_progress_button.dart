import 'package:flutter/material.dart';

class DownloadProgressButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const DownloadProgressButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  State<DownloadProgressButton> createState() => _DownloadProgressButtonState();
}

class _DownloadProgressButtonState extends State<DownloadProgressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fillAnimation;
  late Animation<double> _scaleAnimation;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOutCubic),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePress() {
    if (!_isDownloading) {
      setState(() {
        _isDownloading = true;
      });
      _animationController.forward();
      widget.onPressed();

      Future.delayed(const Duration(milliseconds: 1800), () {
        if (mounted) {
          setState(() {
            _isDownloading = false;
          });
          _animationController.reset();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final successColor = Colors.green[600] ?? Colors.green;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Fondo gradiente de progreso
            AnimatedBuilder(
              animation: _fillAnimation,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          successColor.withAlpha((0.15 * 255).round()),
                          successColor.withAlpha((0.1 * 255).round()),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        ClipRect(
                          clipper: _ProgressClipper(_fillAnimation.value),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  successColor,
                                  successColor.withAlpha((240)),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Botón frontal con sombra
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    // color: colorScheme.primary.withAlpha((0.3 * 255).round()),
                    color: Colors.transparent,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isDownloading ? null : _handlePress,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // color: colorScheme.primary,
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.transparent,
                        // color: colorScheme.primary.withAlpha((30)),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isDownloading)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.onPrimary,
                              ),
                              strokeWidth: 2,
                            ),
                          )
                        else
                          Icon(
                            Icons.download_rounded,
                            color: colorScheme.inversePrimary,
                            size: 22,
                          ),
                        const SizedBox(width: 12),
                        Text(
                          widget.label,
                          style: TextStyle(
                            color: colorScheme.inversePrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressClipper extends CustomClipper<Rect> {
  final double progress;

  _ProgressClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(_ProgressClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}
