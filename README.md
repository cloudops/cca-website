BUILD REQUIREMENTS
==================

Install Dependencies
--------------------

We're using `hugow` which will download specified Hugo binary defined in `.hugo/version`
(currently: `v0.45.1`). If you need to use Hugo binary directly instead of `make` command,
make sure to execute: `./hugow` instead of plain `hugo`.

**MacOS or Linux**

Make sure `npm` is installed on your system.

```bash
npm install less -g
npm install uglifycss -g
npm install uglify-js -g
```

*MacOS*
```bash
brew install fswatch
```

*Linux*
```
# ref: https://github.com/emcrisostomo/fswatch
```

Build Project
-------------

```bash
make build
```

Pass additional arguments to the `hugo` command by using the following format.
```
make -- build --buildDrafts -b http://rebrand.cloud.ca
```

Run Project
-----------

```bash
make run
```

Pass additional arguments to the `hugo` command by using the following format.
```
make -- run --buildDrafts -b http://rebrand.cloud.ca
```

Watch For Changes
-----------------

Once you run `make run` you will want to have changes to the `less` and other files in the `static-src` folder to get rebuild.  In order to do this, we have a new `make watch` command.

```bash
# in a new terminal tab
make watch
```

Deploy Project
--------------
Deploy requires that you have an OpenStack Swift account which you can push the files to.  Additionally, deploy depends on the following syncing tool: https://github.com/swill/swiftly

Add the following details to the file: `./config.mk`
```
IDENTITY = <tenant>:<user>
PASSWORD = <password>
DOMAIN = <domain>
```

Then deploy:
```
make deploy
```
