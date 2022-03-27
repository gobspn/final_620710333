class Game {
  final String image_url;
  final String answer;
  final List choices;

  Game({
    required this.image_url,
    required this.answer,
    required this.choices,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      image_url:  json["image_url"],
      answer:  json["answer"],
      choices:   (json['choices'] as List).map((choices) => choices).toList() ,
    );
  }
}