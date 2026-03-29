import 'dart:io';

abstract class Failure {
  final String errMessage;
  const Failure(this.errMessage);
}

class ServerFailure extends Failure {
  const ServerFailure(super.errMessage);


  factory ServerFailure.fromResponse(
      int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      final message =
          response is Map && response['error'] != null
              ? response['error']['message']
              : 'There was an error, please try again';

      return ServerFailure(message);
    } else if (statusCode == 404) {
      return const ServerFailure(
          'Your request not found, Please try later!');
    } else if (statusCode == 500) {
      return const ServerFailure(
          'Internal Server error, Please try later');
    } else {
      return const ServerFailure(
          'Opps There was an Error, Please try again');
    }
  }
}