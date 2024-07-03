import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dart_pusher_channels/dart_pusher_channels.dart';
import 'dart:async';

const String serverUrl = '192.168.1.156';
const int serverPort = 8000;
const int wsPort = 8080;
const String authKey = "Bearer 1|GLluSjMtifitjzTBm4pXMThcCukWzTTZEue0dpyyb0f5ee2b";

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  List<String> texts = [];
  TextEditingController textController = TextEditingController();
  late PrivateChannel myChannel;
  late dynamic client;

  void addText(text) {
    setState(() {
      texts.add(text);
    });
  }

  void sendMessage() {
    String text = textController.text;
    if (text.isNotEmpty) {
      myChannel.trigger(eventName: 'chat', data: {'message': text});
      addText(text);
      textController.clear();
    }
  }

  void connectSocket() {
    PusherChannelsPackageLogger.enableLogs();
    const clusterOptions = PusherChannelsOptions.fromHost(
      scheme: 'ws',
      key: 'ifaozfygghqqxvcutcrx',
      host: serverUrl,
      port: wsPort,
      shouldSupplyMetadataQueries: true,
      metadata: PusherChannelsOptionsMetadata.byDefault()
    );
    client = PusherChannelsClient.websocket(
      options: clusterOptions,
      connectionErrorHandler: (exception, trace, refresh) async {
        print('Connection error: $exception trace $trace');
        refresh();
      },
    );
    myChannel = client.privateChannel(
      'private-all-chat',
      authorizationDelegate: EndpointAuthorizableChannelTokenAuthorizationDelegate.forPrivateChannel(
        authorizationEndpoint: Uri.parse("http://$serverUrl:$serverPort/api/broadcasting/auth"),
        onAuthFailed: (error, _) {
          print('onAuthFailed $error');
        },
        headers: const {
          "Authorization": authKey
        },
      ),
    );

    myChannel.bind('chat').listen((event) {
      final data = jsonDecode(event.data);
      addText(data['message']);
    });

    final allChannels = <Channel>[
      myChannel,
    ];
    client.onConnectionEstablished.listen((_) {
      for (final channel in allChannels) {
        channel.subscribeIfNotUnsubscribed();
      }
    });
    unawaited(client.connect());
  }


  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text('Chat'),
                Expanded(
                  child: ListView.builder(
                    itemCount: texts.length,
                    itemBuilder: (context, index) {
                      return Text(texts[index]);
                    },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a message',
                        ),
                        controller: textController,
                      ),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        sendMessage();
                      },
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
