import react from "@vitejs/plugin-react";
import vike from "vike/plugin";
import { defineConfig, transformWithEsbuild } from "vite";
import path, { resolve } from "path";
const root = `${__dirname}/..`;
const client = path.join(root, "client");
import { viteCommonjs } from "@originjs/vite-plugin-commonjs";

// export default defineConfig(() => ({
//   plugins: [react(), vike()],
//   esbuild: {
//     loader: "jsx",
//     include: ["../client/src/**/*.js", "./**/*.js"],
//   },
// }));

export default defineConfig({
  plugins: [
    {
      name: "treat-js-files-as-jsx",
      async transform(code, id) {
        if (!id.match(/src\/.*\.js$/)) return null;

        // Use the exposed transform from vite, instead of directly
        // transforming with esbuild
        return transformWithEsbuild(code, id, {
          loader: "jsx",
          jsx: "automatic",
        });
      },
    },
    react(),
    viteCommonjs(),
    vike(),
  ],
  resolve: {
    alias: {
      "~": path.join(client, "src/"),
      $fonts: resolve("public/fonts"),
    },
  },
  optimizeDeps: {
    force: true,
    esbuildOptions: {
      loader: {
        ".js": "jsx",
      },
    },
  },
});
