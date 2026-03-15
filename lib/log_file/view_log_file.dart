import 'package:flutter/material.dart';
import 'package:scanner/log_file/log_file_functions.dart';
import 'package:scanner/theme/custom_text_widgets.dart';

class ViewLogFile extends StatelessWidget {
  const ViewLogFile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log File Data'),
        actions: [
          IconButton(onPressed: (){
            shareLogFile();
          }, icon: const Icon(Icons.share))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              FutureBuilder(
                  future: readLogFile(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData ||
                        snapshot.data == null ||
                        snapshot.data == '') {
                      return Container();
                    }
                    return getSubHeadingText(text: snapshot.data ?? '');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
