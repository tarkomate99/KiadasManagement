import 'package:flutter/cupertino.dart';

class TextProvider extends ChangeNotifier{

  String? search;
  String? name;
  String? path;

  getText(String text){
    if(text!=null){
      search=text;
    }
    notifyListeners();
  }
  setText(){
    if(search!=null){
      return search;
    }
    return '';
  }

  getName(String text){
    if(text!=null){
      name=text;
    }
    notifyListeners();
  }
  setName(){
    if(name!=null){
      return name;
    }
    return '';
  }
  getPath(String text){
    if(text!=null){
      path=text;
    }
    notifyListeners();
  }
  setPath(){
    if(path!=null){
      return path;
    }
    return '';
  }
}