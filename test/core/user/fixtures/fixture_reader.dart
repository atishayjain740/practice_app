import 'dart:io';

String fixture(String name) =>
    File('test/core/user/fixtures/$name').readAsStringSync();
