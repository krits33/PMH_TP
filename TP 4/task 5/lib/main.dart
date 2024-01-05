import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  await configure(); // Initialize Firebase
  runApp(const MyApp());
}

Future<void> configure() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Handle Firebase initialization error
    print("Firebase initialization error: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Firebase Flutter',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // text fields' controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final CollectionReference _notes =
      FirebaseFirestore.instance.collection('notes');

  // Function to create or update a note
  // This function is triggered when the floating button or one of the edit buttons is pressed
  // Adding a note if no documentSnapshot is passed
  // If documentSnapshot != null then update an existing note
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    // Determine whether it's a create or update action
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      // Pre-fill text fields with existing data for update
      _titleController.text = documentSnapshot['title'];
      _descriptionController.text = documentSnapshot['description'].toString();
    }

    // Show a modal bottom sheet for adding/updating a note
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                // prevent the soft keyboard from covering text fields
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text fields for title and description
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "Enter the title",
                    labelText: 'Title',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Enter the description",
                    labelText: 'Description',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Buttons for Create/Update and Close
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      child: Text(action == 'create' ? 'Create' : 'Update'),
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(double.infinity, 0)),
                      ).merge(
                        ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                      ),
                      onPressed: () async {
                        final String title = _titleController.text;
                        final String description = _descriptionController.text;
                        if (action == 'create') {
                          // Persist a new note to Firestore
                          await _notes.add({
                            "title": title,
                            "description": description
                          }).then((value) =>
                              // Show a snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'You have successfully added a note.'))));
                        }

                        if (action == 'update') {
                          // Update the note
                          await _notes.doc(documentSnapshot!.id).update({
                            "title": title,
                            "description": description
                          }).then((value) =>
                              // Show a snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'You have successfully updated a note.'))));
                        }

                        // Clear the text fields
                        _titleController.text = '';
                        _descriptionController.text = '';

                        // Hide the bottom sheet
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      child: const Text('Close'),
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(double.infinity, 0)),
                      ).merge(
                        ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 235, 108, 108),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.all(20),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  // Function to delete a note
  Future<void> _deletenote(String noteId) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Row(children: [Text('Delete permanently!')]),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure, you want to delete this note?'),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () async {
                  await _notes.doc(noteId).delete();
                  // Show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('You have successfully deleted a note.')));
                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('No'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Flutter'),
      ),
      // Using StreamBuilder to display all notes from Firestore in real-time
      body: StreamBuilder(
        stream: _notes.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(documentSnapshot['title']),
                    subtitle: Text(documentSnapshot['description'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single note
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single note
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deletenote(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new note
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
