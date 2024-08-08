// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MovieForSavedAdapter extends TypeAdapter<MovieForSaved> {
  @override
  final int typeId = 1;

  @override
  MovieForSaved read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MovieForSaved(
      movieName: fields[0] as String,
      moviePoster: fields[1] as String,
      movieYear: fields[2] as String,
      isSaved: fields[3] as bool,
      kinopoiskId: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieForSaved obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.movieName)
      ..writeByte(1)
      ..write(obj.moviePoster)
      ..writeByte(2)
      ..write(obj.movieYear)
      ..writeByte(3)
      ..write(obj.isSaved)
      ..writeByte(4)
      ..write(obj.kinopoiskId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieForSavedAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
