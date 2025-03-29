import 'dart:io';

String fixture(String name) =>
    File('test/features/notes/fixtures/$name').readAsStringSync();
