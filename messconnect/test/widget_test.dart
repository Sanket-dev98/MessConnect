// This is a basic Flutter widget test, adapted for the MessConnect PART 1
// scaffold. It verifies the app boots under Riverpod and renders the
// responsive home screen without errors.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:messconnect/main.dart';

void main() {
  testWidgets('MessConnect app boots and shows home', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MessConnectApp()));

    // The app bar title should be present.
    expect(find.text('MessConnect'), findsWidgets);

    // The placeholder welcome content should render.
    expect(find.text('Find your mess'), findsOneWidget);
  });
}
