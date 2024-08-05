import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/articles/articles_controller.dart';
import '../utility/snackybar.dart';
import '../utility/text_validation.dart';

class CreateArticleScreen extends ConsumerStatefulWidget {
  const CreateArticleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateArticleScreenState();
}

class _CreateArticleScreenState extends ConsumerState<CreateArticleScreen> {
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _urlValid = false;

  bool _showAdditionalContent = false;

  void _postArticle() {
    if (!validTextValue(_titleController)) {
      showSnackBar(context, 'title requred');
    } else if (!_urlValid && validTextValue(_urlController)) {
      showSnackBar(context, 'invalid link');
    } else if (_urlValid) {
      ref.read(articlesControllerProvider.notifier).postArticle(
          title: validTextValueReturner(_titleController),
          context: context,
          url: validTextValueReturner(_urlController),
          content: !_showAdditionalContent
              ? null
              : validTextValue(_contentController)
                  ? validTextValueReturner(_contentController)
                  : null);
    } else if (!validTextValue(_contentController)) {
      showSnackBar(context, 'a link or content is required');
    } else {
      ref
          .read(articlesControllerProvider.notifier)
          .postArticle(title: validTextValueReturner(_titleController), context: context, content: validTextValueReturner(_contentController));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(articlesControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('post screen'),
        actions: [
          isLoading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _postArticle, child: const Text('submit')),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("add a title"),
            TextField(
              controller: _titleController,
              maxLength: 60,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("paste a link"),
            TextField(
              controller: _urlController,
              onChanged: (value) {
                if (Uri.parse(value).isAbsolute) {
                  setState(() {
                    _urlValid = true;
                  });
                } else {
                  setState(() {
                    _urlValid = false;
                  });
                }
              },
            ),
            Row(
              children: [
                Text(_urlValid ? "add text" : "text only"),
                Checkbox(
                  value: _showAdditionalContent,
                  onChanged: (value) {
                    setState(() {
                      _showAdditionalContent = value!;
                    });
                  },
                ),
              ],
            ),
            if (_showAdditionalContent)
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                  controller: _contentController,
                  maxLines: 500,
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _urlController.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }
}
