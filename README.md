BUILD REQUIREMENTS
==================

Install Dependencies
--------------------

We're using `hugow` which will download specified Hugo binary defined in `.hugo/version`
(currently: `v0.47.1`). If you need to use Hugo binary directly instead of `make` command,
make sure to execute: `./hugow` instead of plain `hugo`.

**MacOS or Linux**

*MacOS*

```bash
brew install fswatch
```

*Linux*

```bash
apt install inotify-tools
```

Prepare Project
-------------

This will concatenate all the configs in `configs/` folder to generate `config.toml`.

```bash
make prepare
```

Run Project
-----------

To run the site locally and access it on http://localhost:1313/

```bash
make run
```

Pass additional arguments to the `hugo` command by using the following format.

```bash
make -- run --buildDrafts --baseURL http://rebrand.cloud.ca
```

Watch For Changes
-----------------

Note: As of v0.43 Hugo introduced Asset Pipeline which atuomatically compiles and concatenate `scss` files and this make target has been adjusted accordingly and it only watch for any changes in `configs/` and `config.common.toml`. Technically we don't need to run this command in a new terminal anymore. But if you want to autobuild any changes to config without restarting hugo server you need to run the command in new terminal.

```bash
make watch
```

Build Project
-------------

To build the site and have it available in `public` folder.

```bash
make build
```

Pass additional arguments to the `hugo` command by using the following format.

```bash
make -- build --buildDrafts --baseURL http://rebrand.cloud.ca
```

**Note** when you run `make build` the `public` folder will be force deleted before being rebuilt.

Deploy Project
--------------

Deploy requires that you have an OpenStack Swift account which you can push the files to.  Additionally, deploy depends on the following syncing tool: https://github.com/swill/swiftly

Add the following details to the file: `./config.mk`

```toml
IDENTITY = <tenant>:<user>
PASSWORD = <password>
DOMAIN = <domain>
```

build first:

```bash
make build [-- additional flags]
```

then deploy:

```bash
make deploy
```
