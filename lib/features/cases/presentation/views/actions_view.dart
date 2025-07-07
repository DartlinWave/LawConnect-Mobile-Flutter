import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawconnect_mobile_flutter/core/theme/color_palette.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/case.dart';
import 'package:lawconnect_mobile_flutter/features/cases/domain/entities/comment.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_bloc.dart';
import 'package:lawconnect_mobile_flutter/features/cases/presentation/blocs/case_details_event.dart';
import 'package:lawconnect_mobile_flutter/shared/custom_widgets/basic_button.dart';

class ActionsView extends StatefulWidget {
  const ActionsView({
    super.key,
    required this.caseEntity,
    required this.initialComment,
    // required this.onFinishCase,
  });

  final Case caseEntity;
  final Comment? initialComment;
  // final Function(String comment, double rating) onFinishCase; (in case rating is added)

  @override
  State<ActionsView> createState() => _ActionsViewState();
}

class _ActionsViewState extends State<ActionsView> {
  late TextEditingController _commentController;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(
      text: widget.initialComment?.comment ?? '',
      );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  int _countCommentWords(String content) {
    return content.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  void _handleFinishCase() {
    final commentText = _commentController.text.trim();
    final wordCount = _countCommentWords(commentText);

    if (wordCount < 10 || wordCount > 200) {
      setState(() => _showError = true);
      
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is SuccessAuthState) {
      final authorId = authState.user.id;

      context.read<CaseDetailsBloc>().add(
        FinishCaseEvent(
          caseId: widget.caseEntity.id,
          authorId: authorId,
          comment: commentText,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isClosed = widget.caseEntity.status == CaseStatus.CLOSED;

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

          SizedBox(height: 12),

          // to make comment (validates if it's closed or not too)
          TextField(
            controller: _commentController,
            maxLines: 3,
            cursorColor: ColorPalette.primaryColor,
            enabled: !isClosed,
            decoration: InputDecoration(
              labelText: "Leave a comment about the lawyer",
              labelStyle: TextStyle(
                color: isClosed ? ColorPalette.greyColor : ColorPalette.blackColor,
              ),
              hintText: isClosed
                  ? "Comment is read-only after closing the case"
                  : "Leave a comment before closing the case.",
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorPalette.blackColor,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorPalette.primaryColor,
                  width: 1,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              filled: true,
              fillColor: ColorPalette.whiteColor,
              errorText: _showError
                  ? "Comment must be between 10 and 200 words."
                  : null,
            ),
          ),

          SizedBox(height: 12),

          if (!isClosed)
            Center(
              child: BasicButton(
                text: "Finish Case",
                onPressed: _handleFinishCase,
                width: 184,
                height: 52,
                backgroundColor: ColorPalette.primaryColor,
                )
            ),
        ],
      ),
    );
  }
}

