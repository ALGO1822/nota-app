import 'package:flutter/material.dart';
import 'package:nota_app/ui/core/constants/app_constants.dart';
import 'package:nota_app/ui/library/widgets/nota_card.dart';

class NotaList extends StatelessWidget {
  final List listItems;
  const NotaList({super.key, required this.listItems});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          return NotaCard(note: listItems[index]);
        },
      ),
    );
  }
}