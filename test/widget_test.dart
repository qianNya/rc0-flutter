import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rc0_flutter/app/app.dart';

void main() {
  testWidgets('RcoApp renders explore tab', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: RcoApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('rco'), findsOneWidget);
    expect(find.text('探索'), findsOneWidget);
  });
}
