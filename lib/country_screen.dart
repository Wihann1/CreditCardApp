import 'package:country_picker/country_picker.dart';
import 'package:credit_card_capture_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Banned Countries'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        List<String> bannedCodes = [];
                        for (var country in bannedCountries) {
                          bannedCodes.add(country.countryCode);
                        }
                        showCountryPicker(
                            countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 500),
                            context: context,
                            exclude: bannedCodes,
                            onSelect: (Country country) => setState(() {
                                  bannedCountries.add(country);
                                  bannedCountries
                                      .sort((a, b) => a.name.compareTo(b.name));
                                }));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(LineIcons.plus),
                          Text(
                            'Add Banned \nCountry',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  width: 180,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        List<String> bannedCodes = [];
                        for (var country in bannedCountries) {
                          bannedCodes.add(country.countryCode);
                        }
                        showCountryPicker(
                            countryListTheme: const CountryListThemeData(
                                bottomSheetHeight: 500),
                            countryFilter: bannedCodes,
                            context: context,
                            onSelect: (Country country) => setState(() {
                                  bannedCountries.remove(country);
                                  bannedCountries
                                      .sort((a, b) => a.name.compareTo(b.name));
                                }));
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(LineIcons.minus),
                          Text(
                            'Remove Banned \nCountry',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: MediaQuery.of(context).size.height * 0.8,
                child: bannedCountries.isNotEmpty
                    ? ListView.builder(
                        itemCount: bannedCountries.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                  child: Text(
                                      '${bannedCountries[index].flagEmoji}     ${bannedCountries[index].name}'),
                                ),
                                const Divider(
                                  indent: 5,
                                  endIndent: 5,
                                )
                              ],
                            ),
                          );
                        })
                    : null,
              ),
            )
          ],
        ));
  }
}
