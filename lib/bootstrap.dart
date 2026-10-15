import 'services/location_service.dart';
import 'services/notification_service.dart';

/// استدعِها في main() بعد WidgetsFlutterBinding.ensureInitialized():
///   await bootstrapAdhan();
/// ثم runApp(...)
Future<void> bootstrapAdhan() async {
  await NotificationService.init();
  await NotificationService.requestPermissions();
  final loc = await LocationService.get();
  await NotificationService.scheduleAdhan(lat: loc.lat, lng: loc.lng);
}
