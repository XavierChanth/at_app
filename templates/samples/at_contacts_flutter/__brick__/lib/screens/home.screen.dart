import 'package:at_client/at_client.dart';
import 'package:at_contacts_flutter/at_contacts_flutter.dart';
import '../services/client.sdk.services.dart';
import '../widgets/prompt.widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AtClient atClientInstance = AtClientManager.getInstance().atClient;
  ClientSdkService clientSdkService = ClientSdkService.getInstance();
  String? activeAtSign, pickedAtSign;
  @override
  void initState() {
    Future.microtask(() async {
      var currentAtSign = await clientSdkService.getAtSignAndInitializeContacts();
      setState(() {
        activeAtSign = currentAtSign;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    disposeContactsControllers();
    super.dispose();
  }

  String formatAtsign(String atsign) {
    if (atsign[0] == '@') {
      return atsign;
    } else {
      return '@' + atsign;
    }
  }

  Future<void> addContactDialog(BuildContext context) async {
    await Dialogs.customDialog(
      context,
      'Add contact?',
      'Enter the @sign to add as a contact',
      () async {
        if (pickedAtSign != null && pickedAtSign!.trim().isNotEmpty) {
          pickedAtSign = formatAtsign(pickedAtSign!);
          bool isContactAdded = await addContact(pickedAtSign!);
          if (isContactAdded) Navigator.pop(context);
        }
        pickedAtSign = '';
      },
      childContent: TextField(
        onChanged: (value) {
          setState(() {
            pickedAtSign = value;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: '@sign',
        ),
      ),
      buttonText: 'Add',
    );
  }

  Future<void> deleteContactDialog(BuildContext context) async {
    await Dialogs.customDialog(
      context,
      'Delete contact?',
      'Enter the @sign to delete as a contact',
      () async {
        if (pickedAtSign != null && pickedAtSign!.trim().isNotEmpty) {
          pickedAtSign = formatAtsign(pickedAtSign!);
          await deleteContact(pickedAtSign!);
        }

        pickedAtSign = '';
        Navigator.pop(context);
      },
      childContent: TextField(
        onChanged: (value) {
          setState(() {
            pickedAtSign = value;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: '@sign',
        ),
      ),
      buttonText: 'Delete',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Text(
                'Welcome $activeAtSign!',
                style: const TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () async => addContactDialog(context),
              child: const Text('Add contact'),
            ),
            ElevatedButton(
              onPressed: () async => deleteContactDialog(context),
              child: const Text('Delete contact'),
            ),
            ElevatedButton(
              onPressed: () {
                // any logic
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const ContactsScreen(),
                ));
              },
              child: const Text('Show contacts'),
            ),
            ElevatedButton(
              onPressed: () {
                // any logic
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const BlockedScreen(),
                ));
              },
              child: const Text('Show blocked contacts'),
            ),
          ],
        ),
      ),
    );
  }
}
