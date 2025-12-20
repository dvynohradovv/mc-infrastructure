CONTAINER_NAME = mc-neo-forge-server
DC = docker compose

# Server management commands
up:
	$(DC) up -d

stop:
	$(DC) stop

logs:
	$(DC) logs -f mc

rebuild:
	$(DC) down
	$(DC) up -d --build

clean:
	$(DC) down --rmi local --volumes --remove-orphans

# Minecraft server commands
console:
	docker exec -i $(CONTAINER_NAME) rcon-cli

wh-add:
	docker exec -i $(CONTAINER_NAME) rcon-cli whitelist add $(name)

wh-remove:
	docker exec -i $(CONTAINER_NAME) rcon-cli whitelist remove $(name)

wh-list:
	docker exec -i $(CONTAINER_NAME) rcon-cli whitelist list
