import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_crore_project/constant/color.dart';
import 'package:one_crore_project/util/launch_url.dart';
import 'package:one_crore_project/widgets/prefetch_image.dart';

class GithubEducationPackScreen extends StatefulWidget {
  const GithubEducationPackScreen({super.key});

  @override
  State<GithubEducationPackScreen> createState() =>
      _GithubEducationPackScreenState();
}

class _GithubEducationPackScreenState extends State<GithubEducationPackScreen> {
  String githubEducationPack =
      """<p><strong><span style="font-size: 18px;">What you&apos;ll get:</span></strong></p>
<p><strong>1. Free 60+ courses covering in-demand topics like Web Development, Python, Java, and Machine Learning for 6 months on Educative.</strong></p>
<p><strong>2. Build your online presence with a free .LIVE domain name, free privacy protection, and a free SSL certificate.</strong><br><br><strong><strong>3. 1 Year of free .me domain on NameCheap.</strong></strong><br><br><strong>4. One standard .TECH domain free for 1 year and 2 free email accounts with 100 MB free storage</strong><br><br><strong>5. 20,000 free emails and 100 free email validations each month for up to 12 months.</strong></p>
<p><strong>6. Access to the full coding interview prep course for 3 weeks.</strong></p>""";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Github Education Pack"),
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                onPressed: () {
                  LaunchUrl.launch(
                      "https://education.github.com/benefits?type=student");
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Claim Now"),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PrefetchImage(
                imageUrl:
                    "https://github.blog/wp-content/uploads/2019/08/FBLinkedIn_ALL-PARTNERS.png?fit=1200%2C630",
                height: 160,
                width: size.width,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: HtmlWidget(
                  githubEducationPack,
                  textStyle: GoogleFonts.robotoFlex(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
