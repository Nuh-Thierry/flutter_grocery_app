class StepsContent {
  String text;
  String image;
  String title;
  String description;
  String description1;
  String buttonl;

  StepsContent(
      {required this.description,
      required this.description1,
      required this.image,
      required this.buttonl,
      required this.title,
      required this.text});
}

List<StepsContent> contents = [
  StepsContent(
    buttonl: 'Setup fridge',
    text: 'Step 1/3',
    description: 'Start now!',
    description1: '',
    image: 'assets/images/fridge.png',
    title: 'Setup your fridge',
  ),
  StepsContent(
    buttonl: 'Setup pantry',
    text: 'Step 2/3',
    description1: 'oil,flour, etc.',
    description: 'For dry fooditems such as rice',
    image: 'assets/images/board.png',
    title: 'Setup your pantry',
  ),
  StepsContent(
    buttonl: 'Finish setup',
    text: 'Step 3/3',
    description1: 'oil,flour, etc.',
    description: 'For dry fooditems such as rice',
    image: 'assets/images/otherItems.png',
    title: 'Setup your pantry',
  ),
];
