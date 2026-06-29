{
  "version": "1.2",
  "package": {
    "name": "",
    "version": "",
    "description": "",
    "author": "",
    "image": ""
  },
  "design": {
    "board": "basys3",
    "graph": {
      "blocks": [
        {
          "id": "6980ddbe-8389-4497-b6fa-8d020900d0ac",
          "type": "basic.output",
          "data": {
            "name": "LED",
            "virtual": false,
            "range": "[1:0]",
            "pins": [
              {
                "index": "1",
                "name": "LED1",
                "value": "E19"
              },
              {
                "index": "0",
                "name": "LED0",
                "value": "U16"
              }
            ]
          },
          "position": {
            "x": 872,
            "y": 288
          }
        },
        {
          "id": "5d3343f1-f847-4868-a1d4-5ab9e5ca7154",
          "type": "basic.code",
          "data": {
            "ports": {
              "in": [],
              "out": [
                {
                  "name": "leds",
                  "range": "[1:0]",
                  "size": 2
                }
              ]
            },
            "params": [],
            "code": "//-- Turn on 2 LEDs\n\n//-- Encender los dos leds D0 y D1\nassign leds = 2'b11;"
          },
          "position": {
            "x": 392,
            "y": 280
          },
          "size": {
            "width": 352,
            "height": 104
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "5d3343f1-f847-4868-a1d4-5ab9e5ca7154",
            "port": "leds"
          },
          "target": {
            "block": "6980ddbe-8389-4497-b6fa-8d020900d0ac",
            "port": "in"
          },
          "size": 2
        }
      ]
    }
  },
  "dependencies": {}
}