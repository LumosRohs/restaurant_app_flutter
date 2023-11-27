import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/add_review_provider.dart';

class AddReviewPage extends StatefulWidget {
  static const routeName = '/add_review';

  final String restaurantId;

  const AddReviewPage({super.key, required this.restaurantId});

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  PlatformScaffold _buildPage(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Form Add Review'),
        backgroundColor: const Color(0xFFDDA15A),
      ),
      body: _buildBody(context),
    );
  }

  SingleChildScrollView _buildBody(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            Text(
              'Review',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Review',
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  reviewProvider
                      .addCustomerReview(widget.restaurantId,
                          _nameController.text, _reviewController.text)
                      .then((response) {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Add Review'),
                        content: Text(response),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFFDDA15A),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), // Set border radius to 30
                    ),
                  ),
                ),
                child: Text(
                  'Submit Review',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
