import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';

T useDebounce<T>(T value, Duration duration) {
  final debounced = useState(value);
  useEffect(() {
    final timer = Timer(duration, () {
      debounced.value = value;
    });
    return timer.cancel;
  }, [value]);
  return debounced.value;
}
