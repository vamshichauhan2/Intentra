import "dart:convert";
import "package:http/http.dart" as http; 


class DeletebyTaskId {
    static const baseUrl="http://127.0.0.1:8000";

      Future<bool> deleteRequestedByTaskId(int id)async{
        try{
          final response=await http.delete( 
          Uri.parse('$baseUrl/api/todos/task/delete/$id'),
          headers:{
            "Content-Type":"application-json",
          },

          );
          return response.statusCode==200;

           
          

        }catch(_){
          return false;

        }

      }

}