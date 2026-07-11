import 'package:app/core/hooks/use_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Returns a controller + debounced value
class DebouncedSearch {
  final TextEditingController controller;
  final ValueNotifier<String> value;
  final String debounced;

  DebouncedSearch({
    required this.controller,
    required this.value,
    required this.debounced,
  });
}

DebouncedSearch useDebouncedSearch(
    {Duration delay = const Duration(milliseconds: 500)}) {
  final controller = useTextEditingController();
  final value = useState('');
  final debounced = useDebounce(value.value, delay);

  // sync controller -> value
  useEffect(() {
    void listener() => value.value = controller.text;
    controller.addListener(listener);
    return () => controller.removeListener(listener);
  }, [controller]);

  return DebouncedSearch(
      controller: controller, value: value, debounced: debounced);
}
