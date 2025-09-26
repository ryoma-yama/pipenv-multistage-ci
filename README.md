# pipenv-multistage-ci
Minimal example of a GitHub Actions CI/CD pipeline using Docker multi-stage builds with Pipenv. Runs tests inside a temporary build stage and only builds the final image if tests pass.
