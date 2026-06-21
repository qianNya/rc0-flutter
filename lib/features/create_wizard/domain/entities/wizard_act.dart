class WizardAct {
  const WizardAct({
    required this.id,
    required this.title,
    required this.scenes,
  });

  final String id;
  final String title;
  final List<WizardScene> scenes;
}

class WizardScene {
  const WizardScene({
    required this.id,
    required this.title,
    this.description = '',
  });

  final String id;
  final String title;
  final String description;
}
