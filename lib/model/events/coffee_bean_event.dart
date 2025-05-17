final class CoffeeBeanSavedEvent {
  final String senderId;
  final int id;
  final bool isSaved;

  const CoffeeBeanSavedEvent({
    required this.senderId,
    required this.id,
    required this.isSaved,
  });
}
