import 'package:cjylostark/dio/base_dio_api.dart';
import 'package:cjylostark/feature/armories/domain/character_equipment.dart';
import 'package:cjylostark/feature/armories/domain/character_profile.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final armoriesRepositoryProvider = Provider.autoDispose<ArmoriesRepository>((
  ref,
) {
  return ArmoriesRepository(ref);
});

class ArmoriesRepository {
  final Ref ref;

  ArmoriesRepository(this.ref);

  Future<CharacterProfile> getProfiles(String characterName) async {
    Response response = await ref
        .read(dioProvider)
        .dio
        .get('/armories/characters/$characterName/profiles');
    final profile = CharacterProfile.fromJson(response.data);
    return profile;
  }

  Future<List<CharacterEquipment>> getEquipment(String characterName) async {
    Response response = await ref
        .read(dioProvider)
        .dio
        .get('/armories/characters/$characterName/equipment');
    final equipment = (response.data as List)
        .map((e) => CharacterEquipment.fromJson(e as Map<String, dynamic>))
        .toList();
    return equipment;
  }
}
