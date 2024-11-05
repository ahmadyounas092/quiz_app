import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quiz_api_app/api/api_key.dart';
import 'package:quiz_api_app/components/options_container.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_api_app/widgets/categories_widget.dart';

class QuizContainerWidget extends StatefulWidget {
  const QuizContainerWidget({super.key});

  @override
  State<QuizContainerWidget> createState() => _QuizContainerWidgetState();
}

class _QuizContainerWidgetState extends State<QuizContainerWidget> {
  String? question;
  String? answer;
  String selectedCategory = "music"; // Default category
  List<String> options = [];
  final List<String> incorrectOptions = [];
  String? selectedOption;
  bool isAnswered = false;

  @override
  void initState() {
    super.initState();
    fetchQuizData(selectedCategory); // Fetch quiz data for the default category
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // Categories Widget - To select category
        CategoriesWidget(
          onCategorySelected: (category) {
            setState(() {
              selectedCategory = category; // Update the selected category
            });
            fetchQuizData(category); // Fetch new data for the selected category
          },
        ),
        const SizedBox(height: 40),
        options.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Container(
                width: width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white60.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        question ?? "Loading question....",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.deepPurple[800],
                          fontWeight: FontWeight.w500,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Display options
                    for (String option in options)
                      GestureDetector(
                        onTap: () {
                          if (!isAnswered) {
                            setState(() {
                              selectedOption = option;
                              isAnswered = true;
                            });

                            // Check if the selected option is correct
                            bool isCorrect = selectedOption == answer;
                            print(
                                'Selected Option: $selectedOption, Correct Answer: $answer'); // Debugging

                            // Delay for 5 seconds before fetching a new question
                            Future.delayed(const Duration(seconds: 5), () {
                              fetchQuizData(
                                  selectedCategory); // Fetch new question
                            });
                          }
                        },
                        child: OptionsContainer(
                          text: option.replaceAll(RegExp(r'[\[\]]'), ""),
                          borderColor: getBorderColor(option),
                        ),
                      ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ],
    );
  }

  // This method handles the border color change logic
  Color getBorderColor(String option) {
    print(
        'Option: $option, Selected Option: $selectedOption, Answer: $answer'); // Debugging
    if (!isAnswered) {
      return const Color.fromARGB(
          255, 137, 83, 231); // Default border color before answering
    }

    if (option == answer) {
      return Colors.green; // Highlight the correct answer in green
    } else if (option == selectedOption) {
      return Colors.red; // Highlight the selected answer in red (wrong answer)
    }

    return const Color.fromARGB(
        255, 137, 83, 231); // Default border color for other options
  }

  // This method fetches the quiz data based on category and updates the state
  Future<void> fetchQuizData(String category) async {
    final apiWithCategory =
        "$apiUrl$category"; // Use your category-specific URL
    final response = await http.get(
      Uri.parse(apiWithCategory),
      headers: {'X-Api-Key': apiKey},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      print(jsonData); // Log the response to check the structure

      if (jsonData.isNotEmpty) {
        Map<String, dynamic> quiz = jsonData[0]; // Get the first question
        question = quiz["question"] ?? "No question found"; // Get the question
        answer = quiz["answer"]; // Corrected this line to use "answer"
        print('Answer fetched: $answer'); // Log the correct answer
        incorrectOptions.clear(); // Clear previous incorrect options
        options.clear(); // Clear previous options

        // Add the incorrect answers if they exist
        if (quiz["incorrect_answers"] != null) {
          incorrectOptions.addAll(List<String>.from(quiz["incorrect_answers"]));
        }

        // Prepare the options: Add the correct answer
        if (answer != null) {
          options = [answer!]..addAll(incorrectOptions);
        }

        // Optionally, add random words to the options if there are fewer than 4
        await addRandomText();

        // Shuffle options after adding random words (ensure options are fully populated)
        options.shuffle(Random());

        // Ensure the UI is updated with the new question and options
        setState(() {
          isAnswered = false; // Reset for the next question
          selectedOption = null; // Reset selected option
        });
      }
    } else {
      // Handle error response
      setState(() {
        question = "Failed to load question.";
      });
    }
  }

  // Ensure options have at least 4 items, add random text if needed
  Future<void> addRandomText() async {
    // Add random words if there are fewer than 4 options
    while (options.length < 4) {
      final apiRandomWords = "$randomWord"; // Random word API URL
      final response = await http.get(
        Uri.parse(apiRandomWords),
        headers: {'X-Api-Key': apiKey}, // Use correct API key if needed
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> words = jsonDecode(response.body);
        String word = words['word'].toString();
        options.add(word);
      }

      // Ensure we don't add more than needed
      if (options.length >= 4) break;
    }

    // Trigger UI rebuild after all options are added
    setState(() {});
  }
}
