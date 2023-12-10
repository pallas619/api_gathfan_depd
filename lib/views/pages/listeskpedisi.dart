part of 'pages.dart';

class PricePage extends StatefulWidget {
  const PricePage({Key? key}) : super(key: key);

  @override
  State<PricePage> createState() => _PricePageState();
}

const List<String> Courier = <String>['jne', 'pos', 'tiki'];

class _PricePageState extends State<PricePage> {
  List<Province> provinceData = [];
  String selectedCourier = Courier.first;
  dynamic selectedProvinceOrigin;
  dynamic selectedProvinceDestination;
  dynamic provinceIdOrigin;
  dynamic provinceIdDestination;
  dynamic selectedCityOrigin;
  dynamic selectedCityDestination;
  dynamic cityIdOrigin;
  dynamic cityIdDestination;
  dynamic cityDataOrigin;
  dynamic cityDataDestination;
  dynamic costData;
  TextEditingController weightInput = TextEditingController();

  bool isLoading = false;
  bool isLoadingCities = false;

  Future<void> _handleProvinceOriginChange(dynamic newValue) async {
    setState(() {
      selectedProvinceOrigin = newValue;
      isLoadingCities = true;
    });

    if (selectedProvinceOrigin != null) {
      cityDataOriginFuture = getCities(selectedProvinceOrigin.provinceId);
      var cities = await cityDataOriginFuture!;

      setState(() {
        cityDataOrigin = cities;
        selectedCityOrigin = null;
        isLoadingCities = false;
      });
    } else {
      setState(() {
        cityDataOriginFuture = null;
        isLoadingCities = false;
      });
    }
  }

  Future<void> _handleProvinceDestinationChange(dynamic newValue) async {
    setState(() {
      selectedProvinceDestination = newValue;
      isLoadingCities = true;
    });

    if (selectedProvinceDestination != null) {
      cityDataDestinationFuture =
          getCities(selectedProvinceDestination.provinceId);
      var cities = await cityDataDestinationFuture!;

      setState(() {
        cityDataDestination = cities;
        selectedCityDestination = null;
        isLoadingCities = false;
      });
    } else {
      setState(() {
        cityDataDestinationFuture = null;
        isLoadingCities = false;
      });
    }
  }

