import 'dart:io';

String fixture(String name) =>
    File('test/features/auth/fixtures/$name').readAsStringSync();
