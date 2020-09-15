
class ApisEnum{
  //Url
  static const url = 'https://dry-anchorage-61118.herokuapp.com';
  // static const url = 'http://192.168.15.13:3800';

  //Auth
  static const login = '/api/usuario/login';
  static const verifySession = '/api/usuario/verifySession';

  //Users
  static const new_user = '/api/usuario/newUser';
  static const new_user_admin = '/api/usuario/newUserAdmin';
  static const user_uploadImage = '/api/usuario/uploadImage/?';
  static const getImage = '/api/usuario/getImage/';
  static const getUsers = '/api/usuario/getUsuarios';
  static const editUser = '/api/usuario/editUser';


  //Post Type

  static const getPostTypes = '/api/tipo/getTipos';
  static const getPostTypeById = '/api/tipo/getTipo/?';
  static const newPostType = '/api/tipo/newTipo';
  static const editPostType = '/api/tipo/editTipo';
  static const deletePostType = '/api/tipo/deleteTipo';
}