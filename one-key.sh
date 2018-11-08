mkdir -p ssl/ca
cfssl print-defaults config > ssl/ca/ca-config.json
cfssl print-defaults csr > ssl/ca/ca-csr.json

cat << 'EOF' > ssl/ca/ca-config.json 
{
    "signing": {
        "default": {
            "expiry": "2540400h"
        },
        "profiles": {
            "server": {
                "expiry": "2540400h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth"
                ]
            },
            "client": {
                "expiry": "2540400h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "client auth"
                ]
            },
            "peer": {
                "expiry": "2540400h",
                "usages": [
                    "signing",
                    "key encipherment",
                    "server auth",
                    "client auth"
                ]
            }
        }
    }
}
EOF

cfssl gencert -initca ssl/ca/ca-csr.json | cfssljson -bare ssl/ca/ca -

mkdir -p ssl/server
cfssl print-defaults csr > ssl/server/server.json

cat << 'EOF' > ssl/server/server.json
{
    "CN": "linuxcrypt.top",
    "hosts": [
        "192.168.1.20",
        "192.168.1.58",
        "192.168.1.90",
        "mqtt.linuxcrypt.top",
        "message.linuxcrypt.top",
        "linuxcrypt.top",
        "www.linuxcrypt.top"
    ],
    "key": {
        "algo": "ecdsa",
        "size": 256
    },
    "names": [
        {
            "C": "CN",
            "ST": "SH",
            "L": "Shanghai"
        }
    ]
}
EOF

cfssl gencert -ca=ssl/ca/ca.pem -ca-key=ssl/ca/ca-key.pem -config=ssl/ca/ca-config.json -profile=server ssl/server/server.json | cfssljson -bare ssl/server/server

mkdir -p ssl/client
cfssl print-defaults csr > ssl/client/client.json

cat << 'EOF' > ssl/client/client.json
{
    "CN": "client",
    "hosts": [],
    "key": {
        "algo": "ecdsa",
        "size": 256
    },
    "names": [
        {
            "C": "CN",
            "ST": "SH",
            "L": "Shanghai"
        }
    ]
}
EOF

cfssl gencert -ca=ssl/ca/ca.pem -ca-key=ssl/ca/ca-key.pem -config=ssl/ca/ca-config.json -profile=client ssl/client/client.json | cfssljson -bare ssl/client/client

mkdir -p ssl/peer
cfssl print-defaults csr > ssl/peer/peer.json

cat << 'EOF' > ssl/peer/peer.json
{
    "CN": "linuxcrypt.top",
    "hosts": [
        "192.168.1.20",
        "192.168.1.58",
        "192.168.1.90",
        "mqtt.linuxcrypt.top",
        "message.linuxcrypt.top",
        "linuxcrypt.top",
        "www.linuxcrypt.top"
    ],
    "key": {
        "algo": "ecdsa",
        "size": 256
    },
    "names": [
        {
            "C": "US",
            "ST": "CA",
            "L": "San Francisco"
        }
    ]
}
EOF

cfssl gencert -ca=ssl/ca/ca.pem -ca-key=ssl/ca/ca-key.pem -config=ssl/ca/ca-config.json -profile=peer ssl/peer/peer.json | cfssljson -bare ssl/peer/peer
