import 'package:fpdart/fpdart.dart';

import 'failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;
typedef StreamEither<T> = Stream<Either<Failure, List<T>>>;
// typedef StreamVoid = StreamEither<void>;
