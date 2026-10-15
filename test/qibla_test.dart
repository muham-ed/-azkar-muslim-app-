import 'package:flutter_test/flutter_test.dart';
import 'package:azkar_muslim/utils/qibla.dart';

void main() {
  test('Cairo ~136.1', () {
    expect(qiblaBearing(30.0444, 31.2357), closeTo(136.1, 0.3));
  });
  test('Alexandria ~135.4', () {
    expect(qiblaBearing(31.2001, 29.9187), closeTo(135.4, 0.3));
  });
  test('London ~119', () {
    expect(qiblaBearing(51.5074, -0.1278), closeTo(119.0, 0.5));
  });
  test('New York ~58.5', () {
    expect(qiblaBearing(40.7128, -74.0060), closeTo(58.5, 0.5));
  });
}
