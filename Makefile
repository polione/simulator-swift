.PHONY: venv build run

venv:
	docker compose exec app bash -c 'python3 -m venv venv && . venv/bin/activate && python3 -m pip install -r requirements.txt'

build:
	docker compose exec app bash -c 'swift build'

run:
	docker compose exec app bash -c '. venv/bin/activate && swift run simulator-swift $(ARGS)'