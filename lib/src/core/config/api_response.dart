class ApiResponse<T> {
  ApiResponse({
    this.data,
    this.message,
    required this.status,
  });

  T? data;
  String? message;
  bool status;
}