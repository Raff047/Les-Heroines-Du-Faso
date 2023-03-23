String getTimeDifference(DateTime createdAt) {
  final now = DateTime.now();
  final difference = now.difference(createdAt);

  if (difference.inSeconds < 60) {
    // Show seceonds
    return '${difference.inSeconds} sec';
  } else if (difference.inMinutes < 60) {
    // Show minutes
    return '${difference.inMinutes} min';
  } else if (difference.inHours < 24) {
    // show hours
    return '${difference.inHours} h';
  } else {
    // show days
    return '${difference.inDays} j';
  }
}
