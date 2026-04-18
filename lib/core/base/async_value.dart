sealed class AsyncValue<T> {
  AsyncValue();

  factory AsyncValue.inititial() = AsyncInitial<T>;
  factory AsyncValue.loading() = AsyncLoading<T>;
  factory AsyncValue.failure(String msg) = AsyncFailure<T>;
  factory AsyncValue.success(T value) = AsyncSuccess<T>;
}

final class AsyncInitial<T> extends AsyncValue<T> {}

final class AsyncLoading<T> extends AsyncValue<T> {}

final class AsyncFailure<T> extends AsyncValue<T> {
  final String msg;

  AsyncFailure(this.msg);
}

final class AsyncSuccess<T> extends AsyncValue<T> {
  final T value;

  AsyncSuccess(this.value);
}
