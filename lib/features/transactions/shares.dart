import 'package:flutter/material.dart';

class SharesScreen extends StatelessWidget {
  final List<Map<String, String>> members = [
    {'name': 'Magugu Elvis', 'ward': 'Mvunguti Ward', 'shares': 'K200,000'},
    {'name': 'Magugu Elvis', 'ward': 'Mvunguti Ward', 'shares': 'K200,000'},
    {'name': 'Magugu Elvis', 'ward': 'Mvunguti Ward', 'shares': 'K200,000'},
    {'name': 'Magugu Elvis', 'ward': 'Mvunguti Ward', 'shares': 'K200,000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Shares',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: members.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.person, size: 40),
                      title: Text(members[index]['name']!),
                      subtitle: Text(members[index]['ward']!),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            members[index]['shares']!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Shares'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add shares action
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}