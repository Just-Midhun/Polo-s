import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class DriverVerification extends StatefulWidget {
  const DriverVerification({Key? key}) : super(key: key);

  @override
  State<DriverVerification> createState() => _DriverVerificationState();
}

class _DriverVerificationState extends State<DriverVerification> {

  List<String> documents = [];

  void _uploadDocument(String documentPath) {
    setState(() {
      documents.add(documentPath);
    });
  }

  void _removeDocument(String document) {
    setState(() {
      documents.remove(document);
    });
  }

  Future<void> _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.isNotEmpty) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        _uploadDocument(filePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Verification'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding:EdgeInsets.symmetric(horizontal: 32.0),
            child:Text(
            'Mobile Number:',
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter your mobile number',
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding:EdgeInsets.symmetric(horizontal: 32.0),
            child:Text(
            'Region of Licensing:',
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),

            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter your region of licensing',
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child:Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child:
                  ElevatedButton(
                    onPressed: () {
                      // Perform registration logic here
                    },
                    child: const Text('Register'),
                  ),
                ),

                const SizedBox(height: 24),
                const Padding(
                    padding: EdgeInsets.all(4.0),
                    child:

                  Text(
                    'Upload Documents',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),

                const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _openFileExplorer,
                    child: const Text('Add Document'),
                  ),


                const SizedBox(height: 24),
                const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'Uploaded Documents:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                ),

                const SizedBox(height: 8),
                if (documents.isEmpty)
                  const Text('No documents uploaded yet.')
                else
                  Column(
                    children: documents
                        .map((document) => ListTile(
                      title: Text(document),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _removeDocument(document);
                        },
                      ),
                    ))
                        .toList(),
                  ),

                const SizedBox(height: 24),
                const Text(
                  'Documents needed:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('1) Driver\'s license'),
                const Text('2) Car registration documents'),
                const Text('3) Car pollution certificate'),
        ],
      ),
    );
  }
}



