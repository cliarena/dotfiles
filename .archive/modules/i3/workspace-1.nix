{...}:
builtins.toFile "workspace-1.json" ''
  // vim:ts=4:sw=4:et
  {
      "border": "pixel",
      "current_border_width": 1,
      "floating": "auto_off",
      "geometry": {
         "height": 340,
         "width": 564,
         "x": 0,
         "y": 0
      },
      "marks": [],
      "name": "kitty",
      "percent": 0.8,
      "swallows": [
         {
          "class": "^kitty$",
          "instance": "^kitty$"
          // "machine": "^e3ff514312e2$",
          // "title": "^kitty$"
         }
      ],
      "type": "con"
  }

  {
      // splitv split container with 2 children
      "border": "pixel",
      "floating": "auto_off",
      "layout": "splitv",
      "marks": [],
      "percent": 0.2,
      "type": "con",
      "nodes": [
          {
              "border": "pixel",
              "current_border_width": 1,
              "floating": "auto_off",
              "geometry": {
                 "height": 964,
                 "width": 936,
                 "x": 10,
                 "y": 10
              },
              "marks": [],
              "name": "Chromium dev",
              "percent": 0.8,
              "swallows": [
                 {
                  "class": "^Chromium\\-browser$",
                 // "instance": "^chromium\\-browser$"
                 // "machine": "^e3ff514312e2$",
                 // "title": "^New\\ Tab\\ \\-\\ Chromium$",
                  "window_role": "^pop\\-up$"
                 }
              ],
              "type": "con"
          },
          {
              "border": "pixel",
              "current_border_width": 1,
              "floating": "auto_off",
              "geometry": {
                 "height": 340,
                 "width": 564,
                 "x": 0,
                 "y": 0
              },
              "marks": [],
              "name": "kitty",
              "percent": 0.2,
              "swallows": [
                 {
                  "class": "^kitty$",
                  "instance": "^kitty$"
                 // "machine": "^e3ff514312e2$",
                 // "title": "^st$"
                 }
              ],
              "type": "con"
          }
      ]
  }
''
