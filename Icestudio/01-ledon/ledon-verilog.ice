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
          "id": "c92081cb-9529-44ad-b419-5fe52a2a1672",
          "type": "basic.output",
          "data": {
            "name": "LED",
            "virtual": false,
            "range": "[15:0]",
            "pins": [
              {
                "index": "15",
                "name": "LED15",
                "value": "L1"
              },
              {
                "index": "14",
                "name": "LED14",
                "value": "P1"
              },
              {
                "index": "13",
                "name": "LED13",
                "value": "N3"
              },
              {
                "index": "12",
                "name": "LED12",
                "value": "P3"
              },
              {
                "index": "11",
                "name": "LED11",
                "value": "U3"
              },
              {
                "index": "10",
                "name": "LED10",
                "value": "W3"
              },
              {
                "index": "9",
                "name": "LED9",
                "value": "V3"
              },
              {
                "index": "8",
                "name": "LED8",
                "value": "V13"
              },
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
            "x": 856,
            "y": 120
          }
        },
        {
          "id": "11265073-aad1-4481-a225-f025d88e7614",
          "type": "basic.code",
          "data": {
            "ports": {
              "in": [],
              "out": [
                {
                  "name": "leds",
                  "range": "[15:0]",
                  "size": 16
                }
              ]
            },
            "params": [],
            "code": "//-- Turn on one LED\n\n//-- Encender led15!\n    assign leds[15] = 1'b1;"
          },
          "position": {
            "x": 440,
            "y": 344
          },
          "size": {
            "width": 304,
            "height": 96
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "11265073-aad1-4481-a225-f025d88e7614",
            "port": "leds"
          },
          "target": {
            "block": "c92081cb-9529-44ad-b419-5fe52a2a1672",
            "port": "in"
          },
          "size": 16
        }
      ]
    }
  },
  "dependencies": {}
}