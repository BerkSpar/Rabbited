import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rabbited/app/shared/models/collection.dart';
import 'package:rabbited/app/shared/models/user.dart';
import 'package:rabbited/app/utils/links.dart';

part 'bunnie_api_repository.g.dart';

@Injectable()
class BunnieApiRepository extends Disposable {
  Dio client = Dio();
  BaseOptions options = BaseOptions(
    baseUrl: bunnie_api_url,
  );

  set token(String token) {
    options.headers['x-access-token'] = token;
  }

  BunnieApiRepository() {
    client.options = options;
    client.options.responseType = ResponseType.json;
  }

  Future<Either<Exception, User>> signIn(User info) async {
    try {
      final response = await client.post('/user/signin', data: {
        "username": info.username,
        "password": info.password,
      });

      final user = User.fromJson(response.data);

      options.headers['x-access-token'] = user.token;

      return Right(user);
    } catch (e) {
      return Left(e);
    }
  }

  Future<Either<Exception, List<Collection>>> getCollections() async {
    try {
      final response = await client.get('/collections');

      List<Collection> collections = <Collection>[];

      response.data.forEach((collection) {
        collections.add(Collection.fromJson(collection));
      });

      return Right(collections);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  void dispose() {}
}
