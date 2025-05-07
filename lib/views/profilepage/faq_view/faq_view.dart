import 'package:dayush_clinic/views/common_widgets/common_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqView extends StatelessWidget {
  FaqView({super.key});

  final List<FaqItem> services = [
    FaqItem(
      title: "What is Dayush Clinics?",
      description:
          "Dayush Clinics is a telemedicine platform that connects you with experienced doctors of alternative medicine for virtual consultations. You can consult from the comfort of your home using your smartphone, tablet, or computer.",
    ),
    FaqItem(
      title: "How do I book an appointment/ Consult a Doctor?",
      description:
          "Simply download the Dayush Clinics app, register using your phone number or email, choose your preferred doctor or specialty, and select an available time slot to book your appointment. OR - If your required Doctor is free, you can directly connect through our VC facility with him/ her after payment.",
    ),
    FaqItem(
      title: "Can I get a prescription through Dayush Clinics?",
      description:
          "Yes! After your consultation, if required, our doctors will issue a valid digital prescription which you can use to purchase medicines or for further medical care. You can also download the previous prescriptions from 'Your Treatment History' tab anytime.",
    ),
    FaqItem(
      title: "What types of doctors are available on Dayush Clinics?",
      description:
          "We have experienced Doctors/ Practitioners in various alternative medicine fields like Ayurveda, Sidha, Naturopathy, Unani, Homeo and many more specialists available for online consultations.",
    ),
    FaqItem(
      title: "Is my information safe and private?",
      description:
          "Absolutely. Dayush Clinics adheres to strict confidentiality protocols and data security standards to protect your health information. Further, we don't keep any data related to Video Calling.",
    ),
    FaqItem(
      title: "Can I consult for emergencies through Dayush Clinics?",
      description:
          "Dayush Clinics is designed for non-emergency consultations. For medical emergencies, we advise you to visit the nearest hospital or call emergency services immediately.",
    ),
    FaqItem(
      title: "How much does a consultation cost?",
      description:
          "Consultation fees vary depending on the doctor and specialty. Fee details are clearly mentioned next to each doctor's profile before booking.",
    ),
    FaqItem(
      title: "What if I miss my appointment?",
      description:
          "If you miss your appointment, you can reschedule it through the app. Please note that rescheduling policies and charges, if any, are mentioned in the booking terms.",
    ),
    FaqItem(
      title: "Can I consult the same doctor again?",
      description:
          "Yes, you can choose to consult the same doctor for follow-ups or future appointments via the app.",
    ),
    FaqItem(
      title: "How do I make payments?",
      description:
          "Payments can be made securely through multiple options including credit/debit cards, UPI, net banking, and mobile wallets.",
    ),
    FaqItem(
      title: "Is Dayush Clinics available 24/7?",
      description:
          "You can book appointments 24/7, but doctor availability depends on their individual schedules. Some doctors also offer evening and weekend slots for your convenience.",
    ),
    FaqItem(
      title: "Can I get lab tests done through Dayush Clinics?",
      description:
          "No, we don't offer lab test booking services through our partnered diagnostic labs.",
    ),
    FaqItem(
      title:
          "What to do, if my Internet connection got lost in between the consultation or I am not able to finish the appointment due to some issues at your side?",
      description:
          "Don't worry. If the connection terminates in between the consultation and the Doctor agrees so, we will provide full refund to you. You can connect with any other doctor/ same doctor later, as per availability.",
    ),
    FaqItem(
      title: "How do I contact customer support?",
      description:
          "You can reach out to our support team via the ‘Help’ section in the app or email us at support@dayushclinics.com or dayushclinics@gmail.com for quick assistance.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonWidgets().commonappbar('FAQ'),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15).r,
        child: SingleChildScrollView(
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
                        '${index + 1}. ${services[index].title}',
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
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 10),
                          child: SelectableText.rich(
                            TextSpan(
                              children: _buildTextWithLinks(
                                  services[index].description),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
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
      ),
    );
  }

  List<TextSpan> _buildTextWithLinks(String text) {
    final RegExp emailRegex = RegExp(
      r"[\w\.-]+@[\w\.-]+\.\w+",
      caseSensitive: false,
    );
    final matches = emailRegex.allMatches(text);

    if (matches.isEmpty) {
      return [TextSpan(text: text)];
    }

    List<TextSpan> spans = [];
    int start = 0;

    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      final email = match.group(0);
      spans.add(
        TextSpan(
          text: email,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              _launchEmail(email!);
            },
        ),
      );
      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }

  void _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch email';
    }
  }
}

class FaqItem {
  final String title;
  final String description;

  FaqItem({required this.title, required this.description});
}
