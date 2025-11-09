import 'dart:ffi';

import 'package:get/get.dart';

import '../models/booking_model.dart';
import '../models/booking_new_model.dart';
import '../models/booking_status_model.dart';
import '../models/coupon_model.dart';
import '../models/e_provider_model.dart';
import '../models/review_model.dart';
import '../modules/bookings/data/body/e_way_initiate_body.dart';
import '../modules/bookings/data/responses/eway_initeate_sesponse.dart';
import '../providers/laravel_provider.dart';

class BookingRepository {
  LaravelApiClient _laravelApiClient;

  BookingRepository() {
    this._laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<Booking>> all(String statusId, {int page, orderId}) {
    return _laravelApiClient.getBookings(statusId, page, orderId);
  }

  Future<List<BookingNew>> allNew({int page, orderId}) {
    return _laravelApiClient.getBookingsNew(page, orderId);
  }

  Future<List<BookingNew>> getPendingBookings({int page, orderId}) {
    return _laravelApiClient.getPendingBookings(page, orderId);
  }

  Future<List<BookingStatus>> getStatuses() {
    return _laravelApiClient.getBookingStatuses();
  }

  Future<Booking> get(String bookingId) {
    return _laravelApiClient.getBooking(bookingId);
  }
  Future<BookingNew> getBookingDetails(String bookingId) {
    return _laravelApiClient.getBookingDetails(bookingId);
  }

  Future<Booking> add(Booking booking) {
    return _laravelApiClient.addBooking(booking);
  }

  Future<Booking> update(Booking booking) {
    return _laravelApiClient.updateBooking(booking);
  }
  Future<Booking> updateBookingNew(Booking booking) {
    return _laravelApiClient.updateBookingNew(booking);
  }

  Future<bool> sendBookingOtp(String bookingId) {
    return _laravelApiClient.sendBookingOtp(bookingId);
  }

  Future<Booking> updateBookingStatusWithOtp(Booking booking, String otpCode) {
    return _laravelApiClient.updateBookingStatusWithOtp(booking, otpCode);
  }

  Future<Coupon> coupon(Booking booking) {
    return _laravelApiClient.validateCoupon(booking);
  }

  Future<Review> addReview(Review review) {
    return _laravelApiClient.addReview(review);
  }

  Future<EwayInitiateResponse> initiateEway(var bodyData) {
    return _laravelApiClient.initiateEway(bodyData);
  }

}
