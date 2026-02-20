import 'dart:convert';
import 'package:http/http.dart' as http ;


class DeleteFeatureByPackage {
     static const String baseUrl = "http://127.0.0.1:8000";

     Future<bool> deletePackage(String packageName) async{
        try{
             final response=await http.delete(
                Uri.parse("$baseUrl/api/delete/package/$packageName"),
                headers:{
                    "Content-Type":"application/json",
                    },
                );
            return response.statusCode==200;

        }catch(_){
            return false;

        }
       
     }
}