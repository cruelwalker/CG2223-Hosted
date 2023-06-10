const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  // https://cli.vuejs.org/config/#devserver-proxy
  devServer: {
    port: 8081,
    proxy: {
      '/api': {
        target: 'http://localhost:56192',
        ws: true,
        changeOrigin: true
      }
    }
  },
  transpileDependencies: true
})
