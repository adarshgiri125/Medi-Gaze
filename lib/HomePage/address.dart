import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:medigaze/Final/success.dart';
import 'package:medigaze/HomePage/searchLocation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class SelectAddressScreen extends StatefulWidget {
  final String initialText;
  final File? imageFile;

  const SelectAddressScreen(
      {Key? key, required this.initialText, this.imageFile})
      : super(key: key);

  @override
  _SelectAddressScreenState createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  TextEditingController floatingTextFieldController = TextEditingController();
  String address = "";
  bool showAdditionalContent = false;
  late String pincode = "";
  User? user;
  String? number;
  late String customerName = "";
  File? _image;

  Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  LatLng _initialCameraPosition =
      LatLng(12.9716, 77.5946); // Default Bangalore coordinates

  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    floatingTextFieldController.text = widget.initialText;
    _image = widget.imageFile;
    user = FirebaseAuth.instance.currentUser;
    number = user?.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildFrame(context), // This is the map part
            _buildConfirmButton(context), // Confirm button
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Select Address'),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            // Save data to Firebase here
            // _saveDataToFirebase();
          },
        ),
      ],
    );
  }

  Widget _buildUseMyCurrentLocation(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Check if the user has granted location permission
        var status = await Permission.location.status;

        if (status == PermissionStatus.granted) {
          // User has granted location permission, proceed to get the current location
          await _getCurrentLocation();
        } else if (status == PermissionStatus.denied) {
          // Location permission is denied, show a dialog with an option to open app settings
          showLocationPermissionDialog(context);
        } else {
          // User has not yet been asked for permission, request it
          await Permission.location.request();
        }
      },
      child: Text('Use my current location'),
    );
  }

  void showLocationPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Location Permission"),
          content: Text("Turn on the location permission"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings(); // Open app settings
                Navigator.pop(context); // Close the dialog
              },
              child: Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newLatLng(LatLng(position.latitude,
          position.longitude))); // Move camera to current location

      await _updateMarkerPosition(
          LatLng(position.latitude, position.longitude));

      // Fetch address from coordinates
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      Placemark place = placemarks.isNotEmpty ? placemarks[0] : Placemark();

      address =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";

      if (address != null) {
        floatingTextFieldController.text = address;
      } else {
        floatingTextFieldController.text = "Choose correct location";
      }
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<void> _updateMapWithSearch(String searchInput) async {
    if (searchInput.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(searchInput);

        if (locations.isNotEmpty) {
          Location location = locations[0];
          final GoogleMapController controller = await _mapController.future;
          double zoomLevel = 18.0;

          controller.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(location.latitude!, location.longitude!),
            zoomLevel,
          ));
        } else {
          print("No locations found for the entered address");
        }
      } catch (e) {
        print("Error during geocoding: $e");
      }
    } else {
      print("Search input is empty");
    }
  }

  Set<Marker> _createMarkers() {
    return <Marker>{
      Marker(
        markerId: MarkerId("currentLocation"),
        position: _initialCameraPosition,
        draggable: true,
        onDragEnd: (LatLng newPosition) {
          _updateMarkerPosition(newPosition);
        },
      ),
    };
  }

  Future<void> _updateMarkerPosition(LatLng newPosition) async {
    try {
      setState(() {
        _initialCameraPosition = newPosition;
      });

      List<Placemark> placemarks = await placemarkFromCoordinates(
        newPosition.latitude,
        newPosition.longitude,
      );

      Placemark place = placemarks.isNotEmpty ? placemarks[0] : Placemark();

      address =
          "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";

      if (address != null) {
        floatingTextFieldController.text = address;
      } else {
        floatingTextFieldController.text = "Choose correct location";
      }
    } catch (e) {
      // Handle the exception, for example, print the error message
      print("Error in _updateMarkerPosition: $e");
      // You can also throw the exception again if you want to propagate it further
      throw e;
    }
  }

  Widget _buildFrame(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TextField(
            onTap: () async {
              final searchValue = await Navigator.push<String>(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );

              if (searchValue != null && searchValue.isNotEmpty) {
                setState(() {
                  address = searchValue;
                });
                _updateMapWithSearch(searchValue);
              }
            },
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Pin your location',
              suffixIcon: Icon(Icons.search),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            style: TextStyle(color: Colors.black),
            controller: TextEditingController(text: address),
          ),
          SizedBox(
            height: 325,
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _initialCameraPosition,
                    zoom: 16.0,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _mapController.complete(controller);
                  },
                  markers: _createMarkers(),
                  onCameraMove: (CameraPosition position) {
                    setState(() {
                      _initialCameraPosition = position.target;
                    });
                  },
                  onTap: (LatLng tappedPoint) {
                    _updateMarkerPosition(tappedPoint);
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 76, right: 76, bottom: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildUseMyCurrentLocation(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Handle confirm button press
          _handleConfirm();
        },
        child: Text('Confirm'),
      ),
    );
  }

  void _handleConfirm() async {
    try {
      // Upload image to Firebase Storage
      String? imageUrl = await _uploadImageToFirebase(_image!);

      // Save data to Firestore
      await _saveDataToFirestore(widget.initialText, imageUrl ?? '');

      // Notify the specific user
      await _sendNotificationToUser(FirebaseAuth.instance.currentUser!.uid);

      // Navigate to another screen or show success message
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessScreen()),
      );
    } catch (e) {
      print('Error handling confirm button: $e');
      // Handle error gracefully, show error message, etc.
    }
  }

  Future<void> _sendNotificationToUser(String userId) async {
    double customerLatitude = _initialCameraPosition.latitude;
    double customerLongitude = _initialCameraPosition.longitude;
    List<DocumentSnapshot> nearbyRetailers = await getNearbyRetailers(
      customerLatitude,
      customerLongitude,
    );

    int availableTechniciansCount = nearbyRetailers.length;

    for (var technician in nearbyRetailers) {
      print("hyyyyyyyyyyyyyyyy");
      String technicianUserID = technician['userId'];
      String userDeviceToken = "";

      print("Fetching device token for technician $technicianUserID...");
      await FirebaseFirestore.instance
          .collection("technicians")
          .doc(technicianUserID)
          .get()
          .then((snapshot) {
        if (snapshot.data()!["token"] != null) {
          userDeviceToken = snapshot.data()!["token"].toString();
        }
      });

      print("Technician $technicianUserID device token: $userDeviceToken");

      // Send notification to technician
      print("Sending notification to technician $technicianUserID...");
      String customerTokenId = '';

      await FirebaseFirestore.instance
          .collection('customers')
          .doc(userId)
          .get()
          .then((snapshot) {
        if (snapshot.data()!['device_token'] != null) {
          customerTokenId = snapshot.data()!['device_token'].toString();
        }
      });

      //sending document to the technician side ------>>>
      String techdocName = DateTime.now().millisecondsSinceEpoch.toString();

      await FirebaseFirestore.instance
          .collection('technicians')
          .doc(technicianUserID)
          .collection('serviceList')
          .doc(techdocName)
          .set({
        'customerPhone': number,
        'customerAddress': address,
        'customerLocation': _initialCameraPosition,
        'customerId': userId,
        'customerTokenId': customerTokenId,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'n',
        'customerName': customerName,
      }, SetOptions(merge: true));

      notificationFormat(
          technicianUserID, address, number, userDeviceToken, userId);

      print("Waiting for technician $technicianUserID response...");
    }
    try {
      // Retrieve the FCM token for the user from Firestore

      print('Notification sent successfully');
    } catch (e) {
      print('Error sending notification: $e');
    }
  }
}

