import 'dart:io';

String fixture(String name) =>
    File('test/features/weather/fixtures/$name').readAsStringSync();
