import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ts_todo_portfolio/services/api_datasource.dart';
import 'package:ts_todo_portfolio/services/hive_datasource.dart';
import 'package:ts_todo_portfolio/services/i_datasource.dart';
import 'package:ts_todo_portfolio/services/sql_datasource.dart';

import '../models/todo.dart';

class DataService implements IDataSource{
  late IDataSource _local;
  late IDataSource _remote;

  static Future<DataService> createAsync() async {
    DataService service = DataService();
    await service.initialise();
    return service;
  }

  Future initialise() async {
    // what platform we are on?
    Future<IDataSource> future = APIDataSource.createAsync();
    if (kIsWeb){
      //Web (Or anything else)
      //Local: Hive
      _local = await HiveDatasource.createAsync();
      //Remote: API
    }else {
      //Mobile
      //Local: SQL 
      _local = await SQLDataSource.createAsync();
    }
    //Remote: API
    _remote = await future;
  }
  Future<bool> isConnected() async {
    List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity();
    return !connectivityResults.contains(ConnectivityResult.none);
    
  }
  @override
  Future<bool> add(Todo model) async {
    if (await isConnected()){
      return _remote.add(model);
    } else{
      return _local.add(model);
    }
  }

  @override
  Future<List<Todo>> browse() async{
    if (await isConnected()){
      return _remote.browse();
    } else{
      return _local.browse();
    }
  }

  @override
  Future<bool> delete(Todo model) async{
    if (await isConnected()){
      return _remote.delete(model);
    } else{
      return _local.delete(model);
    }
  }

  @override
  Future<bool> edit(Todo model) async{
    if (await isConnected()){
      return _remote.edit(model);
    } else{
      return _local.edit(model);
    }
  }

  @override
  Future<Todo?> read(String id) {
    // TODO: implement read
    throw UnimplementedError();
  }
}