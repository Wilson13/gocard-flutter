extension StringExtension on String {
    String capitalize() {
      return this.split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
    }
}