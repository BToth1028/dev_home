// ESLint v9 Flat Config
import js from "@eslint/js";
import pluginImport from "eslint-plugin-import";

export default [
  js.configs.recommended,
  {
    files: ["**/*.ts"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module"
    },
    plugins: { import: pluginImport },
    rules: {
      "import/order": ["warn", {"newlines-between":"always"}]
    }
  }
];
