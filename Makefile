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
	$(DC) exec -i mc rcon-cli

wh-add:
	$(DC) exec -i mc rcon-cli whitelist add $(name)

wh-remove:
	$(DC) exec -i mc rcon-cli whitelist remove $(name)

wh-list:
	$(DC) exec -i mc rcon-cli whitelist list
