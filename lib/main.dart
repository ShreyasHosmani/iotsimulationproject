import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/src/typed_buffer.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

Timer? timer;
final client = MqttServerClient('mqtt.thingspeak.com', '8083');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IOT Simulation Project - Assignment 3',
      home: Scaffold(
        body: Center(
          child: ThingSpeakButton(),
        ),
      ),
    );
  }
}

class ThingSpeakButton extends StatefulWidget {
  @override
  State<ThingSpeakButton> createState() => _ThingSpeakButtonState();
}

class _ThingSpeakButtonState extends State<ThingSpeakButton> {
  final String apiKey = '46G9ECFO8NCJ6BD6';

  void sendDataToThingSpeak() async {
    var rng = Random();
    String baseUrl =
        'https://api.thingspeak.com/update?api_key=46G9ECFO8NCJ6BD6&field1='
        '${rng.nextInt(9) + 2}&field2='
        '${rng.nextInt(999) + 100}&field3='
        '${rng.nextInt(999) + 100}';
    try {
      final response = await http.get(Uri.parse('$baseUrl?api_key=$apiKey&field1=0'));
      if (response.statusCode == 200) {
        print('Response data: ${response.body}');
      } else {
        print('Failed to send data.');
      }
    } catch (e) {
      print('Caught error: $e');
    }
  }

  Future<MqttBrowserClient> connect() async {
    MqttBrowserClient client = MqttBrowserClient(
        'mqtt.thingspeak.com', '46G9ECFO8NCJ6BD6', maxConnectionAttempts: 3);
    client.logging(on: true);
    client!.port = 8083;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed as UnsubscribeCallback?;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    final connMessage = MqttConnectMessage()
        .authenticateAs('username', 'password')
        .keepAliveFor(60)
        .withWillTopic('iotsimulationchannel')
        .withWillMessage('135890')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;
    try {
    await client.connect();
    } catch (e) {
    print('Exception: $e');
    client.disconnect();
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttMessage message = c[0].payload;
    final payload = MqttPublishPayload.bytesToStringAsString(message as Uint8Buffer);
      print('Received message:$payload from topic: ${c[0].topic}>');
    });

    return client;
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => sendDataToThingSpeak());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network("https://static.cdn.syr.edu/static/www/images/MEH_2022_CampusImagery_HallofLan.width-2600.format-webp.webp",
          height: 400, width: double.infinity, fit: BoxFit.cover,
        ),
        const SizedBox(height: 50,),
        Text('Introduction',
          style: GoogleFonts.firaSans(
            fontSize: 35,
            fontWeight: FontWeight.w500
          ),
        ),
        const SizedBox(height: 40,),
        Text('The system leverages a set of virtual sensors that periodically send data about\ntemperature, humidity, and CO2 levels using MQTT protocol to a cloud-based backend,\nspecifically Things Speak',
          textAlign: TextAlign.center,
          style: GoogleFonts.firaSans(
              fontSize: 16,letterSpacing: 1,
              fontWeight: FontWeight.w400
          ),
        ),
        const SizedBox(height: 40,),
        InkWell(
          onTap: (){
            launchUrl(Uri.parse("https://thingspeak.com/channels/2486324"));
          },
          child: Container(
            height: 50, width: 300,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.orange,
            ),
            child: const Center(
              child: Text('View Things Speak Dashboard'),
            ),
          ),
        ),
        const SizedBox(height: 20,),
        InkWell(
          onTap: (){
            launchUrl(Uri.parse("https://thingspeak.com/channels/2486324"));
          },
          child: const Text('Click to view realtime data being captured',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

// connection succeeded
void onConnected() {
  print('Connected');
}
// unconnected
void onDisconnected() {
  print('Disconnected');
}
// subscribe to topic succeeded
void onSubscribed(String topic) {
  print('Subscribed topic: $topic');
}
// subscribe to topic failed
void onSubscribeFail(String topic) {
  print('Failed to subscribe $topic');
}
// unsubscribe succeeded
void onUnsubscribed(String topic) {
  print('Unsubscribed topic: $topic');
}
// PING response received
void pong() {
  print('Ping response client callback invoked');
}
