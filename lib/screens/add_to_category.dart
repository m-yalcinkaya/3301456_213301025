import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:littlefont_app/repository/category_repository.dart';
import 'package:littlefont_app/repository/notes_repository.dart';
import 'package:littlefont_app/screens/view_note_page.dart';
import 'package:littlefont_app/utilities/database_helper.dart';


class AddToCategory extends ConsumerWidget {
  final int indexCategory;

  const AddToCategory({
    Key? key,
    required this.indexCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('My Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: buildGridView(ref: ref),
      ),
    );
  }

  FutureBuilder buildGridView({required ref}) {
    final noteRepo = ref.watch(notesProvider);
    final categoryRepo = ref.watch(categoryProvider);
    return FutureBuilder(
      future: DatabaseHelper.instance.getPendingCategoryNotes(categoryRepo.category[indexCategory].id!),
      builder: (context, snapshot) {
        if(snapshot.hasError){
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('An error occured loading notes in the category'),
            actions: [
              TextButton(onPressed: Navigator.of(context).pop,
                  child: const Text('OK'))
            ],
          );
        }else if(snapshot.hasData){
          ref.read(notesProvider).notes = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: noteRepo.notes.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.blue.shade200,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ShowNote(
                        index: index,
                      ),
                    ));
                  },
                  child:
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () async {
                            final value = noteRepo.notes[index];
                            ref.read(categoryProvider).insertToCategory(value, categoryRepo.category[indexCategory]);
                          },
                          icon: const Icon(Icons.add_box_rounded),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        noteRepo.notes[index].title,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            noteRepo.notes[index].content,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                  ]),
                ),
              );
            },
          );
        }else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
