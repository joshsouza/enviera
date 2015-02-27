Enviera
===========

Enviera is a tool to go along with Puppet and Hiera that will allow you to see
all of the variables defined within Hiera for a particular environment
(or for Puppet, a set of facts)

:new: *v0.0.1 - Created*

Why it's useful
-------------------------

Hiera is a fantastic tool for separating your data from your code, particularly with Puppet. However, it serves a
very specific purpose: Find a value in a hierarchy of files, and return the first one found. Unfortunately this
means that it does not (nor does it entirely make sense for it to) allow you to query *all* the values that are
available. There are, however, times when this can be very useful for troubleshooting, migrating to hiera, or
understanding state. For example, if you wanted to know what defaults are presently would be provided to a particular
server, were you to change a fact about it (I.E. its role), how would you determine this? Presently, by reviewing
your hiera.yaml, and searching through your hierarchy manually.
Enter Enviera. Compile all the facts about the machine in question, and perform a lookup. This will provide you all
of the keys available, and their values (It shows the raw hiera values, so no worries if you're using eyaml etc...).
You can also do a hierarchy lookup, and it will tell you which hierarchy files are being polled for your data as well.
Hopefully this can be helpful in isolating what variables are being (or will be) assigned to your nodes.

Setup
-----

### Installing Enviera

    $ gem install enviera

Hiera Config
-----

Unless told otherwise, Enviera will use /etc/puppet/hiera.yaml for its hiera config. You can customize this, and
in certain events may even want to consider using a separate hiera file for your lookups (I.E. If you want to test,
or exclude certain files)


Configuration file for Enviera
----------------------------

Default parameters for the Enviera command line tool can be provided by creating a configuration YAML file.

Config files will be read first from `/etc/enviera/config.yaml`, then from `~/.enviera/config.yaml` and finally by anything referenced in the `ENVIERA_CONFIG` environment variable

The file takes any long form argument that you can provide on the command line. For example, to override the hiera config
path:
```yaml
---
hiera_config: /etc/hiera.yaml
```

Or to override to output JSON by default:
```yaml
---
output: json
```

Notes
-----

Enviera will use whatever backends you have configured, but unfortunately at this time only supports
files with a .yaml extension, and may not work properly with other backends (for determining the hierarchy).
This means JSON or hiera-file backends for sure don't work yet.

Troubleshooting
---------------

### Installing from behind a corporate/application proxy

    $ export HTTP_PROXY=http://yourcorporateproxy:3128/
    $ export HTTPS_PROXY=http://yourcorporateproxy:3128/

then run your install

    $ gem install enviera

Examples
-------

```bash
---
enviera hierarchy -s '{"::fqdn": "some.host.com"}' -c "/etc/puppet/hiera.yaml" -o "yaml"
```
Would show all files being used in the hierarchy for the given facts, using the specified hiera config, outputting in yaml format

```bash
---
enviera lookup -s '{"::fqdn": "some.host.com"}' -c "/etc/puppet/hiera.yaml" -m "classes" -o "json"
```
Would show all variables available in the hierarchy, and their values, for the given facts, using the specified hiera config, emulating the behavior of a 'hiera_include("classes")' and concatenating all results for the 'classes' parameter,
and outputting in json

Issues
------

If you have found a bug then please raise an issue on the github page.


Tests
-----

In order to run the tests, simply run cucumber in the top level directory of the project.

You'll need to have a few requirements installed:

expect (via yum/apt-get or system package)
aruba (gem)
cucumber (gem)
hiera (gem)

Kudos
-----

My hat is off to [Tom Poulton](http://github.com/TomPoulton) for the [hiera-eyaml](https://github.com/TomPoulton/hiera-eyaml) project, which I have mimicked the file structure of this project on. Without his incredibly clean, consise, and
well architected code it would have taken me much longer to figure out how to make a command-line gem.

Authors
-------

- [Josh Souza](http://github.com/joshsouza) - Author.