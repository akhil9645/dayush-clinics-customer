import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqView extends StatelessWidget {
  FaqView({super.key});

  final List<FaqItem> services = [
    FaqItem(
      title: "What is a second opinion",
      description:
          "A second opinion is an additional medical evaluation from a different doctor to confirm or provide another perspective on your diagnosis or treatment plan.",
    ),
    FaqItem(
      title: "Why should I get a second opinion?",
      description:
          "Obtaining a second opinion can help ensure you have the most accurate diagnosis and best treatment options. It can provide peace of mind, especially for complex, risky, or costly procedures.",
    ),
    FaqItem(
      title: "How does the second opinion process work?",
      description:
          "The process begins by submitting your medical records, which are then reviewed by a specialist. After the evaluation, you receive a detailed report, often through a virtual or in-person consultation.",
    ),
    FaqItem(
      title: "Is my medical information kept confidential?",
      description:
          "Yes, all your medical information is handled with strict confidentiality, using secure systems to ensure privacy and compliance with healthcare regulations",
    ),
    FaqItem(
      title: "How long does it take to get a second opinion?",
      description:
          "The time varies, but generally, you can expect to receive a second opinion within a few days to a week, depending on the complexity of your case and the specialist’s availability.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar('FAQ'),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15).r,
        child: Column(
          children: [
            ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Text(
                      services[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    tilePadding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    trailing: Icon(Icons.keyboard_arrow_down_rounded),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          services[index].description,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FaqItem {
  final String title;
  final String description;

  FaqItem({required this.title, required this.description});
}
