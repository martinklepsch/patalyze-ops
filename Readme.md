# Setup database server

### Once
```sh
overcast run patalyze.db "sudo apt-add-repository ppa:fish-shell/release-2" "sudo apt-get update" "sudo apt-get install fish" "chsh -s (which fish)"
overcast run patalyze.db "set -U DB_PRIVATE (ifconfig eth1 | grep 'inet addr' | awk -F: '{print \$2}' | awk '{print \$1 }')"
# overcast run patalyze.db "echo (ifconfig eth1 | grep 'inet addr' | awk -F: '{print \$2}' | awk '{print \$1 }') db.private >> /etc/hosts"

overcast run patalyze.db "mkdir -p /data/elasticsearh"
overcast run patalyze.db "mkdir -p /data/riemann"

overcast run patalyze.db "docker stop (docker ps -a -q)" "docker rm (docker ps -a -q)"
```

### When updated
```
overcast push patalyze.db (pwd) /root/
```

### Riemann
```sh
overcast run patalyze.db "docker build -t riemann /root/patalyze-ops/riemann/"
overcast run patalyze.db "docker run -d -p \$DB_PRIVATE:5555:5555 -p \$DB_PRIVATE:5555:5555/udp -p 5556:5556 -v /root/patalyze-ops/riemann:/data riemann"
```

### Elasticsearch

Start a container by mounting data directory and specifying the custom configuration file:
```sh
overcast run patalyze.db "docker run -d -p \$DB_PRIVATE:9200:9200 -p \$DB_PRIVATE:9300:9300 -v /root/patalyze-ops/elasticsearch:/data dockerfile/elasticsearch /elasticsearch/bin/elasticsearch -Des.config=/data/elasticsearch.yml"
```

# Indexer


