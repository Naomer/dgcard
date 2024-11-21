import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> fetchSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'http://alsaifgallery.onrender.com/api/v1/product/getAllProducts?q=$query'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _searchResults = jsonData['data']['products'] ?? [];
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching search results: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Container(
            height: 40.0, // Reduced height of the search box
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
                fetchSearchResults(query);
              },
              decoration: InputDecoration(
                hintText: 'Find it here...',
                hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 6.0, // Further reduced vertical padding
                  horizontal: 16.0,
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.grey[600]),
                  onPressed: () {
                    fetchSearchResults(_searchQuery);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Horizontal divider (line)
          Divider(
            color: Colors.grey, // Line color
            thickness: 1, // Line thickness
            indent: 0, // Indentation from the left side
            endIndent: 0, // Indentation from the right side
          ),
          // Search results or loading indicator
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : _searchResults.isEmpty
                    ? Center(
                        child: Text(
                          _searchQuery.isEmpty
                              ? 'Search for products...'
                              : 'No results found for "$_searchQuery".',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final product = _searchResults[index];
                          return ListTile(
                            leading: product['imageIds'] != null &&
                                    product['imageIds'].isNotEmpty
                                ? Image.network(
                                    product['imageIds'][0],
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.image, size: 50),
                            title: Text(product['name'] ?? 'No Name'),
                            subtitle:
                                Text('SAR ${product['price'] ?? 'No Price'}'),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