  Future<List<City>>? cityDataOriginFuture;
  Future<List<City>>? cityDataDestinationFuture;
  Future<void> getProvinces() async {
    try {
      setState(() {
        isLoading = true;
      });

      var provinces = await MasterDataService.getProvince();

      setState(() {
        provinceData = provinces;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getCost(
      var courier, var weight, var originId, var destinationId) async {
    try {
      setState(() {
        isLoading = true;
      });

      var costs = await MasterDataService.getCost(
          courier, weight, originId, destinationId);

      if (costs.isNotEmpty) {
        setState(() {
          costData = costs;
        });
      } else {
        print('Error: No cost data found.');
      }
    } catch (e) {
      print('Error fetching costs: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<City>> getCities(var provId) async {
    try {
      setState(() {
        isLoadingCities = true;
      });

      var cities = await MasterDataService.getCity(provId);

      return cities;
    } finally {
      setState(() {
        isLoadingCities = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getProvinces();
    weightInput = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        
        title: const Text("Price Calculator Page"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 16),
                        width: 100,
                        child: DropdownButton(
                          isExpanded: true,
                          value: selectedCourier,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 40,
                          elevation: 4,
                          style: TextStyle(color: Colors.black),
                          hint: selectedCourier == null
                              ? Text('Select courier')
                              : Text(selectedCourier),
                          items: Courier.map((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCourier = newValue.toString();
                            });
                          },
                        ),
                      ),
                      SizedBox(width: 40),
                      Container(
                        width: 240,
                        child: TextFormField(
                          controller: weightInput,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {},
                          decoration: InputDecoration(
                            labelText: 'Berat (gr)',
                            labelStyle: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
                        child: Text("Origin"),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 16),
                            width: 160,
                            child: DropdownButton(
                              isExpanded: true,
                              value: selectedProvinceOrigin,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 4,
                              style: TextStyle(color: Colors.black),
                              hint: selectedProvinceOrigin == null
                                  ? Text('Pilih provinsi')
                                  : Text(
                                      selectedProvinceOrigin is Province
                                          ? selectedProvinceOrigin.province
                                          : selectedProvinceOrigin,
                                    ),
                              items: provinceData
                                  .map<DropdownMenuItem<Province>>(
                                      (Province value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value.province.toString()),
                                );
                              }).toList(),
                              onChanged: (dynamic newValue) {
                                _handleProvinceOriginChange(newValue);

                                setState(() {
                                  selectedCityOrigin = null;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 40),
                          Container(
                            width: 160,
                            child: FutureBuilder<List<City>>(
                              future: cityDataOriginFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return UiLoading.loadingSmall();
                                } else if (snapshot.hasError) {
                                  return Text("Tidak ada data");
                                } else if (!snapshot.hasData) {
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityOrigin,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: TextStyle(color: Colors.black),
                                    hint: Text('Pilih kota'),
                                    items: <DropdownMenuItem<City>>[],
                                    onChanged: null,
                                  );
                                } else {
                                  // Data available state
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityOrigin,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: TextStyle(color: Colors.black),
                                    hint: selectedCityOrigin == null
                                        ? Text('Pilih kota')
                                        : Text(selectedCityOrigin.cityName),
                                    items: snapshot.data!
                                        .map<DropdownMenuItem<City>>(
                                            (City value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child:
                                              Text(value.cityName.toString()));
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedCityOrigin = newValue;
                                        cityIdOrigin =
                                            selectedCityOrigin.cityId;
                                      });
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, top: 4, bottom: 4),
                        child: Text("Destination"),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 16),
                            width: 160,
                            child: DropdownButton(
                              isExpanded: true,
                              value: selectedProvinceDestination,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 30,
                              elevation: 4,
                              style: TextStyle(color: Colors.black),
                              hint: selectedProvinceDestination == null
                                  ? Text('Pilih provinsi')
                                  : Text(
                                      selectedProvinceDestination is Province
                                          ? selectedProvinceDestination.province
                                          : selectedProvinceDestination,
                                    ),
                              items: provinceData
                                  .map<DropdownMenuItem<Province>>(
                                      (Province value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value.province.toString()),
                                );
                              }).toList(),
                              onChanged: (dynamic newValue) {
                                _handleProvinceDestinationChange(newValue);

                                setState(() {
                                  selectedCityDestination = null;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 40),
                          Container(
                            width: 160,
                            child: FutureBuilder<List<City>>(
                              future: cityDataDestinationFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return UiLoading.loadingSmall();
                                } else if (snapshot.hasError) {
                                  return Text("Tidak ada data");
                                } else if (!snapshot.hasData) {
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityDestination,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: TextStyle(color: Colors.black),
                                    hint: Text('Pilih kota'),
                                    items: <DropdownMenuItem<City>>[],
                                    onChanged: null,
                                  );
                                } else {
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: selectedCityDestination,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: TextStyle(color: Colors.black),
                                    hint: selectedCityDestination == null
                                        ? Text('Pilih kota')
                                        : Text(
                                            selectedCityDestination.cityName),
                                    items: snapshot.data!
                                        .map<DropdownMenuItem<City>>(
                                            (City value) {
                                      return DropdownMenuItem(
                                          value: value,
                                          child:
                                              Text(value.cityName.toString()));
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedCityDestination = newValue;
                                        cityIdDestination =
                                            selectedCityDestination.cityId;
                                      });
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        if (selectedCourier == null ||
                            selectedCityOrigin == null ||
                            selectedCityDestination == null ||
                            weightInput.text.isEmpty) {
                          String errorMessage = "Tolong lengkapi data! (";

                          if (selectedCourier == null) {
                            errorMessage += "Pilih kurir, ";
                          }

                          if (selectedCityOrigin == null) {
                            errorMessage += "Pilih kota asal, ";
                          }

                          if (selectedCityDestination == null) {
                            errorMessage += "Pilih kota tujuan, ";
                          }

                          if (weightInput.text.isEmpty) {
                            errorMessage += "Isi berat, ";
                          }

                          errorMessage = errorMessage.substring(
                              0, errorMessage.length - 2);
                          errorMessage += ")";

                          Fluttertoast.showToast(
                            msg: errorMessage,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          return;
                        }

                        setState(() {
                          isLoading = true;
                        });

                        var costs = await MasterDataService.getCost(
                          selectedCourier,
                          weightInput.text,
                          selectedCityOrigin.cityId,
                          selectedCityDestination.cityId,
                        );

                        setState(() {
                          costData = costs ?? [];
                        });
                      } catch (e) {
                        print('Error fetching costs: $e');
                      } finally {
                        setState(() {
                          isLoading = false;
                        });
                      }
                    },
                    child: Text("Hitung Estimasi Harga"),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: costData == null || costData.isEmpty
                      ? const Align(
                          alignment: Alignment.center,
                          child: Text("Data tidak ditemukan"),
                        )
                      : ListView.builder(
                          itemCount: costData.length,
                          itemBuilder: (context, index) {
                            return CardOngkir(costData[index]);
                          },
                        ),
                ),
              ),
            ],
          ),
          if (isLoading) UiLoading.loadingBlock(),
        ],
      ),
    );
  }
}
