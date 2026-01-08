# Minecraft Server Infrastructure | Oracle Cloud

<img width="950" height="247" alt="image" src="https://github.com/user-attachments/assets/820aed1f-2ae0-4c79-bf64-a2907d741703" />

A robust, Docker-based Minecraft server setup. This project is designed to be easy to configure, secure, and performant out of the box.
Hosted on Oracle Cloud using ARM architecture.

<img width="474" height="292" alt="image" src="https://github.com/user-attachments/assets/89745642-f241-4e80-8d8d-bfee757b7a8f" />


## Features

- **Dockerized**: Runs in an isolated container using the industry-standard `itzg/minecraft-server` image.
- **Multi-Loader Support**: Ready for Vanilla, NeoForge, Fabric, or Paper.

* **Configuration as Code**: All gameplay and infrastructure settings are managed via a single `.env` file.
* **Optimized**: Includes tuned JVM flags (ZGC) for low-latency garbage collection.
* **Management Tools**: Includes a `Makefile` for easy console access and lifecycle management.

## Prerequisites

- [Docker](https://www.docker.com/get-started) & Docker Compose
- [Make](https://www.gnu.org/software/make/) (Optional, for using helper commands)

## Quick Start

1.  **Clone the repository**

    ```bash
    git clone <your-repo-url>
    cd mc-infrastructure
    ```

2.  **Configure Environment**
    Create your local configuration file from the example:

    ```bash
    cp .env.example .env
    ```

    _Edit `.env` to set your desired Minecraft version, memory limits, and difficulty._

3.  **Start the Server**

    ```bash
    make up
    # Or using standard docker compose:
    docker compose up -d
    ```

4.  **Access Console**
    To run commands (op, gamemode, etc.):
    ```bash
    make console
    ```

## Memory Management Explained

This setup uses two distinct memory settings to ensure stability.

1.  **`MC_MEMORY` (Java Heap)**

    - _What it is:_ The memory allocated strictly to the Java Virtual Machine (JVM) Heap. This is where the game data (chunks, entities, mods) lives.
    - _Recommendation:_ Set this based on your modpack size (e.g., `4G` for vanilla/light mods, `8G+` for heavy packs).

2.  **`MC_MAX_MEMORY` (Docker Container Limit)**
    - _What it is:_ The hard limit for the Docker container. If the container exceeds this, Docker will kill it (OOM Kill).
    - _Why it's higher:_ The JVM needs memory **outside** the heap for:
      - Metaspace (Class metadata)
      - Thread Stacks
      - Code Cache (JIT compiled code)
      - Garbage Collector overhead
      - Direct Byte Buffers (Netty IO)

**Rule of Thumb:** Always keep `MC_MAX_MEMORY` at least **1GB - 2GB higher** than `MC_MEMORY`.

- _Example:_ If `MC_MEMORY=4G`, set `MC_MAX_MEMORY=6G`.

## Configuration

All settings are located in `.env`.

| Category           | Variable           | Description                                                     |
| ------------------ | ------------------ | --------------------------------------------------------------- |
| **Infrastructure** | `MC_SERVER_PORT`   | The external port for players to connect (Default: 25565)       |
| **Java**           | `MC_JVM_OPTS`      | Advanced Java flags. Default is tuned for ZGC (Java 21+).       |
| **Game**           | `MC_DIFFICULTY`    | Game difficulty (PEACEFUL, EASY, NORMAL, HARD)                  |
| **Game**           | `MC_VIEW_DISTANCE` | How many chunks players can see. Lower this if lag occurs.      |
| **Auto-Pause**     | `MC_AUTOPAUSE_*`   | Settings to pause the server when no one is online to save CPU. |

## Project Structure

- `docker-compose.yaml`: The infrastructure definition.
- `.env`: Your local secrets and config (Not committed to git).
- `Makefile`: Shortcuts for managing the server.
- `data/`: **(Important)** Contains your world save, `server.properties`, and installed mods. This folder persists across restarts.
- `server_mods/`: A local staging folder for mods (if you use custom sync scripts).

## Common Commands

| Command        | Action                                             |
| -------------- | -------------------------------------------------- |
| `make up`      | Start the server in the background.                |
| `make stop`    | Stop the server gracefully.                        |
| `make restart` | Restart the server.                                |
| `make logs`    | View live server logs (Press Ctrl+C to exit).      |
| `make console` | Enter the interactive RCON console.                |
| `make rebuild` | Rebuild the container (use after changing `.env`). |
