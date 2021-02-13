import 'package:github_users/src/model/model_base.dart';
import 'package:github_users/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class BlocBase<T extends ModelBase> {
  final repository = Repository();

  // The fetcher will add the data received from the server
  // in the UsersModel object and pass it to the UI screen as a stream.
  final fetcher = PublishSubject<T>();

  dispose() {
    fetcher.close();
  }
}
