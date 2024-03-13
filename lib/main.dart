import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Folder> folders = [];
  bool isSnackBarVisible = false;

  void addFolder(String name) {
    setState(() {
      folders.add(Folder(name: name));
    });
  }

  void toggleSnackBarVisibility(bool visibility) {
    setState(() {
      isSnackBarVisible = visibility;
    });
  }

  void _showCreateFolderDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String folderName = '';
      return SizedBox(
        child: AlertDialog(
          backgroundColor: const Color(0xFF414141), // Set background color to #414141
          title: const Text(
            'Create Folder',
            style: TextStyle(
              color: Colors.white, // Set text color to white
              fontSize: 18,
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.topLeft, 
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            folderName = value;
                          });
                        },
                        maxLength: 21, // Set maximum length to 21 characters
                        decoration: InputDecoration(
                          hintText: 'Enter folder name',
                          hintStyle: const TextStyle(
                            color: Colors.white70, // Set hint text color to a lighter shade of white
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF20EFC0), // Set border color to #20EFC0
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF20EFC0), // Set border color to #20EFC0 when focused
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF20EFC0), // Set border color to #20EFC0 when enabled
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          errorText: folderName.isEmpty ? 'Please enter a folder name' : null, // Show error if folderName is empty
                        ),
                      ),
                      Positioned(
                        right: 8, // Adjust the left position of the character count
                        bottom: 27, // Adjust the bottom position of the character count
                        child: Text(
                          '${folderName.length}/21', // Display character count
                          style: const TextStyle(
                            color: Color(0xFFCCCCCC), // Set text color to light gray
                            fontSize: 12, // Set font size to 12
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8), // Add spacing between TextField and Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (folderName.isEmpty) {
                            return; // Don't close the dialog if folderName is empty
                          }
                          addFolder(folderName);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF20EFC0), // Set button background color to #20EFC0
                        ),
                        child: const Text(
                          'Ok',
                          style: TextStyle(
                            color: Colors.white, // Set text color to white
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );

}


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isSnackBarVisible) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          toggleSnackBarVisibility(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'All Decks',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color(0xFF121212),
        ),
        backgroundColor: const Color(0xFF121212),
        body: SingleChildScrollView(
          child: Wrap(
            direction: Axis.horizontal,
            children: folders.map((folder) => FolderItem(folder: folder)).toList(),
          ),
        ),
        floatingActionButton: !isSnackBarVisible
            ? FloatingActionButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF414141),
                      content: FolderOptions(
                        onManual: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          toggleSnackBarVisibility(false);
                          _showCreateFolderDialog(context);
                        },
                        onAI: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          toggleSnackBarVisibility(false);
                          // Handle AI folder creation here
                        },
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      duration: const Duration(days: 365),
                    ),
                  );
                  toggleSnackBarVisibility(true);
                },
                backgroundColor: const Color(0xFF20EFC0),
                child: const Icon(Icons.add),
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      ),
    );
  }
}

class FolderOptions extends StatelessWidget {
  final VoidCallback onManual;
  final VoidCallback onAI;

  const FolderOptions({super.key, required this.onManual, required this.onAI});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Column(
              children: [
                Text(
                  'Create Deck',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: onManual,
          icon: const Icon(
            Icons.person,
            color: Color(0xFF20EFC0),
          ),
          label: const Text(
            'Create manually',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: onAI,
          icon: const Icon(
            Icons.computer,
            color: Color(0xFF20EFC0),
          ),
          label: const Text(
            'Create with AI',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}

class Folder {
  final String name;

  Folder({required this.name});
}

class FolderItem extends StatelessWidget {
  final Folder folder;

  const FolderItem({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    double iconSize = MediaQuery.of(context).size.width / 4;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FolderPage(folder: folder),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 32,
          vertical: MediaQuery.of(context).size.width / 64,
        ),
        width: iconSize * 1.7,
        height: iconSize * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          border: Border.all(
            color: Colors.white,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.layers,
                size: iconSize * 0.4,
                color: const Color(0xFF20EFC0),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Align(
                  alignment: const Alignment(-1.2, -0.5),
                  child: Text(
                    folder.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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

class FolderPage extends StatelessWidget {
  final Folder folder;

  const FolderPage({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(folder.name),
      ),
      body: Center(
        child: Text("Content of ${folder.name}"),
      ),
    );
  }
}