notificationFormat(
    receiverID, address, phoneNumber, userDeviceToken, String userID) async {
  print("Building notification format...");

  Map<String, String> headerNotification = {
    "Content-Type": "application/json",
    "Authorization":
        "key=AAAA0PM0nhk:APA91bEEQmPk1eVc7fRsFUrI5ziYm-zWCi_5BrO88PDz5A48YUU96Iwrp0fIBJ6CV6HGXsn13yOFzvKxb0Fnk2VZyK7g1cPXBm1KimmoP_028MLNiSKsULtk2h9P1QU2kNIxmSBV2h1L",
  };

  Map bodyNotification = {
    "body": "you have received a new service from $phoneNumber. click to see",
    "title": "New Customer",
  };

  Map dataMap = {
    "click_action": "FLUTTER_NOTIFICATION_CLICK",
    "id": "1",
    "status": "done",
    "phonenumber": phoneNumber,
    "user": userID,
  };

  Map notificationFormat = {
    "notification": bodyNotification,
    "data": dataMap,
    "priority": "high",
    "to": userDeviceToken,
  };

  print("Sending notification to technician $receiverID...");
  try {
    final response = await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(notificationFormat),
    );

    if (response.statusCode == 200) {
      print("Notification Payload: $notificationFormat");
      print("Notification sent successfully to technician $receiverID.");
    } else {
      print(
          "Failed to send notification to technician $receiverID. Status code: ${response.statusCode}");
    }
  } catch (e) {
    print("Error while sending notification to technician $receiverID: $e");
  }
}

