{ ... }:
builtins.toFile "workspace-1.json" ''
  // vim:ts=4:sw=4:et
  {
              "border": "pixel",
              "current_border_width": 1,
              "floating": "auto_off",
              "fullscreen_mode": 1,
              "geometry": {
                 "height": 1060,
                 "width": 945,
                 "x": 10,
                 "y": 10
              },
              "marks": [],
              "name": "Chromium dev",
              "percent": 1,
              "swallows": [
                 {
                  "class": "^Chromium\\-browser$",
                 // "instance": "^chromium\\-browser$"
                 // "machine": "^e3ff514312e2$",
                 // "title": "^New\\ Tab\\ \\-\\ Chromium$",
                  "window_role": "^browser$"
                 }
              ],
              "type": "con"
          }
''
