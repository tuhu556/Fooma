import 'package:flutter/material.dart';
import 'package:foodhub/features/question/data/question.dart';

import '../../../constants/color.dart';
import '../models/question.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FoodHubColors.colorF0F5F9,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: FoodHubColors.colorF0F5F9,
        leading: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios,
              color: FoodHubColors.color0B0C0C,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Những câu hỏi thường gặp",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: FoodHubColors.color0B0C0C),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionPanelList.radio(
                children: Data.questions.map<ExpansionPanelRadio>(
                  (Question Question) {
                    return ExpansionPanelRadio(
                      value: Question.id!,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            Question.headerValue!,
                            style: TextStyle(
                              color: FoodHubColors.color0B0C0C,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      body: Column(
                        children: [
                          Divider(
                            height: 2,
                            color: FoodHubColors.colorF1F1F1,
                          ),
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15)
                                    .add(const EdgeInsets.only(
                              bottom: 10,
                            )),
                            title: Text(Question.expandedValue!),
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
