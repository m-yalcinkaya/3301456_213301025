import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:littlefont_app/screens/category_page.dart';
import '../repository/category_repository.dart';
import 'package:littlefont_app/modals/category.dart';


class AddCategory extends ConsumerStatefulWidget {
  const AddCategory({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends ConsumerState<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final categoryRepo = ref.read(categoryProvider);

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Category'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(50),
                child: TextFormField(
                  maxLength: 50,
                  controller: _controller,
                  validator: (value) {
                    return null;
                  },
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                  decoration:
                      const InputDecoration(hintText: 'Create a new category'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final isSuitable = _formKey.currentState?.validate();
                    if (isSuitable == true) {
                      final category =
                      NoteCategory(categoryName: _controller.text);
                      categoryRepo.addCategory(category);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CategoryPage(),
                          ));
                    }
                  });
                },
                child: const Text('Create'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
