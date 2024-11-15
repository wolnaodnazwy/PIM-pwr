const { getDefaultConfig } = require('expo/metro-config');

module.exports = (async () => {
  const defaultConfig = await getDefaultConfig(__dirname);

  // Modyfikacja domyślnej konfiguracji, aby obsługiwała pliki SVG
  defaultConfig.resolver.assetExts = defaultConfig.resolver.assetExts.filter(ext => ext !== 'svg');
  defaultConfig.resolver.sourceExts = [...defaultConfig.resolver.sourceExts, 'svg'];

  defaultConfig.transformer = {
    ...defaultConfig.transformer,
    babelTransformerPath: require.resolve('react-native-svg-transformer'),
    assetPlugins: ['expo-asset/tools/hashAssetFiles'],
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: false,
      },
    }),
  };

  return defaultConfig;
})();
