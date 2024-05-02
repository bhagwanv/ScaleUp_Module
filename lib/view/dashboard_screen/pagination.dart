import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaginationScreen extends StatefulWidget {
  const PaginationScreen({super.key});
  @override
  _PaginationScreenState createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  ScrollController _scrollController = ScrollController();
  List<String> items = [];
  int currentPage = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initial data fetch
    fetchData();
    // Listener to check if the user has scrolled to the bottom
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // Load more data if not already loading
        if (!isLoading) {
          currentPage++;
          fetchData();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Fetch data from the source
  void fetchData() {
    // Simulating fetching data from a source
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      for (int i = 0; i < 20; i++) {
        items.add('Item ${items.length + 1}');
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagination Example'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length + 1, // +1 for the loading indicator
        itemBuilder: (context, index) {
          if (index < items.length) {
            return ListTile(
              title: Text(items[index]),
            );
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: CircularProgressIndicator(), // Loading indicator
              ),
            );
          }
        },
      ),
    );
  }
}