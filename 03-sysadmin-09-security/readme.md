1. Установите Hashicorp Vault в виртуальной машине Vagrant/VirtualBox.
    
    $ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -   
    $ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"      
    $ sudo apt-get update && sudo apt-get install vault  
   
    
2. Запустить Vault-сервер в dev-режиме.

   
vault server -dev
        
        vagrant@vagrant:~$ vault server -dev
        ==> Vault server configuration:
        
                     Api Address: http://127.0.0.1:8200
                             Cgo: disabled
                 Cluster Address: https://127.0.0.1:8201
                      Go Version: go1.15.7
                      Listener 1: tcp (addr: "127.0.0.1:8200", cluster address: "127.0.0.1:8201", max_request_duration: "1m30s", max_request_size: "33554432", tls: "disabled")
                       Log Level: info
                           Mlock: supported: true, enabled: false
                   Recovery Mode: false
                         Storage: inmem
                         Version: Vault v1.6.3
                     Version Sha: b540be4b7ec48d0dd7512c8d8df9399d6bf84d76
        
        ==> Vault server started! Log data will stream in below:
        
        2021-03-24T12:53:00.292Z [INFO]  proxy environment: http_proxy= https_proxy= no_proxy=
        2021-03-24T12:53:00.293Z [WARN]  no `api_addr` value specified in config or in VAULT_API_ADDR; falling back to detection if possible, but this value should be manually set
        2021-03-24T12:53:00.314Z [INFO]  core: security barrier not initialized
        2021-03-24T12:53:00.315Z [INFO]  core: security barrier initialized: stored=1 shares=1 threshold=1
        2021-03-24T12:53:00.371Z [INFO]  core: post-unseal setup starting
        2021-03-24T12:53:00.423Z [INFO]  core: loaded wrapping token key
        2021-03-24T12:53:00.426Z [INFO]  core: successfully setup plugin catalog: plugin-directory=
        2021-03-24T12:53:00.426Z [INFO]  core: no mounts; adding default mount table
        2021-03-24T12:53:00.430Z [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
        2021-03-24T12:53:00.455Z [INFO]  core: successfully mounted backend: type=system path=sys/
        2021-03-24T12:53:00.459Z [INFO]  core: successfully mounted backend: type=identity path=identity/
        2021-03-24T12:53:00.511Z [INFO]  core: successfully enabled credential backend: type=token path=token/
        2021-03-24T12:53:00.511Z [INFO]  core: restoring leases
        2021-03-24T12:53:00.528Z [INFO]  rollback: starting rollback manager
        2021-03-24T12:53:00.531Z [INFO]  expiration: lease restore complete
        2021-03-24T12:53:00.531Z [INFO]  identity: entities restored
        2021-03-24T12:53:00.531Z [INFO]  identity: groups restored
        2021-03-24T12:53:00.532Z [INFO]  core: post-unseal setup complete
        2021-03-24T12:53:00.532Z [INFO]  core: root token generated
        2021-03-24T12:53:00.532Z [INFO]  core: pre-seal teardown starting
        2021-03-24T12:53:00.532Z [INFO]  rollback: stopping rollback manager
        2021-03-24T12:53:00.533Z [INFO]  core: pre-seal teardown complete
        2021-03-24T12:53:00.534Z [INFO]  core.cluster-listener.tcp: starting listener: listener_address=127.0.0.1:8201
        2021-03-24T12:53:00.534Z [INFO]  core.cluster-listener: serving cluster requests: cluster_listen_address=127.0.0.1:8201
        2021-03-24T12:53:00.534Z [INFO]  core: post-unseal setup starting
        2021-03-24T12:53:00.534Z [INFO]  core: loaded wrapping token key
        2021-03-24T12:53:00.534Z [INFO]  core: successfully setup plugin catalog: plugin-directory=
        2021-03-24T12:53:00.535Z [INFO]  core: successfully mounted backend: type=system path=sys/
        2021-03-24T12:53:00.536Z [INFO]  core: successfully mounted backend: type=identity path=identity/
        2021-03-24T12:53:00.536Z [INFO]  core: successfully mounted backend: type=cubbyhole path=cubbyhole/
        2021-03-24T12:53:00.538Z [INFO]  core: successfully enabled credential backend: type=token path=token/
        2021-03-24T12:53:00.538Z [INFO]  core: restoring leases
        2021-03-24T12:53:00.539Z [INFO]  rollback: starting rollback manager
        2021-03-24T12:53:00.539Z [INFO]  identity: entities restored
        2021-03-24T12:53:00.539Z [INFO]  identity: groups restored
        2021-03-24T12:53:00.539Z [INFO]  core: post-unseal setup complete
        2021-03-24T12:53:00.539Z [INFO]  core: vault is unsealed
        2021-03-24T12:53:00.552Z [INFO]  expiration: lease restore complete
        2021-03-24T12:53:00.631Z [INFO]  core: successful mount: namespace= path=secret/ type=kv
        2021-03-24T12:53:00.639Z [INFO]  secrets.kv.kv_a8dfe51f: collecting keys to upgrade
        2021-03-24T12:53:00.639Z [INFO]  secrets.kv.kv_a8dfe51f: done collecting keys: num_keys=1
        2021-03-24T12:53:00.639Z [INFO]  secrets.kv.kv_a8dfe51f: upgrading keys finished
        WARNING! dev mode is enabled! In this mode, Vault runs entirely in-memory
        and starts unsealed with a single unseal key. The root token is already
        authenticated to the CLI, so you can immediately begin using Vault.
        
        You may need to set the following environment variable:
        
            $ export VAULT_ADDR='http://127.0.0.1:8200'
        
        The unseal key and root token are displayed below in case you want to
        seal/unseal the Vault or re-authenticate.
        
        Unseal Key: YZ1tIRGzv7MQya8vaSu8MfCq6MEqGJqGvjoYQL16w48=
        Root Token: s.nQzcoymFWwlYYIWvTVz8Vnky
        
        Development mode should NOT be used in production installations!


export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN="s.WqY7yU3gVrB2FSqReCPSAUHc"
    
        vagrant@vagrant:~$ vault status
        Key             Value
        ---             -----
        Seal Type       shamir
        Initialized     true
        Sealed          false
        Total Shares    1
        Threshold       1
        Version         1.6.3
        Storage Type    inmem
        Cluster Name    vault-cluster-2a72884d
        Cluster ID      16f2b0f6-1ad1-4050-7df2-69b535cd6e68
        HA Enabled      false


3. Используя PKI Secrets Engine, создайте Root CA и Intermediate CA. Обратите внимание на дополнительные материалы по созданию CA в Vault, если с изначальной инструкцией возникнут сложности.

   Root CA


        vagrant@vagrant:~$ vault secrets enable pki
        2021-03-24T13:00:07.234Z [INFO]  core: successful mount: namespace= path=pki/ type=pki
        Success! Enabled the pki secrets engine at: pki/
        vagrant@vagrant:~$ vault secrets tune -max-lease-ttl=87600h pki
        2021-03-24T13:00:25.549Z [INFO]  core: mount tuning of leases successful: path=pki/
        Success! Tuned the secrets engine at: pki/
        vagrant@vagrant:~$ vault write -field=certificate pki/root/generate/internal \
        >         common_name="example.com" \
        >         ttl=87600h > CA_cert.crt
        vagrant@vagrant:~$ vault write pki/config/urls \
        >         issuing_certificates="http://127.0.0.1:8200/v1/pki/ca" \
        >         crl_distribution_points="http://127.0.0.1:8200/v1/pki/crl"
        Success! Data written to: pki/config/urls
        
   Intermediate CA

        vagrant@vagrant:~$ vault secrets enable -path=pki_int pki
        2021-03-24T13:03:08.541Z [INFO]  core: successful mount: namespace= path=pki_int/ type=pki
        Success! Enabled the pki secrets engine at: pki_int/
        vagrant@vagrant:~$ vault secrets tune -max-lease-ttl=43800h pki_int
        2021-03-24T13:03:39.572Z [INFO]  core: mount tuning of leases successful: path=pki_int/
        Success! Tuned the secrets engine at: pki_int/

   Для обработки json установил jq

        vagrant@vagrant:~$ vault write -format=json pki_int/intermediate/generate/internal \
        >         common_name="example.com Intermediate Authority" \
        >         | jq -r '.data.csr' > pki_intermediate.csr
        vagrant@vagrant:~$         
        vagrant@vagrant:~$ vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
        >         format=pem_bundle ttl="43800h" \
        >         | jq -r '.data.certificate' > intermediate.cert.pem
        vagrant@vagrant:~$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
        Success! Data written to: pki_int/intermediate/set-signed

Создаём роль

        vagrant@vagrant:~$ vault write pki_int/roles/example-dot-com \
        >         allowed_domains="example.com" \
        >         allow_subdomains=true \
        >         max_ttl="720h"
        Success! Data written to: pki_int/roles/example-dot-com

4. Согласно этой же инструкции, подпишите Intermediate CA csr на сертификат для тестового домена (например, netology.example.com если действовали согласно инструкции).


        vagrant@vagrant:~$ vault write pki_int/issue/example-dot-com common_name="netology.example.com" ttl="24h" > netology.out

Результат

        vagrant@vagrant:~$ cat netology.out 
        Key                 Value
        ---                 -----
        ca_chain            [-----BEGIN CERTIFICATE-----
        MIIDpjCCAo6gAwIBAgIURUSv4hXxFQmBRVKbZARyqzxyIVEwDQYJKoZIhvcNAQEL
        BQAwFjEUMBIGA1UEAxMLZXhhbXBsZS5jb20wHhcNMjEwMzI0MTMxMDQwWhcNMjYw
        MzIzMTMxMTEwWjAtMSswKQYDVQQDEyJleGFtcGxlLmNvbSBJbnRlcm1lZGlhdGUg
        QXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5jDjKAYL
        HcMWndiqqvl4cbK2EzrW2hy04G9IHa32WyewO2pb3cd3jgtvJ2pO6iqp5naZv37/
        Y3Guo3Ndwi+Ji+2HiEuhx+UiMAXiixIdN+1OlHq/1sETfZVWN7TGfbUL6PYwrn0d
        DFqjMKizrma3U+TkyxS01QeEfIH6Dr1aSh6x0C5vvOK2KEMTvOnkrUd+kgmVAM9B
        YGzVWSxSkxcSh22hEdkQCUhRxoTV0JxHI+Zpu+GE63JQ1dKOxoyOWOKzP4PMnC/W
        Qc0YejJHaIjh2/t7AiI3QpSA3Uj43nL4iOfXm034+OIsy/ynl5uoaZBVm7hpW6hM
        2wKSNOvmWzwpNQIDAQABo4HUMIHRMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
        BTADAQH/MB0GA1UdDgQWBBSBffFyzvoM5ZgBgpJTB2Zkd79/CjAfBgNVHSMEGDAW
        gBSYwQq1z/65IyI1sGO4HRzdmIXFAzA7BggrBgEFBQcBAQQvMC0wKwYIKwYBBQUH
        MAKGH2h0dHA6Ly8xMjcuMC4wLjE6ODIwMC92MS9wa2kvY2EwMQYDVR0fBCowKDAm
        oCSgIoYgaHR0cDovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jcmwwDQYJKoZIhvcN
        AQELBQADggEBALDitEwIUsLv23OJ1URGbwvnq8ntahAAUTDQmlsZEc8qPp1vUunh
        urHOXvU6MNl4hGQYID4+m3/1S1EPsBgAx2Q4Hs1vCVEQozf5XYF5ezUtBO1cfxHw
        Q9gZBfQG/FbIfpy8wb5nXqdgcl97rduHDF/P7dVmpHa3O5RZZodai+jgT4zbPHHp
        yAI/nhSrDsFnmkZMm0TrJQhMcrOP2+2xYjiDPBwgR79BaCKjsOu/8Jc5FxasuvpR
        NyeXM51tWOpefys+xE3o1FRcca74B7GIHK1Sj4OcRHzrLuYLbeo2tYC6IGqNIErN
        zkACi9LzErDGO1SnlUaApNqsVaxZWu0uCvI=
        -----END CERTIFICATE-----]
        certificate         -----BEGIN CERTIFICATE-----
        MIIDbjCCAlagAwIBAgIUZbNjOTZjw7f0yU+MYwmEyLeZl3MwDQYJKoZIhvcNAQEL
        BQAwLTErMCkGA1UEAxMiZXhhbXBsZS5jb20gSW50ZXJtZWRpYXRlIEF1dGhvcml0
        eTAeFw0yMTAzMjQxMzE3MzVaFw0yMTAzMjUxMzE4MDVaMB8xHTAbBgNVBAMTFG5l
        dG9sb2d5LmV4YW1wbGUuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
        AQEAsMQF/Uwy92XhCCmj56VfZIuN48zzeJPl5r0IeEnFeKuPkIdVDZQGeP4xjkxb
        APh0vyaTMd4F0ckkHWjWn9dnUq6Cq9Z6xNMDJcydMhvyRjV/DGiCZYO2eeu+WirT
        I/QKX5Fnkz+sLTptuQXsPJIIBk3bOuopbyElcKi2xxE1sYDzTfV/TM5cyltTgetf
        sbtMRlxplaQM0TkoVBsnitWkUAviwPNrlFvZ5N+31BJruUO7f4n5yF5DOYjblOaC
        dZdhnbnZVhNXgz8yn98UXl/zeztDtNwJkblauN54Bxr3xLql9P22B77k11XkWTCJ
        PKfA03NJzCsslgjcfr/okvFcXQIDAQABo4GTMIGQMA4GA1UdDwEB/wQEAwIDqDAd
        BgNVHSUEFjAUBggrBgEFBQcDAQYIKwYBBQUHAwIwHQYDVR0OBBYEFJQn3uc8vM/v
        H+d6t1osXgBrAQCzMB8GA1UdIwQYMBaAFIF98XLO+gzlmAGCklMHZmR3v38KMB8G
        A1UdEQQYMBaCFG5ldG9sb2d5LmV4YW1wbGUuY29tMA0GCSqGSIb3DQEBCwUAA4IB
        AQBml/+f0QodjLMiqE+RcmH4P/6S/3eV20EsFPu+6194jMmNRmdvfPuZewlKHB6a
        jck5tycVeczM8KkY2U+m9FiH7vhC9DLmE8cHIPECXmwe1AOoThVIGHqS8Jnogjy8
        Os5uNfv/viYfxuIMROjhWHknp0Spur3nHVvxSVat/iR928eByasA9IgcpcSCqUgJ
        zh8hSsKqX7+VKzi6g72jHKOZBwpLQSu9p3xHUWxA4fXjT3NLJxqMwmyYTVca5x/q
        ya8ediOEwys6qPpbeYNJHVLcyK5wZU8Ip+2s2THR0TmvmHReD1WxgDD3QNeDYsYY
        ORkQpvJZ8KcB2mQ39fFdh+XQ
        -----END CERTIFICATE-----
        expiration          1616678285
        issuing_ca          -----BEGIN CERTIFICATE-----
        MIIDpjCCAo6gAwIBAgIURUSv4hXxFQmBRVKbZARyqzxyIVEwDQYJKoZIhvcNAQEL
        BQAwFjEUMBIGA1UEAxMLZXhhbXBsZS5jb20wHhcNMjEwMzI0MTMxMDQwWhcNMjYw
        MzIzMTMxMTEwWjAtMSswKQYDVQQDEyJleGFtcGxlLmNvbSBJbnRlcm1lZGlhdGUg
        QXV0aG9yaXR5MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5jDjKAYL
        HcMWndiqqvl4cbK2EzrW2hy04G9IHa32WyewO2pb3cd3jgtvJ2pO6iqp5naZv37/
        Y3Guo3Ndwi+Ji+2HiEuhx+UiMAXiixIdN+1OlHq/1sETfZVWN7TGfbUL6PYwrn0d
        DFqjMKizrma3U+TkyxS01QeEfIH6Dr1aSh6x0C5vvOK2KEMTvOnkrUd+kgmVAM9B
        YGzVWSxSkxcSh22hEdkQCUhRxoTV0JxHI+Zpu+GE63JQ1dKOxoyOWOKzP4PMnC/W
        Qc0YejJHaIjh2/t7AiI3QpSA3Uj43nL4iOfXm034+OIsy/ynl5uoaZBVm7hpW6hM
        2wKSNOvmWzwpNQIDAQABo4HUMIHRMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8E
        BTADAQH/MB0GA1UdDgQWBBSBffFyzvoM5ZgBgpJTB2Zkd79/CjAfBgNVHSMEGDAW
        gBSYwQq1z/65IyI1sGO4HRzdmIXFAzA7BggrBgEFBQcBAQQvMC0wKwYIKwYBBQUH
        MAKGH2h0dHA6Ly8xMjcuMC4wLjE6ODIwMC92MS9wa2kvY2EwMQYDVR0fBCowKDAm
        oCSgIoYgaHR0cDovLzEyNy4wLjAuMTo4MjAwL3YxL3BraS9jcmwwDQYJKoZIhvcN
        AQELBQADggEBALDitEwIUsLv23OJ1URGbwvnq8ntahAAUTDQmlsZEc8qPp1vUunh
        urHOXvU6MNl4hGQYID4+m3/1S1EPsBgAx2Q4Hs1vCVEQozf5XYF5ezUtBO1cfxHw
        Q9gZBfQG/FbIfpy8wb5nXqdgcl97rduHDF/P7dVmpHa3O5RZZodai+jgT4zbPHHp
        yAI/nhSrDsFnmkZMm0TrJQhMcrOP2+2xYjiDPBwgR79BaCKjsOu/8Jc5FxasuvpR
        NyeXM51tWOpefys+xE3o1FRcca74B7GIHK1Sj4OcRHzrLuYLbeo2tYC6IGqNIErN
        zkACi9LzErDGO1SnlUaApNqsVaxZWu0uCvI=
        -----END CERTIFICATE-----
        private_key         -----BEGIN RSA PRIVATE KEY-----
        MIIEpAIBAAKCAQEAsMQF/Uwy92XhCCmj56VfZIuN48zzeJPl5r0IeEnFeKuPkIdV
        DZQGeP4xjkxbAPh0vyaTMd4F0ckkHWjWn9dnUq6Cq9Z6xNMDJcydMhvyRjV/DGiC
        ZYO2eeu+WirTI/QKX5Fnkz+sLTptuQXsPJIIBk3bOuopbyElcKi2xxE1sYDzTfV/
        TM5cyltTgetfsbtMRlxplaQM0TkoVBsnitWkUAviwPNrlFvZ5N+31BJruUO7f4n5
        yF5DOYjblOaCdZdhnbnZVhNXgz8yn98UXl/zeztDtNwJkblauN54Bxr3xLql9P22
        B77k11XkWTCJPKfA03NJzCsslgjcfr/okvFcXQIDAQABAoIBAETi34Kq42HObjgE
        Ij/wDpDcYdtYz7k5yep12IsoFLDGCxjD5L155lvYk+9kikKCkNy9Z7eTUqlCvbRI
        WvvHshhiscHNv+JcaWmdp9UTVwNNbcmkIMz223IAERqKfeYRAMnlnHuh4LNvhbsJ
        N9sS/dWXGcyH3MXWIQUaesBxUH9vntRHoYVp/osafFG9NZlm0vcgFd2WItnAvJby
        Fp5lCBJU7UHhGzuF6ghY2O4+CsEmT+fUXpgLkMwDDqm55yWFs13N8N4qz4mIVPaB
        Rh3unG0st+Jc7D+uIbZp9HJaQz56C2e+Ztt/SppXpfEzrrioXwxGxlwr77w2SPBn
        YsIijwECgYEA6fSHQqjgXvBR2/OefHN/iXBlyAiYZxzh1MbhPm6yoAXYk3BJSJoH
        Iya4Pe5TZYsO3gYHt/M7h9BUNcYs6GpCq++IMZUj7Tfcn2J37exvm6WFSjb1MiZH
        9ZxkmoQ3mZXX+viHpJSFhAoHcPx9JfYsEreJzg3K6C7BMw9eEnFVblECgYEAwWv4
        LqMXsJRiKSE6u1LMIsLZHKmsLd1cg946smB13cQTerVv6LcKr02AWggoOIGr5MAS
        Sl5QyqahjmKBdiA2G+zOwbvELUScSRPiHLXPhcjeif/rGvjUnROy4+xZJeJAv+W1
        thjUrl4QLo1mDBuNNEHIVt4lxWJeQ2i5K2Vazk0CgYEAiWGCG+628okESLiiFEpu
        VfKekfwaIlKfeibfFZ5DXhyQtON25R8tmcKe5h8Q8cvaix3XYnl+N55qFLmunTvo
        srYRr6v4UNBAyYc1DY2NbESiJJZpHW3FS8Dugp2pWJLZJRLT9B0S2hpZjEt34dbQ
        wpzsWwdWY0kxQh6ACyxqEkECgYAiqFUFDkYtZrkcA49Bh3l6dQ1wHFr0sOhl3IkJ
        80zLWtner+oIedvZQ3rPJw0F6v5A88WTO8kgNrFWEQJ/hxAK+uilQB7LubKDSaPH
        XzB7GV3+vjODVrjKGICCZJQovJy7hc6EfXiGceZWYRG686jehzb9kbqU3qZjT712
        MCgQNQKBgQDAAb7wkVrDjCjU/x7cIXRED+MrVDefLqRUb2zZP37wSuiJUCHmHshq
        C0UmlFVYYJrOd7DENavx4Orj0kg70jOIbnNqMkUOysN0oj7dIrSxdN5Gl1xwWHfz
        +QH9AwbxqjDMBwSWsFawkzcwQVNN9/SD9O9W4rzU/3E7T0kSeoJWJg==
        -----END RSA PRIVATE KEY-----
        private_key_type    rsa
        serial_number       65:b3:63:39:36:63:c3:b7:f4:c9:4f:8c:63:09:84:c8:b7:99:97:73
    
        $ vault write pki_int/issue/example-dot-com common_name="netology.example.com" ttl="24h" > netology.example.com.crt

Сохраняем сертификат в правильном формате

        vault write -format=json pki_int/issue/example-dot-com common_name="netology.example.com" ttl="24h" > netology.json
        cat netology.json | jq -r '.data.private_key' > netology.key
        cat netology.json | jq -r '.data.certificate' > netology.pem && cat netology.json | jq -r '.data.issuing_ca' >> netology.pem

5. Поднимите на localhost nginx, сконфигурируйте default vhost для использования подписанного Vault Intermediate CA сертификата и выбранного вами домена. Сертификат из Vault подложить в nginx руками.

sudo nano /etc/nginx/sites-enabled/default

    server {  
            # SSL configuration
            listen 443 ssl default_server;
            listen [::]:443 ssl default_server;
            ssl_certificate /home/vagrant/netology.pem;
            ssl_certificate_key /home/vagrant/netology.key;
    
sudo systemctl restart nginx

6. Модифицировав /etc/hosts и системный trust-store, добейтесь безошибочной с точки зрения HTTPS работы curl на ваш тестовый домен (отдающийся с localhost).


     vagrant@vagrant:~$ curl https://netology.example.com
     curl: (6) Could not resolve host: netology.example.com

        vagrant@vagrant:~$ sudo cp /home/vagrant/intermediate.cert.pem /usr/local/share/ca-certificates/intermediate.cert.crt
        vagrant@vagrant:~$ sudo update-ca-certificates
        Updating certificates in /etc/ssl/certs...
        1 added, 0 removed; done.
        Running hooks in /etc/ca-certificates/update.d...
        done.

        vagrant@vagrant:~$ sudo nano /etc/hosts
                127.0.0.1       localhost netology.example.com

    
    vagrant@vagrant:~$ curl https://netology.example.com
    <!DOCTYPE html>
    <html>
    <head>
    <title>Welcome to nginx!</title>
    <style>
        body {
            width: 35em;
            margin: 0 auto;
            font-family: Tahoma, Verdana, Arial, sans-serif;
        }
    </style>
    </head>
    <body>
    <h1>Welcome to nginx!</h1>
    <p>If you see this page, the nginx web server is successfully installed and
    working. Further configuration is required.</p>
    
    <p>For online documentation and support please refer to
    <a href="http://nginx.org/">nginx.org</a>.<br/>
    Commercial support is available at
    <a href="http://nginx.com/">nginx.com</a>.</p>
    
    <p><em>Thank you for using nginx.</em></p>
    </body>
    </html>
    
7. Ознакомился. Но на сегодня применить негде