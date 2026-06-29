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
          "id": "c1704381-bb27-44ca-a1bc-519022511588",
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
            "x": 1272,
            "y": 128
          }
        },
        {
          "id": "ed179b6d-22c6-42fc-bbdd-085aa53982af",
          "type": "basic.input",
          "data": {
            "name": "",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "CLK",
                "value": "W5"
              }
            ],
            "clock": false,
            "isParametric": false
          },
          "position": {
            "x": 448,
            "y": 368
          }
        },
        {
          "id": "f7d36816-90b6-4de6-bde4-127b5348a541",
          "type": "basic.code",
          "data": {
            "ports": {
              "in": [
                {
                  "name": "clk"
                }
              ],
              "out": [
                {
                  "name": "leds",
                  "range": "[15:0]",
                  "size": 16
                }
              ]
            },
            "params": [],
            "code": "//-- Blinking led\n\n//-- Contador de 25 bits\nreg [24:0] counter;\nalways @(posedge clk) begin\n    counter <= counter + 1;\nend\n\n//-- Mostrar en el LED0 el bit de mayor peso del contador\nassign leds[0] = counter[24];\n\nassign leds[15:1] = 0;\n\n//-- This is for simulation\n//-- the counter should start in 0\ninitial begin\n    counter = 0;\nend"
          },
          "position": {
            "x": 624,
            "y": 240
          },
          "size": {
            "width": 528,
            "height": 320
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "f7d36816-90b6-4de6-bde4-127b5348a541",
            "port": "leds"
          },
          "target": {
            "block": "c1704381-bb27-44ca-a1bc-519022511588",
            "port": "in"
          },
          "size": 16
        },
        {
          "source": {
            "block": "ed179b6d-22c6-42fc-bbdd-085aa53982af",
            "port": "out"
          },
          "target": {
            "block": "f7d36816-90b6-4de6-bde4-127b5348a541",
            "port": "clk"
          }
        }
      ]
    }
  },
  "dependencies": {}
}