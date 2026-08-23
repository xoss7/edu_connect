class AppDimensions {
  const AppDimensions._();

  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 32;

  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 16;
  static const double radiusPill = 999;

  static const double illustrationSize = 220;

  // Home dashboard feature tiles. childAspectRatio leaves the grid cells
  // a bit taller than wide so there's room for the title below the image
  // without the fixed padding/text height overflowing on narrow phones.
  static const double homeTileAspectRatio = 0.85;
  static const double homeLargeTileHeight = 240;
}
