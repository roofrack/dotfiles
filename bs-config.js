// bs-config.js

module.exports = {
    "notify": false, //stops the stupid browser notifier
    "open": false, //stops auto open browser on start
    "port": 3000,
    "files":[
        "flask_app/templates/*.html", 
        "flask_app/static/js/*.js",
        "flask_app/static/css/*.css",
        ],
    "proxy": {
        target: "127.0.0.1:5000",
        ws: true
        }
};

