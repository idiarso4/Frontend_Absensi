abstract class Result<T> {
  const Result();
}

class DataSuccess<T> extends Result<T> {
  final T? data;

  const DataSuccess(this.data);
}

class DataFailed<T> extends Result<T> {
  final String? message;

  const DataFailed(this.message);
}
