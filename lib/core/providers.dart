import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

import '../constants/constants.dart';

final pocketbaseClientProvider = Provider<PocketBase>(
  (ref) {
    return PocketBase(PocketBaseConstants.endPoint);
  },
);

final pocketbaseProvider = Provider<PocketBase>(
  (ref) {
    final client = ref.watch(pocketbaseClientProvider);
    return client;
  },
);
