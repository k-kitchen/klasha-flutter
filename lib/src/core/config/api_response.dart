class ApiResponse<T> {
  ApiResponse({
    this.data,
    this.message,
    this.status,
  });

  T data;
  String message;
  bool status;
}