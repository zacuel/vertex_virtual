import 'package:flutter/material.dart';

class AddCommentWidget extends StatelessWidget {
  final TextEditingController commentFieldController;
  final Function changeComment;
  final Color color;
  const AddCommentWidget({
    Key? key,
    required this.commentFieldController,
    required this.changeComment,
    this.color = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(.2),
        borderRadius: const BorderRadius.vertical(
          top: Radius.elliptical(150, 70),
        ),
      ),
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentFieldController,
              maxLength: 140,
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(onPressed: () => changeComment(), icon: const Icon(Icons.add_circle_outlined)),
        ],
      ),
    );
  }
}
