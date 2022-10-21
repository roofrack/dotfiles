// bs-config.js

module.exports = {
  notify: false, //stops the stupid browser notifier
  open: false, //stops auto open browser on start
  proxy: {
    // target: "127.0.0.1:3000",
    target: "10.138.72.251:3000",
    ws: true,
  },
  port: 3001,
  files: [
    "**/*.*",
    //     "*.html",
    //     "*.js",
    // "*.css",
    // "routes/*.js"
  ],
};
