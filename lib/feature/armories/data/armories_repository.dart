import 'package:cjylostark/dio/base_dio_api.dart';
import 'package:cjylostark/feature/armories/domain/ark_grid_model.dart';
import 'package:cjylostark/feature/armories/domain/ark_passive_model.dart';
import 'package:cjylostark/feature/armories/domain/character_equipment.dart';
import 'package:cjylostark/feature/armories/domain/character_profile.dart';
import 'package:cjylostark/feature/armories/domain/engravings_model.dart';
import 'package:cjylostark/feature/armories/domain/gem_model.dart';
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

  Future<GemResponse> getGem(String characterName) async {
    Response response = await ref
        .read(dioProvider)
        .dio
        .get('/armories/characters/$characterName/gems');
    final gemResponse = GemResponse.fromJson(response.data);
    return gemResponse;
  }

  Future<EngravingsModel> getEngravings(String characterName) async {
    Response response = await ref
        .read(dioProvider)
        .dio
        .get('/armories/characters/$characterName/engravings');
    final engravings = EngravingsModel.fromJson(response.data);
    return engravings;
  }

  Future<ArkPassiveModel> getArkPassive(String characterName) async {
    Response response = await ref
        .read(dioProvider)
        .dio
        .get('/armories/characters/$characterName/arkpassive');
    final arkPassive = ArkPassiveModel.fromJson(response.data);
    return arkPassive;
  }

  Future<ArkGrid> getArkGrid(String characterName) async {
    Response response = await ref
        .read(dioProvider)
        .dio
        .get('/armories/characters/$characterName/arkgrid');
    final arkGrid = ArkGrid.fromJson(response.data);
    return arkGrid;
  }
}
