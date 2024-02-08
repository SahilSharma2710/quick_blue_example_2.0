import 'dart:convert';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:quick_blue/quick_blue.dart';

const WOODEMI_MTU_WUART = 247;
String serviceUuid = '';

class PeripheralDetailPage extends StatefulWidget {
  final String deviceId;

  PeripheralDetailPage(this.deviceId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _PeripheralDetailPageState();
  }
}

class _PeripheralDetailPageState extends State<PeripheralDetailPage> {
  @override
  void initState() {
    super.initState();

    QuickBlue.setConnectionHandler(_handleConnectionChange);
    QuickBlue.setServiceHandler(_handleServiceDiscovery);
    QuickBlue.setValueHandler(_handleValueChange);
  }

  @override
  void dispose() {
    super.dispose();
    QuickBlue.setValueHandler(null);
    QuickBlue.setServiceHandler(null);
    QuickBlue.setConnectionHandler(null);
  }

  void _handleConnectionChange(String deviceId, BlueConnectionState state) {
    if (state == BlueConnectionState.connected) {
      _showSnackBar("connected");
    } else if (state == BlueConnectionState.disconnected) {
      _showSnackBar("dissconnected");
    }
    print('_handleConnectionChange $deviceId, $state');
  }

  void _handleServiceDiscovery(String deviceId, String serviceId) {
    serviceUuid = serviceId;
    setState(() {});
    print('_handleServiceDiscovery $deviceId, $serviceId');
  }

  void _handleValueChange(
      String deviceId, String characteristicId, Uint8List value) {
    String stringValue = utf8.decode(value);
    _showSnackBar(stringValue);

    print(
        '_handleValueChange $deviceId, $characteristicId, ${hex.encode(value)}');
  }

  _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
    );
  }

  TextEditingController characteristicUUID = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    TextEditingController serviceUUID =
        TextEditingController(text: serviceUuid);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PeripheralDetailPage'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                child: const Text('connect'),
                onPressed: () {
                  QuickBlue.connect(widget.deviceId);
                },
              ),
              TextButton(
                child: const Text('disconnect'),
                onPressed: () {
                  QuickBlue.disconnect(widget.deviceId);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton(
                child: const Text('discoverServices'),
                onPressed: () {
                  QuickBlue.discoverServices(widget.deviceId);
                },
              ),
            ],
          ),
          TextField(
            controller: serviceUUID,
            decoration: const InputDecoration(
              labelText: 'ServiceUUID',
            ),
          ),
          TextField(
            controller: characteristicUUID,
            decoration: const InputDecoration(
              labelText: 'CharacteristicUUID',
            ),
          ),
          TextButton(
            child: const Text('send request'),
            onPressed: () {
              QuickBlue.readValue(
                widget.deviceId,
                serviceUUID.text,
                characteristicUUID.text,
              );
            },
          ),
          TextButton(
            child: const Text('requestMtu'),
            onPressed: () async {
              var mtu = await QuickBlue.requestMtu(
                  widget.deviceId, WOODEMI_MTU_WUART);
              print('requestMtu $mtu');
            },
          ),
        ],
      ),
    );
  }
}
