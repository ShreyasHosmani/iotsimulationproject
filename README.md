```markdown
# IoT Simulation Project

## Introduction
This repository contains the code for an IoT Simulation Project, which demonstrates a cloud-based IoT system collecting data from a set of virtual sensors using the MQTT protocol. The data includes temperature, humidity, and CO2 levels, and is sent to ThingSpeak for storage and visualization.

## System Requirements
- Flutter 3.13.1
- Dart SDK
- Any modern web browser

## Installation
To set up the project on your local machine, follow these steps:
```

1. Clone the repository:

```bash
git clone https://github.com/ShreyasHosmani/iotsimulationproject.git
```

2. Navigate to the project directory:

```bash
cd iotsimulationproject
```

3. Get Flutter dependencies:

```bash
flutter pub get
```

## Running the Project
To run the project, execute the following command in the terminal:

```bash
flutter run (this is supposed to be done once you select chrome from available devices list at the top of android studio or whatever IDE is being used)
```

Make sure you have an emulator running, or a device connected to run the app on.

## Configuration
To configure the MQTT client with your own credentials, update the following lines in your code with your ThingSpeak MQTT API Key:
```

```dart
final String apiKey = 'YOUR_API_KEY';
```

Additionally, ensure the correct channel and fields are being used for sending data to ThingSpeak.

## Viewing the Dashboard
To view the live data being sent to the ThingSpeak channel, navigate to:

[https://thingspeak.com/channels/YOUR_CHANNEL_ID](https://thingspeak.com/channels/YOUR_CHANNEL_ID)

Replace `YOUR_CHANNEL_ID` with your actual ThingSpeak channel ID.

## Contributing
Contributions are welcome. Please fork the repository and submit pull requests with any enhancements.

## Support
If you encounter any issues or require assistance, please open an issue in the repository.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments
- The Flutter Team, for the excellent framework that made this project possible.
- ThingSpeak, for providing a versatile IoT platform.
```
