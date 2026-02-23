## Docker Installation

### Why official repo?
The Ubuntu default repo often has outdated Docker versions.
The official Docker repo always provides the latest stable release.

### Why docker group?
Adding your user to the docker group allows running docker commands
without sudo every time, while keeping security intact.

### Why compose plugin?
Docker Compose lets you define and run multi-container applications
using a simple YAML file instead of long docker run commands.
