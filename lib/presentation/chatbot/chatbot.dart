import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _userInput =TextEditingController();

  static const apiKey = "AIzaSyACYak9XLrn0mtX_8bFEOnrBoX4jb6vlDw";

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async{
    final message = _userInput.text;

    setState(() {
      _messages.add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    final content = [Content.text(message)];
    final response = await model.generateContent(content);


    setState(() {
      _messages.add(Message(isUser: false, message: response.text?? "", date: DateTime.now()));
    });
    _userInput.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://scontent.fdel25-3.fna.fbcdn.net/v/t39.30808-6/291948191_1529975504120726_4026483689461381870_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_ohc=_ROUKV8O_egAb4jqmYd&_nc_ht=scontent.fdel25-3.fna&oh=00_AfDpqUkydGwws9BJzGZUlDyYu7ZRRQ5PQEAJn1HJovS9bA&oe=6633FC05'),
            fit: BoxFit.cover,
          ),
          color: Colors.lime, // Fallback color if the image is not loaded
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: ListView.builder(itemCount:_messages.length,itemBuilder: (context,index){
                  final message = _messages[index];
                  return Messages(isUser: message.isUser, message: message.message, date: DateFormat('HH:mm').format(message.date));
                })
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 15,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _userInput,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                            borderSide: BorderSide(color: Colors.black, width: 7.0),
                          ),
                          label: Text('Enter Your Message'),
                          labelStyle: TextStyle(color: Colors.black87)
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                      padding: EdgeInsets.all(12),
                      iconSize: 30,
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(CircleBorder())
                      ),
                      onPressed: (){
                        sendMessage();
                      },
                      icon: Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Message{
  final bool isUser;
  final String message;
  final DateTime date;

  Message({ required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {

  final bool isUser;
  final String message;
  final String date;

  const Messages(
      {
        key,
        required this.isUser,
        required this.message,
        required this.date
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
          left: isUser ? 100:10,
          right: isUser ? 10: 100
      ),
      decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey.shade400,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: isUser ? Radius.circular(10): Radius.zero,
              topRight: Radius.circular(10),
              bottomRight: isUser ? Radius.zero : Radius.circular(10)
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 16,color: isUser ? Colors.white: Colors.black),
          ),
          Text(
            date,
            style: TextStyle(fontSize: 10,color: isUser ? Colors.white: Colors.black,),
          )
        ],
      ),
    );
  }
}