Future<String?> _uploadImageToFirebase(File imageFile) async {
  try {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    print('Error uploading image to Firebase Storage: $e');
    return null;
  }
}

Future<void> _saveDataToFirestore(String initialText, String imageUrl) async {
  try {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('userData').doc(userId).set({
      'initialText': initialText,
      'imageUrl': imageUrl,
    });
    print('Data saved to Firestore successfully');
  } catch (e) {
    print('Error saving data to Firestore: $e');
  }
}

Future<List<DocumentSnapshot>> getNearbyRetailers(
  double customerLatitude,
  double customerLongitude,
) async {
  print("Fetching nearby technicians...");

  final QuerySnapshot result =
      await FirebaseFirestore.instance.collection('technicians').get();

  List<DocumentSnapshot> technicians = result.docs;

  // Fetch all currentLocation data asynchronously
  List<Map<String, dynamic>> locationsData = await Future.wait(
    technicians.map((technician) async {
      try {
        DocumentSnapshot currentLocationSnapshot = await technician.reference
            .collection('location')
            .doc('currentLocation')
            .get();

        if (currentLocationSnapshot.exists) {
          return {
            'id': technician.id,
            'latitude': currentLocationSnapshot['latitude'] ?? 0.0,
            'longitude': currentLocationSnapshot['longitude'] ?? 0.0,
          };
        } else {
          print(
              "currentLocation document does not exist for technician ${technician.id}");
        }
      } catch (e) {
        print("Error fetching location for technician ${technician.id}: $e");
      }

      return {
        'id': technician.id,
        'latitude': 0.0,
        'longitude': 0.0,
      };
    }),
  );

  // Calculate distances asynchronously
  List<Map<String, dynamic>> techniciansWithDistances = [];

  for (int index = 0; index < technicians.length; index++) {
    Map<String, dynamic> location = locationsData
        .firstWhere((element) => element['id'] == technicians[index].id);

    double distance = await calculateDistance(
      customerLatitude,
      customerLongitude,
      location['latitude'],
      location['longitude'],
    );

    if (distance <= 13.0) {
      techniciansWithDistances.add({
        'technician': technicians[index],
        'distance': distance,
      });
      print(
          "Technician ${technicians[index].id} is close (distance: $distance km). including from the list.");
    } else {
      print(
          "Technician ${technicians[index].id} is too far away (distance: $distance km). Excluding from the list.");
    }
  }

  // Sort technicians based on distance
  techniciansWithDistances.sort((a, b) {
    double distanceA = a['distance'];
    double distanceB = b['distance'];

    print("Technician ${a['technician'].id} Distance: $distanceA");
    print("Technician ${b['technician'].id} Distance: $distanceB");

    return distanceA.compareTo(distanceB);
  });

  // Extract sorted technicians
  List<DocumentSnapshot> sortedTechnicians = techniciansWithDistances
      .map((technicianWithDistance) =>
          technicianWithDistance['technician'] as DocumentSnapshot)
      .toList();

  print("Sorted nearby technicians by distance.");

  return sortedTechnicians;
}

// Function to calculate distance between two points using Google Maps Distance Matrix API
Future<double> calculateDistance(
  double startLat,
  double startLon,
  double endLat,
  double endLon,
) async {
  if (endLat == 0.0 || endLon == 0.0) {
    print("Invalid destination coordinates: Latitude or longitude is 0.0");
    return double.infinity; // Return a large value to indicate invalid distance
  }
  print("check${startLat}, ${startLon}, $endLat, $endLon");
  final apiKey = 'AIzaSyArXVgSCF4LhaTp4M-ckCvz5ZzT2Xg68to';
  final apiUrl = 'https://maps.googleapis.com/maps/api/directions/json';

  final response = await http.get(
    Uri.parse(
      '$apiUrl?origin=$startLat,$startLon&destination=$endLat,$endLon&key=$apiKey',
    ),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      final route = data['routes'][0]['legs'][0];
      final distanceInMeters = route['distance']['value'];
      return distanceInMeters / 1000.0; // Convert meters to kilometers
    } else {
      print('Error: ${data['status']} - ${data['error_message']}');
      throw Exception('Failed to get directions');
    }
  } else {
    print('Error: ${response.statusCode}');
    throw Exception('Failed to get directions');
  }
}
