import 'package:flutter/material.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';

class ActionsView extends StatefulWidget {
  const ActionsView({super.key, required this.caseEntity});

  final Case caseEntity;

  @override
  State<ActionsView> createState() => _ActionsViewState();
}

class _ActionsViewState extends State<ActionsView> {
  late bool _isClosed;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(text: widget.caseEntity.comment);
    _isClosed = widget.caseEntity.status == "CLOSED_STATUS";
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Actions",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: ColorPalette.blackColor,
            ),
          ),
          SizedBox(height: 6),

          // to make comment (validates if it's closed or not too)
          TextField(
            controller: _commentController,
            maxLines: 5,
            enabled: !_isClosed,
            decoration: InputDecoration(
              labelText: "Comment",
              hintText: _isClosed
                  ? "Comment is read-only after closing the case"
                  : "Leave a comment before closing the case.",
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorPalette.blackColor,
                  width: 1,
                ),
              ),
              filled: true,
              fillColor: ColorPalette.whiteColor,
            ),
          ),

        ],
      ),
    );
  }
}
