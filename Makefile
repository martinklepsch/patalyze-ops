SHELL := /usr/local/bin/fish

setup_db:
		overcast run patalyze.db install/docker
		overcast run patalyze.db "sudo apt-add-repository ppa:fish-shell/release-2" "sudo apt-get update" "sudo apt-get -y install fish" "chsh -s `which fish`"
		overcast run patalyze.db "set -U DB_PRIVATE (ifconfig eth1 | grep 'inet addr' | awk -F: '{print \$$2}' | awk '{print \$$1 }')"

setup_indexer:
		overcast run patalyze.indexer install/docker
		overcast run patalyze.indexer "sudo apt-add-repository ppa:fish-shell/release-2" "sudo apt-get update" "sudo apt-get -y install fish" "chsh -s `which fish`"
		overcast run patalyze.indexer "set -U INDEXER_PRIVATE (ifconfig eth1 | grep 'inet addr' | awk -F: '{print \$$2}' | awk '{print \$$1 }')"

deploy_db:
		overcast run patalyze.db "rm -rf /root/patalyze-ops"
		overcast push patalyze.db (pwd) /root/
		# overcast run patalyze.db "docker rmi riemann dockerfile/elasticsearch"
		overcast run patalyze.db "docker build -t riemann /root/patalyze-ops/riemann/"

deploy_indexer:
		overcast run patalyze.indexer "rm -rf /root/patalyze-ops"
		overcast push patalyze.indexer (pwd) /root/
		# overcast run patalyze.indexer "docker rmi indexer"
		overcast run patalyze.indexer "docker build -t indexer /root/patalyze-ops/indexer/"

reset_db:
		overcast run patalyze.db "docker stop (docker ps -a -q)" "docker rm (docker ps -a -q)"

reset_indexer:
		overcast run patalyze.indexer "docker stop (docker ps -a -q)" "docker rm (docker ps -a -q)"

run_db:
		overcast run patalyze.db "docker run -d -p \$$DB_PRIVATE:5555:5555 -p \$$DB_PRIVATE:5555:5555/udp -p 5556:5556 -v /root/patalyze-ops/riemann:/data riemann"
		overcast run patalyze.db "docker run -d -p \$$DB_PRIVATE:9200:9200 -p \$$DB_PRIVATE:9300:9300 -v /root/patalyze-ops/elasticsearch:/data dockerfile/elasticsearch /elasticsearch/bin/elasticsearch -d es.config=/data/elasticsearch.yml"

run_indexer:
		overcast run patalyze.indexer "docker run -d -p 127.0.0.1:42042:42042 -e \"DB_PRIVATE=\$$DB_PRIVATE\" -v /root/patalyze-ops/indexer:/data indexer"

.PHONY: setup_db setup_indexer deploy run
