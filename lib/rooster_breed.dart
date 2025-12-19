class RoosterBreed {
  final String name;
  final String scientificName;
  final String imageUrl;
  final String origin;
  final String description;
  final List<String> characteristics;

  const RoosterBreed({
    required this.name,
    required this.scientificName,
    required this.imageUrl,
    required this.origin,
    required this.description,
    required this.characteristics,
  });

  static const List<RoosterBreed> allBreeds = [
    RoosterBreed(
      name: 'Appenzeller Spitzhauben',
      scientificName: 'Gallus gallus domesticus',
      imageUrl: 'assets/images/Appenzeller Spitzhauben.jpg',
      origin: 'Switzerland',
      description: 'A rare Swiss breed known for its distinctive forward-pointing crest and striking spangled plumage. Excellent forager and cold-hardy.',
      characteristics: [
        'Distinctive forward-pointing crest',
        'Active and excellent forager',
        'Hardy in cold climates',
        'Medium-sized with spangle pattern',
      ],
    ),
    RoosterBreed(
      name: 'Ayam Cemani',
      scientificName: 'Gallus gallus domesticus',
      imageUrl: 'assets/images/Ayami Cerami.jpg',
      origin: 'Indonesia',
      description: 'A rare Indonesian breed with complete black pigmentation including feathers, skin, bones, and organs. Considered mystical and sacred.',
      characteristics: [
        'Completely black pigmentation',
        'Black feathers, skin, and internal organs',
        'Considered sacred in Indonesian culture',
        'Medium-sized with upright posture',
      ],
    ),
    RoosterBreed(
      name: 'Dominique',
      scientificName: 'Gallus gallus domesticus',
      imageUrl: 'assets/images/dominique.jpg',
      origin: 'United States',
      description: 'America\'s oldest chicken breed featuring elegant black and white barred plumage. Hardy dual-purpose bird with a rose comb.',
      characteristics: [
        'Black and white barred plumage',
        'Rose comb for cold hardiness',
        'Dual-purpose breed (eggs and meat)',
        'America\'s oldest chicken breed',
      ],
    ),
    RoosterBreed(
      name: 'Frizzle',
      scientificName: 'Gallus gallus domesticus',
      imageUrl: 'assets/images/frizzle.jpg',
      origin: 'Southeast Asia',
      description: 'An ornamental breed with unique curled feathers that curve outward, giving a fluffy, ruffled appearance. Gentle and docile.',
      characteristics: [
        'Feathers curl outward and backward',
        'Unique frizzled appearance',
        'Gentle and docile temperament',
        'Popular as ornamental birds',
      ],
    ),
    RoosterBreed(
      name: 'Onagadori',
      scientificName: 'Gallus gallus domesticus',
      imageUrl: 'assets/images/Onagadori.jpg',
      origin: 'Japan',
      description: 'A legendary Japanese breed with non-molting tail feathers that can grow over 20 feet long. A protected Natural Monument of Japan.',
      characteristics: [
        'Extremely long tail feathers (up to 27 feet)',
        'Non-molting tail gene',
        'Japanese Special Natural Monument',
        'Requires special housing and care',
      ],
    ),
    RoosterBreed(
      name: 'Phoenix',
      scientificName: 'Gallus gallus domesticus',
      imageUrl: 'assets/images/Phoenix.jpg',
      origin: 'Germany (from Japanese stock)',
      description: 'An elegant German breed developed from Japanese stock, featuring long graceful tail feathers and an alert, active personality.',
      characteristics: [
        'Long flowing tail feathers',
        'Elegant and graceful appearance',
        'Active and alert personality',
        'European development of Japanese breeds',
      ],
    ),
    RoosterBreed(
      name: 'Polish',
      scientificName: 'Gallus gallus domesticus',
      imageUrl: 'assets/images/polish.jpg',
      origin: 'Netherlands/Poland',
      description: 'A striking ornamental breed with a dramatic rounded crest of feathers on top of its head. Known for gentle temperament and beauty.',
      characteristics: [
        'Large, rounded crest of feathers',
        'V-shaped comb or no comb',
        'Gentle and calm demeanor',
        'Excellent ornamental breed',
      ],
    ),
    RoosterBreed(
      name: 'Sebright',
      scientificName: 'Gallus gallus domesticus',
      imageUrl: 'assets/images/Sebright Rooster.jpg',
      origin: 'England',
      description: 'A true bantam breed from England with stunning laced plumage pattern. Compact, confident, and one of the oldest bantam breeds.',
      characteristics: [
        'True bantam (no large fowl counterpart)',
        'Laced plumage pattern',
        'Rose comb and clean legs',
        'Active and confident personality',
      ],
    ),
    RoosterBreed(
      name: 'Serama',
      scientificName: 'Gallus gallus domesticus',
      imageUrl: 'assets/images/Serama.jpg',
      origin: 'Malaysia',
      description: 'The world\'s smallest chicken breed from Malaysia. Known for its proud vertical posture, friendly nature, and weighing under 1 pound.',
      characteristics: [
        'World\'s smallest chicken breed',
        'Upright, vertical posture',
        'Friendly and people-oriented',
        'Weighs less than 1 pound',
      ],
    ),
    RoosterBreed(
      name: 'Turken',
      scientificName: 'Gallus gallus domesticus',
      imageUrl: 'assets/images/turken.jpg',
      origin: 'Transylvania/Germany',
      description: 'A unique breed with a naturally featherless neck resembling a turkey. Heat-tolerant, hardy, and excellent for dual-purpose farming.',
      characteristics: [
        'Distinctive naked neck (no feathers)',
        'Heat tolerant due to bare neck',
        'Dual-purpose breed',
        'Also known as Naked Neck',
      ],
    ),
  ];
}