# Building xmrig

The build process uses docker. We start a new container using the `alpine` image, install some build dependencies, build the app, and finally distribute the app to the configured dist path (default is `/xmrig`). This process can automatically update the pre-compiled binary that is injected into the standard `patsissons/xmrig` image.

## Example

```bash
# build the xmrig development container image and generate the binaries
docker pull alpine
docker build -t patsissons/xmrig:build build
docker run --rm -v $PWD/root/xmrig:/xmrig patsissons/xmrig:build

# push the latest build container if any changes are made
docker push patsissons/xmrig:build

# build the xmrig runtime container image
docker build -t patsissons/xmrig:develop .

# push the latest xmrig binary to git and trigger a new docker build
git add root/xmrig/xmrig
git commit -m "publishing latest xmrig binary"
git push origin 
```

## Environment

You can adjust the following docker environment variables to customize the build process.

* `REPO_URI`: use a custom git repo for `xmrig` (default is `https://github.com/xmrig/xmrig.git`)
* `DIST_PATH`: use a custom dist path (default is `/xmrig`)

## Development Notes

If you want to play around with the development environment, simply run the container with a shell command. All scripts related to the build process are located in `/scripts`.

```bash
docker run --rm -it patsissons/xmrig:build /bin/sh
```
