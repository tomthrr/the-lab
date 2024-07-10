import { resolve } from 'path'
import glsl from 'vite-plugin-glsl'


export default {
  root: 'src/',
  publicDir: '../static/',
  base: './',
  server:
    {
      port: 3100,
      host: true, // Open to local network and display URL
      open: !('SANDBOX_URL' in process.env || 'CODESANDBOX_HOST' in process.env) // Open if it's not a CodeSandbox
    },
  build:
    {
      outDir: '../dist', // Output in the dist/ folder
      emptyOutDir: true, // Empty the folder first
      sourcemap: true, // Add sourcemap
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
        }
      },
    },
  plugins: [
    glsl()
  ]
}