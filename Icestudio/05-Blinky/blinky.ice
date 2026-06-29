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
          "id": "e0621a57-5620-421b-9a65-9a2cba875909",
          "type": "basic.output",
          "data": {
            "name": "",
            "virtual": false,
            "pins": [
              {
                "index": "0",
                "name": "LED0",
                "value": "U16"
              }
            ]
          },
          "position": {
            "x": 520,
            "y": 256
          }
        },
        {
          "id": "1eadf95a-26ca-45d0-b884-a67fca88c242",
          "type": "basic.constant",
          "data": {
            "name": "Bits",
            "value": "25",
            "local": false
          },
          "position": {
            "x": 344,
            "y": 152
          }
        },
        {
          "id": "25ba4bee-831c-4243-862a-f065f016b94d",
          "type": "0fbb4a1074b2362157ef7214f1a9db253005c40f",
          "position": {
            "x": 344,
            "y": 256
          },
          "size": {
            "width": 96,
            "height": 64
          }
        }
      ],
      "wires": [
        {
          "source": {
            "block": "25ba4bee-831c-4243-862a-f065f016b94d",
            "port": "cf8c4495-72ea-4968-af7d-96e7c28d33c1"
          },
          "target": {
            "block": "e0621a57-5620-421b-9a65-9a2cba875909",
            "port": "in"
          },
          "vertices": []
        },
        {
          "source": {
            "block": "1eadf95a-26ca-45d0-b884-a67fca88c242",
            "port": "constant-out"
          },
          "target": {
            "block": "25ba4bee-831c-4243-862a-f065f016b94d",
            "port": "0bc70179-bdf1-47e1-99cd-c1bd171bae2c"
          },
          "vertices": []
        }
      ]
    }
  },
  "dependencies": {
    "0fbb4a1074b2362157ef7214f1a9db253005c40f": {
      "package": {
        "name": "Contador25",
        "version": "0.10",
        "description": "Contador del sistema de 25 bits",
        "author": "Juan González-Gómez (Obijuan)",
        "image": "%3Csvg%20width=%22244.983%22%20height=%22223.683%22%20viewBox=%220%200%2064.818328%2059.182739%22%20xmlns=%22http://www.w3.org/2000/svg%22%3E%3Cpath%20d=%22M31.726%2058.436c-1.06-1.822-2.702-3.607-5.814-6.317-1.686-1.467-2.711-2.282-8.55-6.793-4.577-3.536-6.86-5.498-9.506-8.168-2.644-2.67-4.199-4.797-5.532-7.57-.852-1.77-1.437-3.476-1.801-5.249C.06%2022.087-.002%2021.325%200%2018.01c.003-4.352.147-5.076%201.575-7.979%201.062-2.155%201.869-3.29%203.548-4.996%201.631-1.655%202.69-2.407%204.98-3.54C12.645.237%2014.485-.093%2018.275.03c2.945.095%204.023.388%206.358%201.732%203.675%202.114%206.527%205.509%207.316%208.709.129.523.262.951.296.951.034%200%20.331-.612.66-1.36%201.123-2.543%202.166-4.095%203.822-5.69%205.07-4.89%2013.064-5.774%2019.528-2.162%202.64%201.475%204.787%203.623%206.451%206.452%201.31%202.226%201.98%205.183%202.095%209.245.165%205.884-.911%209.962-3.776%2014.307-1.136%201.725-1.977%202.77-3.554%204.416-2.545%202.658-4.84%204.612-10.257%208.732-3.418%202.6-5.444%204.271-8.377%206.914-2.35%202.117-5.99%205.802-6.341%206.419-.154.269-.292.489-.308.489-.017%200-.225-.336-.463-.747z%22%20fill=%22red%22/%3E%3C/svg%3E"
      },
      "design": {
        "graph": {
          "blocks": [
            {
              "id": "0bc70179-bdf1-47e1-99cd-c1bd171bae2c",
              "type": "basic.constant",
              "data": {
                "name": "N",
                "value": "25",
                "local": false
              },
              "position": {
                "x": 648,
                "y": 168
              }
            },
            {
              "id": "cf8c4495-72ea-4968-af7d-96e7c28d33c1",
              "type": "basic.output",
              "data": {
                "name": "",
                "virtual": true,
                "pins": [
                  {
                    "index": "0",
                    "name": "NULL",
                    "value": "NULL"
                  }
                ]
              },
              "position": {
                "x": 928,
                "y": 336
              }
            },
            {
              "id": "3c0a7e78-1d25-4326-a8ea-2c20438b2903",
              "type": "basic.input",
              "data": {
                "name": "",
                "clock": true
              },
              "position": {
                "x": 360,
                "y": 336
              }
            },
            {
              "id": "1487a5b4-10e6-41fc-ab62-a2975da4c540",
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
                      "name": "q"
                    }
                  ]
                },
                "params": [
                  {
                    "name": "N"
                  }
                ],
                "code": "//-- Número de bits del contador\n\n\nreg [N-1:0] qi = 0;\n\nalways @(posedge clk)\n    qi <= qi + 1;\n    \nassign q = qi[N-1];"
              },
              "position": {
                "x": 536,
                "y": 272
              },
              "size": {
                "width": 320,
                "height": 192
              }
            }
          ],
          "wires": [
            {
              "source": {
                "block": "3c0a7e78-1d25-4326-a8ea-2c20438b2903",
                "port": "out"
              },
              "target": {
                "block": "1487a5b4-10e6-41fc-ab62-a2975da4c540",
                "port": "clk"
              }
            },
            {
              "source": {
                "block": "1487a5b4-10e6-41fc-ab62-a2975da4c540",
                "port": "q"
              },
              "target": {
                "block": "cf8c4495-72ea-4968-af7d-96e7c28d33c1",
                "port": "in"
              }
            },
            {
              "source": {
                "block": "0bc70179-bdf1-47e1-99cd-c1bd171bae2c",
                "port": "constant-out"
              },
              "target": {
                "block": "1487a5b4-10e6-41fc-ab62-a2975da4c540",
                "port": "N"
              }
            }
          ]
        }
      }
    }
  }
}