import 'package:country_picker/country_picker.dart';
import 'package:credit_card_capture_app/country_screen.dart';
import 'package:credit_card_capture_app/credit_card_object.dart';
import 'package:credit_card_capture_app/save_card_tolocal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:credit_card_scanner/credit_card_scanner.dart';

//initialize variables
TextEditingController teCardNumber = TextEditingController();
TextEditingController teCVV = TextEditingController();
TextEditingController teFilter = TextEditingController();

List<CreditCard> creditCardList = [];
List<CreditCard> filteredcreditCardList = [];

var cardTypeWidget = const Row(
  mainAxisSize: MainAxisSize.min,
  children: [Icon(LineIcons.creditCard)],
);

var validCard = false;
var cardType = "";

List<Country> bannedCountries = [];
var selectedCounty = 'Select Country';

//Setup masks for textformfields
var creditCardMaskFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

var cVVMaskFormatter = MaskTextInputFormatter(
    mask: '###',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appbar
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(LineIcons.globeWithAfricaShown),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const CountryScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    var begin = const Offset(1.0, 0.0);
                    var end = Offset.zero;
                    var curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ],
        title: const Text('Credit Card Capturing'),
      ),
      //body
      //in scrollview for if screens are or small
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    height: 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Credit Card Number:'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 280,
                              height: 40,
                              child: TextFormField(
                                controller: teCardNumber,
                                onChanged: (value) {
                                  //Set state to load icon and card type
                                  setState(() {
                                    cardTypeWidget = getCardType(value);
                                  });
                                },
                                onFieldSubmitted: (value) {
                                  //Set state to load icon and card type
                                  setState(() {
                                    cardTypeWidget = getCardType(value);
                                  });
                                },
                                //keyboard only allows numbers
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  creditCardMaskFormatter
                                ],
                                textAlign: TextAlign.start,
                                decoration: InputDecoration(
                                    suffixIcon: cardTypeWidget,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    hintText: '0000 0000 0000 0000',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                            ElevatedButton(
                                //using onsync to wait for retrival of scan data
                                onPressed: () async {
                                  var cardDetails =
                                      await CardScanner.scanCard();
                                  setState(() {
                                    if (cardDetails != null) {
                                      final text = cardDetails.cardNumber
                                          .replaceAllMapped(RegExp(r".{4}"),
                                              (match) => "${match.group(0)} ");
                                      teCardNumber.text = text;
                                      cardTypeWidget =
                                          getCardType(teCardNumber.text);
                                    }
                                  });
                                },
                                child: const Text('Scan Card')),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('CVV:'),
                                ),
                                SizedBox(
                                  height: 40,
                                  width: 100,
                                  child: TextFormField(
                                    controller: teCVV,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      cVVMaskFormatter
                                    ],
                                    textAlign: TextAlign.start,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        width: 200,
                                                        height: 300,
                                                        child: Column(
                                                          children: [
                                                            const Text(
                                                                'The CVV code is usually located on the back of the card, although in some cases it may be found on the front.'),
                                                            Image.asset(
                                                                "assets/images/cvv.png"),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                'Ok'))
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                                LineIcons.questionCircle)),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16),
                                        hintText: '000',
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Country Issued:'),
                                ),
                                SizedBox(
                                    height: 40,
                                    width: 250,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        List<String> bannedCodes = [];
                                        for (var country in bannedCountries) {
                                          bannedCodes.add(country.countryCode);
                                        }
                                        showCountryPicker(
                                            countryListTheme:
                                                const CountryListThemeData(
                                                    bottomSheetHeight: 500),
                                            context: context,
                                            exclude: bannedCodes,
                                            onSelect: (Country country) =>
                                                setState(() {
                                                  selectedCounty =
                                                      '${country.flagEmoji} ${country.name}';
                                                }));
                                      },
                                      child: Text(selectedCounty),
                                    ))
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      if (validCard == false) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const SizedBox(
                                  width: 200,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        LineIcons.exclamationTriangle,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                      Text('Invalid Credit Card Number.'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Ok'))
                                ],
                              );
                            });
                        return;
                      }
                      if (teCVV.text.isEmpty || teCVV.text.length < 3) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const SizedBox(
                                  width: 200,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        LineIcons.exclamationTriangle,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                      Text('Invalid CVV.'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Ok'))
                                ],
                              );
                            });
                        return;
                      }
                      if (selectedCounty == 'Select Country') {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const SizedBox(
                                  width: 200,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        LineIcons.exclamationTriangle,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                      Text('No Country Selected'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Ok'))
                                ],
                              );
                            });
                        return;
                      }
                      if (creditCardList.any(
                          (card) => card.cardNumber == teCardNumber.text)) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const SizedBox(
                                  width: 250,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        LineIcons.exclamationTriangle,
                                        color: Colors.red,
                                        size: 50,
                                      ),
                                      Text(
                                          'This Credit Card Is Already In The List.'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Ok'))
                                ],
                              );
                            });
                        return;
                      }

                      CreditCard enteredcard = CreditCard(
                          cardNumber: '', cardType: '', cvv: '', country: '');
                      setState(() {
                        enteredcard.cardNumber = teCardNumber.text;
                        enteredcard.cardType = cardType;
                        enteredcard.cvv = teCVV.text;
                        enteredcard.country = selectedCounty;
                        creditCardList.add(enteredcard);
                        filteredcreditCardList.add(enteredcard);
                        saveData(enteredcard);
                        //Print in terminal to see if data saved. (Can be used later for loads or data extraction)
                        retrieveData();
                        teCardNumber.clear();
                        teCVV.clear();
                        selectedCounty = 'Select Country';
                        cardTypeWidget = const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(LineIcons.creditCard)],
                        );
                        cardType = "";
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(LineIcons.plus),
                        Text('Add Credit Card'),
                      ],
                    )),
              ),
            ),
            const Divider(
              indent: 5,
              endIndent: 5,
              thickness: 1,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'List of Credit Cards:',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: teFilter,
                  onChanged: (value) {
                    setState(() {
                      filteredcreditCardList = creditCardList.where((card) {
                        return card.cardNumber
                                .toLowerCase()
                                .contains(teFilter.text.toLowerCase()) ||
                            card.cardType
                                .toLowerCase()
                                .contains(teFilter.text.toLowerCase()) ||
                            card.cvv
                                .toLowerCase()
                                .contains(teFilter.text.toLowerCase()) ||
                            card.country
                                .toLowerCase()
                                .contains(teFilter.text.toLowerCase());
                      }).toList();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(LineIcons.search),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    hintText: 'Search...',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                height: MediaQuery.of(context).size.height * 0.5,
                child: filteredcreditCardList.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredcreditCardList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(filteredcreditCardList[index]
                                          .cardNumber),
                                      Text(filteredcreditCardList[index].cvv),
                                      Text(filteredcreditCardList[index]
                                          .cardType),
                                      Text(
                                          filteredcreditCardList[index].country)
                                    ],
                                  ),
                                  const Divider(
                                    indent: 5,
                                    endIndent: 5,
                                  )
                                ],
                              ));
                        })
                    : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Get Card Type By checking for 4 if visa and 13 to 16 char lenght or master if 51 to 55 and 16 lenght
getCardType(String cardNumber) {
  cardNumber = cardNumber.replaceAll(' ', '');
  if (cardNumber.startsWith('4') &&
      (cardNumber.length == 13 || cardNumber.length == 16)) {
    cardType = "Visa";
    validCard = true;
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Visa',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        SizedBox(
          width: 5,
        ),
        Icon(LineIcons.visaCreditCard),
        SizedBox(
          width: 5,
        ),
      ],
    );
  } else if (cardNumber.length == 16 &&
      (cardNumber.startsWith('51') ||
          cardNumber.startsWith('52') ||
          cardNumber.startsWith('53') ||
          cardNumber.startsWith('54') ||
          cardNumber.startsWith('55'))) {
    cardType = "Master Card";
    validCard = true;
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Master Card',
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
        ),
        SizedBox(
          width: 5,
        ),
        Icon(LineIcons.mastercardCreditCard),
        SizedBox(
          width: 5,
        ),
      ],
    );
  } else {
    validCard = false;
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Invalid',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        SizedBox(
          width: 5,
        ),
        Icon(LineIcons.exclamation),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
