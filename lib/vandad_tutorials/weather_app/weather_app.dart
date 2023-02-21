import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum City {
  benin,
  lagos,
  delta,
}

typedef WeatherEmoji = String;

// future call to get weather
Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.benin: '☀',
      City.lagos: '🌧',
      City.delta: '🌦',
    }[city]!,
  );
}

// UI reads from and writes to this
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

const unknownWeatherEmoji = '❓';

// UI writes to this
final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);
  if (City != null) {
    return getWeather(city!);
  } else {
    return unknownWeatherEmoji;
  }
});

class WeatherApp extends ConsumerWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (weather) => Text(
              weather,
              style: const TextStyle(fontSize: 40),
            ),
            loading: () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: const CircularProgressIndicator(),
            ),
            error: (_, __) => Text(unknownWeatherEmoji),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: City.values.length,
                  itemBuilder: (context, index) {
                    final city = City.values[index];
                    final isSelected = city == ref.watch(currentCityProvider);
                    return ListTile(
                      title: Text(city.toString()),
                      trailing: isSelected ? const Icon(Icons.check) : null,
                      onTap: () =>
                          ref.read(currentCityProvider.notifier).state = city,
                    );
                  }))
        ],
      ),
    );
  }
}
