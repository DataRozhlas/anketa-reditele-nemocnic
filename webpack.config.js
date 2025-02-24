const path = require("path");

module.exports = {
  entry: "./js/script.js",
  output: {
    path: path.resolve(__dirname),
    filename: "output.js",
  },

  node: {
    fs: "empty",
  },

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env", "@babel/preset-react"],
            plugins: ['@babel/plugin-proposal-class-properties']
          },
        },
      },
    ],
  },
};
