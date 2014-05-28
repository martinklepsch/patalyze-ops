# Setup database server

```sh
overcast push patalyze.db (pwd) /root/
overcast run patalyze.db "sudo apt-add-repository ppa:fish-shell/release-2" "sudo apt-get update" "sudo apt-get install fish" "chsh -s (which fish)"
overcast run patalyze.db "set -U DB_PRIVATE (ifconfig eth1 | grep 'inet addr' | awk -F: '{print \$2}' | awk '{print \$1 }')"
# overcast run patalyze.db "echo (ifconfig eth1 | grep 'inet addr' | awk -F: '{print \$2}' | awk '{print \$1 }') db.private >> /etc/hosts"
```

### Riemann
```
overcast run patalyze.db "docker build -t riemann /root/patalyze-ops/riemann/"
overcast run patalyze.db "docker run -d -p \$DB_PRIVATE:5555:5555 -p \$DB_PRIVATE:5555:5555/udp -p 5556:5556 riemann"
```

### Elasticsearch

Create a mountable data directory <data-dir> (i.e /data) on the host.
```
overcast run patalyze.db "mkdir /data"
```

Create ElasticSearch config file at <data-dir>/elasticsearch.yml.
```
overcast push patalyze.db "../../code/patents/patalyze-ops/elasticsearch/elasticsearch.yml" /data/
```

Start a container by mounting data directory and specifying the custom configuration file:
```
overcast run patalyze.db "docker run -d -p \$DB_PRIVATE:9200:9200 -p \$DB_PRIVATE:9300:9300 -v /data:/data dockerfile/elasticsearch /elasticsearch/bin/elasticsearch -Des.config=/data/elasticsearch.yml"
```

# Indexer


