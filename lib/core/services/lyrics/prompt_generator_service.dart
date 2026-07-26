import '../../../models/scene.dart';
import '../../../models/character.dart';

/// Turns a Scene + Character Memory into a single cinematic AI video prompt.
class PromptGeneratorService {
  String buildPrompt({
    required Scene scene,
    required List<CharacterProfile> characters,
    String visualStyle = 'ultra cinematic Pixar-quality 3D animation',
    bool christianMode = false,
  }) {
    final characterClauses =
        characters.where((c) => scene.characterIds.contains(c.id)).map((c) => c.toPromptClause()).join('; ');

    final objectClause = scene.objects.isNotEmpty ? ', featuring ${scene.objects.join(', ')}' : '';

    final buffer = StringBuffer()
      ..write('$visualStyle of ')
      ..write(characterClauses.isNotEmpty ? characterClauses : 'the scene\'s subject')
      ..write(scene.location.isNotEmpty ? ', set in ${scene.location}' : '')
      ..write(scene.timeOfDay.isNotEmpty ? ' during ${scene.timeOfDay}' : '')
      ..write(objectClause)
      ..write(scene.mood.isNotEmpty ? ', mood: ${scene.mood}' : '')
      ..write(', volumetric light rays, ultra detailed, smooth camera dolly, ')
      ..write('realistic cloth simulation, cinematic composition, masterpiece');

    if (christianMode) {
      buffer.write(', reverent and uplifting tone, tasteful biblical symbolism');
    }

    return buffer.toString();
  }
}
