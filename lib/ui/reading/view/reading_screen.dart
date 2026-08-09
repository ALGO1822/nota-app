import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:nota_app/domain/entities/note.dart';
import 'package:nota_app/ui/core/widgets/nota_bar.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';
import 'package:nota_app/ui/core/animations/nota_animation_library.dart';

class ReadingScreen extends StatefulWidget {
  final Note note;
  const ReadingScreen({super.key, required this.note});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final PdfViewerController _pdfController = PdfViewerController();

  final ValueNotifier<int> _currentPage = ValueNotifier<int>(1);
  final ValueNotifier<int> _totalPages = ValueNotifier<int>(0);
  bool _isAppBarVisible = true;
  Offset? _tapDownPosition;

  @override
  void initState() {
    super.initState();
    _pdfController.addListener(_updatePageInfo);
  }

  void _updatePageInfo() {
    if (_pdfController.isReady) {
      final newPage = _pdfController.pageNumber ?? 1;
      final newTotal = _pdfController.pages.length;
      
      // Update values directly; no setState required!
      if (_currentPage.value != newPage) _currentPage.value = newPage;
      if (_totalPages.value != newTotal) _totalPages.value = newTotal;
    }
  }

  @override
  void dispose() {
    _pdfController.removeListener(_updatePageInfo);
    _currentPage.dispose();
    _totalPages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dynamicBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final displayTitle = widget.note.title.replaceAll(
      RegExp(r'\.pdf$', caseSensitive: false),
      '',
    );

    return Scaffold(
      backgroundColor: dynamicBackgroundColor,
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          // 1. Wrap the PDF in a GestureDetector to catch screen taps
          Listener(
            onPointerDown: (details) => _tapDownPosition = details.position,
              onPointerUp: (details) {
                if (_tapDownPosition != null) {
                  // Calculate how far the finger dragged
                  final distance = (details.position - _tapDownPosition!).distance;
                  
                  // If it moved less than 10 pixels, it was a tap, not a scroll
                  if (distance < 10) {
                    setState(() {
                      _isAppBarVisible = !_isAppBarVisible;
                    });
                  }
                }
              },
            child: PdfViewer.file(
              widget.note.filePath,
              controller: _pdfController,
              useProgressiveLoading: true,
              params: PdfViewerParams(
                backgroundColor: dynamicBackgroundColor,
                panEnabled: true,
                scaleEnabled: true,
                minScale: 0.8,
                maxScale: 8.0,
                margin: AppSpacing.md,
              ),
            ),
          ),

          // 2. The Animated AppBar with the Gradient Scrim
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: !_isAppBarVisible,
                child: NotaAnimations.slideHide(
                  isVisible: _isAppBarVisible,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black87, Colors.transparent],
                        stops: [0.0, 1.0],
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                    child: NotaAppBar(
                      title: Text(
                        displayTitle,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: AppFonts.semibold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: NotaIconButton(
                        icon: Icons.arrow_back_ios_new, 
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      actions: [
                        NotaIconButton(
                          icon: Icons.more_horiz, 
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 3. The Animated Page Counter
          // We wrap this in an AnimatedOpacity so it also vanishes in Focus Mode
          ValueListenableBuilder<int>(
            valueListenable: _totalPages,
            builder: (context, total, _) {
              if (total == 0) return const SizedBox.shrink();
              
              return Positioned(
                bottom: AppSpacing.lg,
                right: AppSpacing.lg,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _isAppBarVisible ? 1.0 : 0.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.85),
                      borderRadius: AppRadius.pillRadius,
                    ),
                    // Listen to the current page as well
                    child: ValueListenableBuilder<int>(
                      valueListenable: _currentPage,
                      builder: (context, current, _) {
                        return Text(
                          '$current / $total',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: AppFonts.medium,
                            letterSpacing: 0.5,
                          ),
                        );
                      }
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
