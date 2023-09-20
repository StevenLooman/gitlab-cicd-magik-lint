# Magik-lint Docker image for GitLab CI/CD

Docker image to easily run magik-lint in GitLab CI/CD.

## Usage

To set this up in your GitLab CI/CD you need to do the following:

- Create token in your [profile](https://gitlab.com/profile/personal_access_tokens) or in your project,
  at Project Access Tokens.
- Create a CI/CD Variable in your project, called `REVIEWDOG_GITLAB_API_TOKEN`,
  with the token-value created in the previous step.
- Example `.gitlab.yml` for the project:

```yaml
default:
  image: alpine:3.18  # XXX TODO

stages:
  - lint

magik-lint:
  stage: lint
  script:
    - apk add --no-cache curl=8.2.1-r0 openjdk17-jre-headless=17.0.8_p7-r0
    - mkdir -p /tmp/magik-lint
    - curl -sfL -o /tmp/magik-lint/magik-lint-0.7.1.jar https://github.com/StevenLooman/magik-tools/releases/download/0.7.1/magik-lint-0.7.1.jar
    - mkdir -p /tmp/reviewdog
    - curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b /tmp/reviewdog v0.15.0
    - java -jar /tmp/magik-lint/magik-lint-0.7.1.jar --column-offset +1 --msg-template "\${path}:\${line}:\${column}:\${msg} (\${symbol})" ${CI_PROJECT_DIR} | /tmp/reviewdog/reviewdog -efm="%f:%l:%c:%m" -name="magik-lint" -reporter=gitlab-mr-discussion -level=error -filter-mode=added -fail-on-error=false
```

## Environment variables

### `INPUT_GITLAB_TOKEN`

GitLab token to use, required.

### `INPUT_MAGIK_TOOLS_VERSION`

The version of magik-tools to use.

Defaults to `0.7.1`.

### `INPUT_REPORTER`

Reporter of reviewdog command [`gitlab-mr-discussion`,`gitlab-mr-commit`].

Defaults to `gitlab-mr-discussion`.

### `INPUT_LEVEL`

Report level for reviewdog [`info`,`warning`,`error`]

Defaults to `error`.

### `INPUT_FILTER_MODE`

Filtering mode for the reviewdog command [`added`,`diff_context`,`file`,`nofilter`].

Defaults to `added`.

### `INPUT_FAIL_ON_ERROR`

Exit code for reviewdog when errors are found [`true`,`false`].

Defaults to `false`.

### `INPUT_REVIEWDOG_FLAGS`

Additional reviewdog flags.

Defaults to `""`.

### `INPUT_RUNNER_DEBUG`

Enable magik-lint debug flags [`0`, `1`].

Defaults to `0`.
