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
          "id": "49906410-358c-4428-8fef-4e59377cee15",
          "type": "basic.output",
          "data": {
            "name": "LED",
            "virtual": false,
            "range": "[7:0]",
            "pins": [
              {
                "index": "7",
                "name": "LED7",
                "value": "V14"
              },
              {
                "index": "6",
                "name": "LED6",
                "value": "U14"
              },
              {
                "index": "5",
                "name": "LED5",
                "value": "U15"
              },
              {
                "index": "4",
                "name": "LED4",
                "value": "W18"
              },
              {
                "index": "3",
                "name": "LED3",
                "value": "V19"
              },
              {
                "index": "2",
                "name": "LED2",
                "value": "U19"
              },
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
            "x": 720,
            "y": 56
          }
        },
        {
          "id": "7f2e6b61-04f6-451d-aaa9-f9e023db1044",
          "type": "basic.code",
          "data": {
            "ports": {
              "in": [],
              "out": [
                {
                  "name": "leds",
                  "range": "[7:0]",
                  "size": 8
                }
              ]
            },
            "params": [],
            "code": "//-- Show an 8-bit number on the LEDs\n\n//-- Valor a sacar por los leds\nlocalparam [7:0] VALUE = 8'hAA;\n\n//-- Mostrar numero en los leds\nassign leds = VALUE;"
          },
          "position": {
            "x": 192,
            "y": 120
          },
          "size": {
            "width": 400,
            "height": 152
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "7f2e6b61-04f6-451d-aaa9-f9e023db1044",
            "port": "leds"
          },
          "target": {
            "block": "49906410-358c-4428-8fef-4e59377cee15",
            "port": "in"
          },
          "size": 8
        }
      ]
    }
  },
  "dependencies": {}
}