# Containerized SvelteKit

**WARNING:** I made this for personal use, to have a repo I can quickly reference when I'm starting a new project. My suggestion would be to copy/paste Dockerfile, compose.yaml, compose.production.yml and .dockerignore into the folder created after you run `npx create-svelte-app` instead of cloning this repository since create-svelte-up keeps things up to date for you.

For your environment variables, you'll need two files:

- .env for your local development variables
- .env.production for your production variables

For production, run `docker compose -f compose.production.yml up -d --build`. Note that you need to set up an adapter (likely node) instead of using the current command, which can be edited in the last line in Dockerfile. Currently this runs the Vite preview server, which shouldn't be used in production.

For development, run `docker compose up -d --build` and develop like you would normally. There is an example database, too. Uncomment the lines and it should work and be accessible to the container using the hostname `db` (`localhost` doesn't work in containers). Look at the environment variables you can specify to configure the database, then add them to `.env` to configure it.
