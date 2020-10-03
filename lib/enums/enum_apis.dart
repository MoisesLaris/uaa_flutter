
class ApisEnum{
  //Url
  // static const url = 'https://dry-anchorage-61118.herokuapp.com';
  // static const url = 'http://34.125.72.116:3800';
  static const url = 'http://192.168.15.14:3800';

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

  //Post 

  static const newPost = '/api/publicacion/newPublicacion';
  static const likePost = '/api/publicacion/likePost';

  static const getPosts = '/api/publicacion/preguntas/?';
  static const getFavoriteQuestions = '/api/publicacion/preguntasFavoritas/?';
  static const getMyQuestions = '/api/publicacion/misPreguntas/?';

  static const getPostAdmin = '/api/publicacion/publicaciones/:page?';
  static const editPostAdmin = '/api/publicacion/editarPublicacion';

  static const getPostImage = '/api/publicacion/getImage/';

  //Comentarios

  static const getComment = '/api/comentarios/idPost/?/page/?';
  static const newComment = '/api/comentarios/newComentario';

}