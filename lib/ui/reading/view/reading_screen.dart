import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:nota_app/domain/entities/note.dart';
import 'package:nota_app/ui/core/widgets/nota_bar.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';

class ReadingScreen extends StatefulWidget {
  final Note note;

  const ReadingScreen({super.key, required this.note});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  // 1. Initialize the controller to track the PDF's state
  final PdfViewerController _pdfController = PdfViewerController();

  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    // 2. Listen for scroll/page changes
    _pdfController.addListener(_updatePageInfo);
  }

  void _updatePageInfo() {
    // Only update if the document has successfully loaded
    if (_pdfController.isReady) {
      final newPage = _pdfController.pageNumber;
      final newTotal = _pdfController.pages.length;

      // Prevent unnecessary UI rebuilds if the page hasn't actually changed
      if (_currentPage != newPage || _totalPages != newTotal) {
        setState(() {
          _currentPage = newPage!;
          _totalPages = newTotal;
        });
      }
    }
  }

  @override
  void dispose() {
    // 3. Always clean up listeners to prevent memory leaks
    _pdfController.removeListener(_updatePageInfo);
    // _pdfController.dispose();
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
      appBar: NotaAppBar(
        title: Text(
          displayTitle,
          style: textTheme.titleLarge?.copyWith(fontWeight: AppFonts.semibold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: colorScheme.onSurfaceVariant),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        // 4. Wrap in a Stack to float the counter over the document
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: PdfViewer.file(
                widget.note.filePath,
                controller: _pdfController, // Attach the controller here
                useProgressiveLoading: true,
                params: PdfViewerParams(
                  backgroundColor: dynamicBackgroundColor,
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 0.8,
                  maxScale: 8.0,
                  margin: 12,
                ),
              ),
            ),

            // 5. The Page Counter Overlay
            if (_totalPages > 0)
              Positioned(
                bottom: AppSpacing.lg,
                right: AppSpacing.lg,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    // Subtle, blurred background pill for readability
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.85,
                    ),
                    borderRadius: AppRadius.pillRadius,
                  ),
                  child: Text(
                    '$_currentPage / $_totalPages',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: AppFonts.medium,
                      letterSpacing: 0.5,
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
