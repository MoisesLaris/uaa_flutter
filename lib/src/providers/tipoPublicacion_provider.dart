

import 'package:form_validation/enums/enum_apis.dart';
import 'package:form_validation/src/models/postType_model.dart';
import 'package:form_validation/src/models/response_model.dart';
import 'package:form_validation/src/providers/father_class.dart';

import 'api_provider.dart';

class PostTypeProvider extends FatherClass{
  final apiProvider = new ApiProvider();


  Future<ResponseModel> newPostType(String nombre, String descripcion) async{
    final auth_data = {
      'nombre': nombre,
      'descripcion': descripcion
    };
    Map<String,dynamic> res = await apiProvider.post_api(auth_data,ApisEnum.newPostType);
    return this.reponseModelPostApi(res);
  }

  Future<ResponseModel> editPostType(String id, String nombre, String descripcion) async{
    final auth_data = {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion
    };
    Map<String,dynamic> res = await apiProvider.post_api(auth_data,ApisEnum.editPostType);
    return this.reponseModelPostApi(res);
  }

  Future<ResponseModel> deletePostType(String id) async{
    final auth_data = {
      'id': id,
    };
    Map<String,dynamic> res = await apiProvider.post_api(auth_data,ApisEnum.deletePostType);
    return this.reponseModelPostApi(res);
  }

  Future<List<PostType>> getPostTypes() async {
    Map<String,dynamic> res = await apiProvider.get_api([],ApisEnum.getPostTypes);
    print(res);
    final listPostTypes = PostTypes.fromJsonList(res['tipos']);
    return listPostTypes.items;
  }


}