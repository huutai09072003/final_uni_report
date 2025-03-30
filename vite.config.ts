import react from '@vitejs/plugin-react';
import { defineConfig } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';

export default defineConfig({
  plugins: [
    react(),
    RubyPlugin(),
  ],
  server: {
    host: '0.0.0.0', // Cho phép truy cập từ ngoài localhost (hữu ích với ngrok)
    port: 5173,      // Port mặc định của Vite
    proxy: {
      // Chuyển hướng các request API tới Rails
      '/users': {
        target: 'http://localhost:3000', // Backend Rails
        changeOrigin: true,
        secure: false,
      },
    },
  },
});