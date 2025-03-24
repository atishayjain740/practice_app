import 'dart:io';

String fixture(String name) =>
    File('test/features/counter/fixtures/$name').readAsStringSync();
