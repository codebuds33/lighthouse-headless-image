# Headless Lighthouse Audit image

The idea here is to be able to trigger Lighthouse audits without having to use anything installed on the computer.

In order to get this done the image has chromium installed and will run in the headless mode.

## How to use it

If you want to audit an url you can run the following code:

```shell script
docker run --rm -v ~/reports:/usr/src/app registry.codebuds.com/docker/lighthouse:latest -u https://site.mine
```

This will run the lighthouse audit for the given URL with and save the HTML file of the report in ~/reports.

## Options

There are certain more options that can be used :

- `-p`: This will help add more paths from the url to make it easy to audit multiple pages.
- `-n`: This allows you to set a name for the report instead of using the default one.
- `-o`: This allows to override the options that are used by default for the lighthouse audit. Because this is being run inside a docker container the default options are the following `--chrome-flags="--headless --no-sandbox" --no-enable-error-reporting`
- `-f`: This allows to change the emulated form factor, either 'mobile', 'desktop' or 'none'. Default: 'mobile'`
- `-t`: This allows to change the output either 'html', 'csv' or 'json'. Default: 'html'`

## Examples

```shell script
docker run --rm -v ~/reports:/usr/src/app codebuds/lighthouse audit -u https://site.mine -p /pageone,/page2,/page3
# This will run 4 lighthouse audits in a row. As the default names will be used in this case they will all have the same name (which is the url) with different times.

#To give custom names the following can be done
docker run --rm -v ~/reports:/usr/src/app codebuds/lighthouse audit -u https://site.mine -p /pageone,/page2,/page3 -n my-project
# This will create the following files :
# ~/reports/my-project.report.html
# ~/reports/my-project_page1.report.html
# ~/reports/my-project_page2.report.html
# ~/reports/my-project_page3.report.html
```

This is just a starting point we will add easier ways to trigger the JSON outputs and modify more options without having to change the whole `-o` option.

## Docker-compose

If you want to run this inside a docker-compose file you can do the following :

```yaml
version: '3.7'
services:
  lighthouse:
    build: .
    volumes:
      - ./reports:/usr/src/app
```

And run the commands as follows :

```shell script
docker-compose run --rm lighthouse audit -u https://site.mine
```
