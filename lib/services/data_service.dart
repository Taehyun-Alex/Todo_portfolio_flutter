import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ts_todo_portfolio/models/todo.dart';
import 'package:ts_todo_portfolio/services/api_datasource.dart';
import 'package:ts_todo_portfolio/services/hive_datasource.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';
import 'package:ts_todo_portfolio/services/sql_datasource.dart';

class DataService implements IDatasource {
  late IDatasource _remote;
  late IDatasource _local;

  // Initialize the appropriate data source based on internet connection and platform
  static Future<DataService> create() async {
    final DataService dataService = DataService();
    await dataService._initializeDataSource();
    return dataService;
  }

  Future _initializeDataSource() async {
    // Check if there is an internet connection

    if (kIsWeb) {
      // If on the web, use Hive for local storage
      await Hive.initFlutter();
      _local = await HiveDataSource.createAsync();
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // If on a desktop platform with no internet, use HiveDataSource
      await Hive.initFlutter();
      _local = await HiveDataSource.createAsync();
    } else {
      // If on a mobile platform with no internet, use SQLDataSource
      _local = await SQLDataSource.createAsync();
    }

    _remote = await ApiDataSource.createAsync();
  }

  @override
  Future<List<Todo>> browse() async {
    if (await isConnected()) {
      return _remote.browse();
    } else {
      return _local.browse();
    }
  }

  @override
  Future<Todo?> read(String id) async {
    if (await isConnected()) {
      return _remote.read(id);
    } else {
      return _local.read(id);
    }
  }

  @override
  Future<bool> add(Todo model) async {
    if (await isConnected()) {
      return _remote.add(model);
    } else {
      return _local.add(model);
    }
  }

  @override
  Future<bool> edit(Todo model) async {
    if (await isConnected()) {
      return _remote.edit(model);
    } else {
      return _local.edit(model);
    }
  }

  @override
  Future<bool> delete(Todo model) async {
    if (await isConnected()) {
      return _remote.delete(model);
    } else {
      return _local.delete(model);
    }
  }

  Future<bool> isConnected() async {
    List<ConnectivityResult> connectivityResults =
        await Connectivity().checkConnectivity();
    return connectivityResults.isNotEmpty &&
        !connectivityResults.contains(ConnectivityResult.none);
  }
}