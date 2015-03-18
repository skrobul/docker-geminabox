# docker-geminabox-secured

A docker container with a simple Gem in a Box server listening on port 9292 (behind WEBRick)
It is based on
[lheinlen/docker-geminabox](https://github.com/lheinlen/docker-geminabox/)
but enables basic HTTP authentication for upload or deletion. Please note that
unlike other containers, it does not require authentication for read/download
access.

## Usage

To run the container, execute the following command:

```
docker run -d -p 9292:9292 \
-e GEMS_USERNAME=uploaduser -e GEMS_PASSWORD=uploadpass skrobul/geminabox
```

### Additional configuration

The gem data is stored in a volume at /opt/geminabox/data.  You may wish to map it to a location on the host to simplify persisting the data between container upgrades.

```
docker run -d -p 9292:9292 -v /var/lib/geminabox-data:/opt/geminabox/data:rw skrobul/geminabox
```

By default, support for legacy indexes is disabled.  This can be enabled by setting the environment variable BUILD_LEGACY to true.

```
docker run -d -p 9292:9292 -e BUILD_LEGACY=true skrobul/geminabox
```

You can also enable Gem in a Box's ability to proxy rubygems.org with the RUBYGEMS_PROXY environment variable.

```
docker run -d -p 9292:9292 -e RUBYGEMS_PROXY=true skrobul/geminabox
```

The API access is restricted by default. In order to use it, you have to
specify GEMS_API_KEY environment variable:

```
docker run -d -p 9292:9292 -e GEMS_API_KEY=13bbbbjkh9d7a98789 skrobul/geminabox
```

## Building

In general, the simplest way to acquire the image is to pull it from the docker index:

```
docker pull skrobul/docker-geminabox
```

If you wish to build the image yourself, you can execute the following command:

```
docker build github.com/skrobul/docker-geminabox
```

