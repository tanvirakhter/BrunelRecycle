import 'package:flutter/material.dart';

class FaqsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Frequently Asked Questions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'General FAQs',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Here are some frequently asked questions about recycling that may help you:',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 16.0),
            FaqCard(
              question: 'What can I recycle?',
              answer:
                  'Most recycling programs accept paper, plastic, glass, and metal. Check with your local recycling program for specific guidelines.',
            ),
            FaqCard(
              question: 'How do I prepare my recyclables for pickup?',
              answer:
                  'Rinse out containers and remove any caps or lids. Flatten cardboard boxes and stack them neatly. Check with your local recycling program for specific instructions.',
            ),
            FaqCard(
              question: 'Can I recycle electronics?',
              answer: 'Yes, many electronics can be recycled. Check with your local recycling program for specific guidelines.',
            ),
            FaqCard(
              question: 'What happens to my recyclables after they are picked up?',
              answer:
                  'Recyclables are sorted, cleaned, and processed into new products. Some materials, such as paper and cardboard, are turned into new paper products. Others, such as plastic and metal, are melted down and used to make new products.',
            ),
            FaqCard(
              question: 'Why is recycling important?',
              answer:
                  'Recycling conserves resources, reduces waste, and helps protect the environment. It also saves energy and reduces greenhouse gas emissions.',
            ),
          ],
        ),
      ),
    );
  }
}

class FaqCard extends StatefulWidget {
  final String question;
  final String answer;

  const FaqCard({Key? key, required this.question, required this.answer}) : super(key: key);

  @override
  _FaqCardState createState() => _FaqCardState();
}

class _FaqCardState extends State<FaqCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              widget.question,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: _isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            height: _isExpanded ? null : 0,
            child: SingleChildScrollView(
              child: Text(
                widget.answer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
