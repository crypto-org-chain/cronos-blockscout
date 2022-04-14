#!/bin/bash

set -e

cd /opt/app

# Create needed for first time usage, won't do anything otherwise
# migrate is importatnt to run before application
/usr/local/bin/mix do ecto.create, ecto.migrate

/usr/local/bin/mix phx.server