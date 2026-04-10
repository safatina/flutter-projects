import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/add_edit_note_page.dart';
import 'package:note_app/widgets/note_card_widgets.dart';
import 'package:note_app/pages/note_detail_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});
  
  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> notes;
  late List<Note> filteredNotes;
  var isLoading = false;
  String searchQuery = '';
  SortOption currentSort = SortOption.newest;
  
  final TextEditingController searchController = TextEditingController();

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    notes = await NoteDatabase.instance.getSortedNotes(currentSort);
    filterNotes();
    setState(() {
      isLoading = false;
    });
  }

  void filterNotes() {
    if (searchQuery.isEmpty) {
      filteredNotes = List.from(notes);
    } else {
      filteredNotes = notes.where((note) =>
        note.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
        note.description.toLowerCase().contains(searchQuery.toLowerCase())
      ).toList();
    }
    setState(() {});
  }
  
  Future changeSort(SortOption newSort) async {
    setState(() {
      currentSort = newSort;
      isLoading = true;
    });
    notes = await NoteDatabase.instance.getSortedNotes(currentSort);
    filterNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshNotes();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text;
        filterNotes();
      });
    });
  }
  
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: false,
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort Notes',
            onSelected: (value) {
              changeSort(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.newest,
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 20),
                    SizedBox(width: 8),
                    Text('Newest First'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.oldest,
                child: Row(
                  children: [
                    Icon(Icons.history, size: 20),
                    SizedBox(width: 8),
                    Text('Oldest First'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.titleAsc,
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, size: 20),
                    SizedBox(width: 8),
                    Text('Title A-Z'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.titleDesc,
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha, size: 20),
                    SizedBox(width: 8),
                    Text('Title Z-A'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: SortOption.important,
                child: Row(
                  children: [
                    Icon(Icons.star, size: 20),
                    SizedBox(width: 8),
                    Text('Most Important'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : filteredNotes.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        searchQuery.isEmpty ? Icons.note_add : Icons.search_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        searchQuery.isEmpty 
                            ? "No notes yet" 
                            : "No notes found",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (searchQuery.isEmpty)
                        ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddEditNotePage(),
                              ),
                            );
                            refreshNotes();
                          },
                          child: const Text('Create First Note'),
                        ),
                    ],
                  ),
                )
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  itemCount: filteredNotes.length,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NoteDetailPage(id: note.id!),
                          ),
                        );
                        refreshNotes();
                      },
                      child: NoteCardWidgets(note: note, index: index),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditNotePage()),
          );
          refreshNotes();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}