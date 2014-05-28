SHELL := /usr/local/bin/fish

setup:
		overcast run install/docker
		overcast run patalyze.db "sudo apt-add-repository ppa:fish-shell/release-2" "sudo apt-get update" "sudo apt-get install fish" "chsh -s (which fish)"
		overcast run patalyze.db "set -U DB_PRIVATE (ifconfig eth1 | grep 'inet addr' | awk -F: '{print \$$2}' | awk '{print \$$1 }')"
		overcast run patalyze.db "docker stop (docker ps -a -q)" "docker rm (docker ps -a -q)"

deploy:
		overcast run patalyze.db "rm -rf /root/patalyze-ops"
		overcast push patalyze.db (pwd) /root/
		overcast run patalyze.db "docker stop (docker ps -a -q)" "docker rm (docker ps -a -q)"
		overcast run patalyze.db "docker rmi riemann dockerfile/elasticsearch"
		overcast run patalyze.db "docker build -t riemann /root/patalyze-ops/riemann/"

run:
		overcast run patalyze.db "docker run -d -p \$$DB_PRIVATE:5555:5555 -p \$$DB_PRIVATE:5555:5555/udp -p 5556:5556 -v /root/patalyze-ops/riemann:/data riemann"
		overcast run patalyze.db "docker run -d -p \$$DB_PRIVATE:9200:9200 -p \$$DB_PRIVATE:9300:9300 -v /root/patalyze-ops/elasticsearch:/data dockerfile/elasticsearch /elasticsearch/bin/elasticsearch -D es.config=/data/elasticsearch.yml"

.PHONY: push run
