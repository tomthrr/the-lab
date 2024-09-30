import { resolve } from 'path'
import glsl from 'vite-plugin-glsl'


export default {
  root: 'src/',
  publicDir: '../static/',
  base: './',
  server:
    {
      port: 3000,
      host: true, // Open to local network and display URL
      open: !('SANDBOX_URL' in process.env || 'CODESANDBOX_HOST' in process.env) // Open if it's not a CodeSandbox
    },
  build:
    {
      outDir: '../dist',
      emptyOutDir: true,
      sourcemap: true,
      rollupOptions: {
        input: {
          main: resolve(__dirname, 'src/index.html'),
          simpleGeometries: resolve(__dirname, 'src/simple-geometries.html'),
          loadTextures: resolve(__dirname, 'src/load-textures.html'),
          portfolioText: resolve(__dirname, 'src/3d-text.html'),
          addLights: resolve(__dirname, 'src/add-lights.html'),
          addShadows: resolve(__dirname, 'src/add-shadows.html'),
          hauntedHouse: resolve(__dirname, 'src/create-scene-haunted-house.html'),
          particlesWave: resolve(__dirname, 'src/particles-wave.html'),
          galaxyGenerator: resolve(__dirname, 'src/galaxy-generator.html'),
          scrollBase: resolve(__dirname, 'src/scroll-base.html'),
          addPhysics: resolve(__dirname, 'src/add-physics.html'),
          importModels: resolve(__dirname, 'src/import-models.html'),
          raycaster: resolve(__dirname, 'src/raycaster.html'),
          firstShader: resolve(__dirname, 'src/first-shader.html'),
          trheeCube: resolve(__dirname, 'src/3d-cube.html'),
          scrollEarth: resolve(__dirname, 'src/scroll-earth.html'),
          dispersText: resolve(__dirname, 'src/disperse-text.html'),
          mouseCircle: resolve(__dirname, 'src/mouse-circle.html'),
          magneticButton: resolve(__dirname, 'src/magnetic-button.html'),
          textParallax: resolve(__dirname, 'src/text-parallax.html'),
          stickyFooter: resolve(__dirname, 'src/fixed-footer.html'),
          showcaseModel: resolve(__dirname, 'src/showcase-model.html'),
          realisticRenderer: resolve(__dirname, 'src/realistic-renderer.html'),
          sectionsParallax: resolve(__dirname, 'src/sections-parallax.html'),
          galleryExpansion: resolve(__dirname, 'src/gallery-expansion.html'),
          cardsSlider: resolve(__dirname, 'src/cards-slider.html'),
          objectFollow: resolve(__dirname, 'src/object-follow.html'),
          raggingSea: resolve(__dirname, 'src/ragging-sea.html'),
          piano: resolve(__dirname, 'src/piano.html'),
          coffeeSmoke: resolve(__dirname, 'src/coffee-smoke.html'),
          hologram: resolve(__dirname, 'src/hologram.html'),
        }
      },
    },
  plugins: [
    glsl()
  ]
}