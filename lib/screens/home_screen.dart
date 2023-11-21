import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:app_wheater/models/weater_code.dart';
import 'package:app_wheater/repositories/favourites_repository.dart';
import 'package:app_wheater/widgets/list_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

final List<WeaterCode> weaters = [
  WeaterCode(
    code: 113,
    src: "lib/assets/cloud.json",
    title: "Sol",
    day: true,
  ),
  WeaterCode(
    code: 113,
    src: "lib/assets/cloud.json",
    title: "Nuvens",
    day: false,
  ),
  WeaterCode(
    code: 116,
    src: "lib/assets/partlycloudy.json",
    title: "Parcialmente Nublado",
    day: true,
  ),
  WeaterCode(
    code: 116,
    src: "lib/assets/partlycloudy.json",
    title: "Parcialmente Nublado",
    day: false,
  ),
  WeaterCode(
    code: 119,
    src: "lib/assets/cloudy.json",
    title: "Nublado",
    day: true,
  ),
  WeaterCode(
    code: 119,
    src: "lib/assets/cloudy.json",
    title: "Nublado",
    day: false,
  ),
  WeaterCode(
    code: 122,
    src: "lib/assets/overcast.json",
    title: "Encoberto",
    day: true,
  ),
  WeaterCode(
    code: 122,
    src: "lib/assets/overcast.json",
    title: "Encoberto",
    day: false,
  ),
  WeaterCode(
    code: 143,
    src: "lib/assets/mist.json",
    title: "Neblina",
    day: true
  ),
  WeaterCode(
      code: 143,
      src: "lib/assets/mist.json",
      title: "Neblina",
      day: false
  ),
  WeaterCode(
    code: 176,
    src: "lib/assets/mist.json",
    title: "Possibilidade de chuva irregular",
    day: true
  ),
  WeaterCode(
      code: 176,
      src: "lib/assets/mist.json",
      title: "Possibilidade de chuva irregular",
      day: false
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //repository
  late AppRepository _appRepository;
  late Color corBackground = Colors.transparent;
  late Color corText = Colors.transparent;
  int weaterSelected = 0;
  late AdaptiveThemeMode savedThemeMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getColors();
  }

  @override
  Widget build(BuildContext context) {
    _appRepository = context.watch<AppRepository>();
    return Scaffold(
      backgroundColor: corBackground,
      body: _appRepository.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              color: corText,
              onRefresh: () async {
                _appRepository.getLocation();
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      color: corBackground.withOpacity(1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              const Spacer(),
                              IconButton(
                                onPressed: () async {
                                  AdaptiveTheme.of(context).toggleThemeMode(useSystem: false);

                                  if(savedThemeMode.isDark){
                                    setState(() {
                                      savedThemeMode = AdaptiveThemeMode.light;
                                      corBackground = Colors.white;
                                      corText = Colors.black;
                                    });
                                  }else{
                                    setState(() {
                                      savedThemeMode = AdaptiveThemeMode.dark;
                                      corBackground = Colors.black;
                                      corText = Colors.white;
                                    });
                                  }
                                },
                                icon: Icon(
                                  Icons.light_mode,
                                  color:
                                  (savedThemeMode.isDark) ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: corText,
                                ),
                                Text(
                                  _appRepository
                                      .responseApiWheater.location.name,
                                  style: GoogleFonts.smoochSans(
                                    color: corText,
                                    fontSize: 35,
                                  ),
                                ),
                                Text(
                                  _appRepository
                                      .responseApiWheater.location.country,
                                  style: GoogleFonts.smoochSans(
                                    color: corText,
                                    fontSize: 12,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25.0),
                                  child: Center(
                                    child: _lootie(),
                                  ),
                                ),
                                Text(
                                  weaters[weaterSelected].title,
                                  style: GoogleFonts.smoochSans(
                                    color: corText,
                                    fontSize: 18,
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${_appRepository.responseApiWheater.current.temperature}°",
                                  style: GoogleFonts.smoochSans(
                                    fontSize: 80,
                                    fontWeight: FontWeight.bold,
                                    color: corText,
                                  ),
                                ),
                                Text(
                                  "C",
                                  style: GoogleFonts.smoochSans(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: corText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: Icon(
                              Icons.arrow_downward,
                              size: 30,
                              color: corText,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                        top: 50.0,
                        right: 50.0,
                        left: 50.0,
                        bottom: 50.0,
                      ),
                      color: corText,
                      child: Column(
                        children: [
                          //Velocidade do vento
                          ListInfo(
                            title: "Velocidade do Vento",
                            value:
                                "${_appRepository.responseApiWheater.current.windSpeed} km/h",
                            corText: corBackground,
                          ),
                          const Divider(),
                          ListInfo(
                            title: "Direção do Vento",
                            value: _getDirection(_appRepository
                                .responseApiWheater.current.windDir),
                            corText: corBackground,
                          ),
                          const Divider(),
                          ListInfo(
                            title: "Pressão do Ar",
                            value:
                                "${_appRepository.responseApiWheater.current.pressure} mb",
                            corText: corBackground,
                          ),
                          const Divider(),
                          ListInfo(
                            title: "Precipitação",
                            value:
                                "${_appRepository.responseApiWheater.current.precip} %",
                            corText: corBackground,
                          ),
                          const Divider(),
                          ListInfo(
                            title: "Humidade",
                            value:
                                "${_appRepository.responseApiWheater.current.humidity} %",
                            corText: corBackground,
                          ),
                          const Divider(),
                          ListInfo(
                            title: "Índice UV",
                            value:
                                "${_appRepository.responseApiWheater.current.uvIndex}",
                            corText: corBackground,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  _lootie() {
    String src = weaters[0].src;
    int loop = 0;
    bool isDay = true;
    if(_appRepository.responseApiWheater.current.isDay == "no"){
      isDay = false;
    }
    for (var element in weaters) {
      if (element.code ==
          _appRepository.responseApiWheater.current.weatherCode && element.day == isDay) {
        src = element.src;
        weaterSelected = loop;
      }
      loop++;
    }
    return Lottie.asset(src);
  }

  void _getColors() async {
    savedThemeMode = (await AdaptiveTheme.getThemeMode())!;
    if (savedThemeMode!.isDark) {
      corBackground = Colors.black;
      corText = Colors.white;
    } else if (savedThemeMode.isLight) {
      corBackground = Colors.white;
      corText = Colors.black;
    }
  }

  _getDirection(String dir) {
    switch (dir) {
      case "N":
        return "Norte";
      case "S":
        return "Sul";
      case "L":
        return "Leste";
      case "O":
        return "Oeste";
      case "NO":
        return "Noroeste";
      case "NW":
        return "Noroeste";
      case "SW":
        return "Sudoeste";
      case "SE":
        return "Sudeste";
      case "NE":
        return "Nordeste";
      case "ENE":
        return "Leste-nordeste";
      case "ESE":
        return "Leste-sudoeste";
      case "SSE":
        return "Sul-sudeste";
      default:
        return "Sem Direção";
    }
  }
}
