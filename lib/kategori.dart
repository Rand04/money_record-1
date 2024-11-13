import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/homepage.dart';

class Kategori extends StatefulWidget {
  const Kategori({super.key});

  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _showAddCategoryDialog() {
    String selectedCategory = "Pemasukan";
    String categoryName = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Tambah Kategori'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration:
                        const InputDecoration(labelText: 'Nama Kategori'),
                    onChanged: (value) {
                      categoryName = value;
                    },
                  ),
                  DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedCategory = newValue!;
                      });
                    },
                    items: <String>['Pemasukan', 'Pengeluaran']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () async {
                    if (categoryName.isNotEmpty) {
                      await _addCategoryToFirebase(
                          selectedCategory, categoryName);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Selesai'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _addCategoryToFirebase(
      String categoryType, String categoryName) async {
    String collectionName =
        categoryType == 'Pemasukan' ? 'Pemasukan' : 'Pengeluaran';
    try {
      await FirebaseFirestore.instance.collection(collectionName).add({
        'name': categoryName,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding category: $e");
    }
  }

  void _deleteCategory(String docId, String collection) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hapus Kategori'),
          content: Text('Apakah Anda yakin ingin menghapus kategori ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm) {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(docId)
          .delete();
    }
  }

  void _editCategory(
      String docId, String collection, String currentName) async {
    TextEditingController _controller =
        TextEditingController(text: currentName);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Kategori'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Nama Kategori Baru'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                String newName = _controller.text;
                if (newName.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection(collection)
                      .doc(docId)
                      .update({
                    'name': newName,
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
          child: AppBar(
            backgroundColor: const Color(0xFF4CA0D1),
            centerTitle: true, // Pastikan title berada di tengah
            titleSpacing: 0, // Atur jarak judul dengan leading
            leadingWidth: 70, // Lebarkan leading untuk mengatur posisi
            title: const Padding(
              padding: EdgeInsets.only(top: 28), // Geser judul ke bawah
              child: Text(
                'Kategori',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25, // Atur ukuran teks
                ),
              ),
            ),
            leading: Padding(
              padding: const EdgeInsets.only(top: 25.0), // Geser ikon ke bawah
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 16.0, top: 25.0), // Geser ikon tambah ke bawah
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: _showAddCategoryDialog,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE3ECF7),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          PemasukanPage(
            onDelete: _deleteCategory,
            onEdit: _editCategory,
          ),
          PengeluaranPage(
            onDelete: _deleteCategory,
            onEdit: _editCategory,
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 65.0,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 9.0,
            color: const Color(0xFF4CA0D1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  onPressed: () => _onItemTapped(0),
                  child: Text(
                    'Pemasukan',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _selectedIndex == 0 ? Colors.white : Colors.white70,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _onItemTapped(1),
                  child: Text(
                    'Pengeluaran',
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          _selectedIndex == 1 ? Colors.white : Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PemasukanPage extends StatelessWidget {
  final Function(String, String) onDelete;
  final Function(String, String, String) onEdit;

  const PemasukanPage({required this.onDelete, required this.onEdit, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Pemasukan').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final incomeList = snapshot.data!.docs;

        return ListView.builder(
          itemCount: incomeList.length,
          itemBuilder: (context, index) {
            final doc = incomeList[index];
            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(doc['name']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => onEdit(doc.id, 'Pemasukan', doc['name']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete(doc.id, 'Pemasukan'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class PengeluaranPage extends StatelessWidget {
  final Function(String, String) onDelete;
  final Function(String, String, String) onEdit;

  const PengeluaranPage(
      {required this.onDelete, required this.onEdit, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Pengeluaran').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final expenseList = snapshot.data!.docs;

        return ListView.builder(
          itemCount: expenseList.length,
          itemBuilder: (context, index) {
            final doc = expenseList[index];
            return Card(
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListTile(
                title: Text(doc['name']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () =>
                          onEdit(doc.id, 'Pengeluaran', doc['name']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete(doc.id, 'Pengeluaran'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
