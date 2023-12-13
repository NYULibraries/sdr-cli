# SdrCli

SDR CLI is a command line tool that wraps the `Geocombine` utility to manage metadata for the Spatial Data Repository (SDR).
Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/sdr_cli`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add sdr_cli

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install sdr_cli

## Usage

### Commands:
`sdr-cli clone`           clones all OGM repositories or pass `--repo`to clone a specific repository

`sdr-cli help [COMMAND]`  Describe available commands or one specific command

`sdr-cli index`        index a directory of geospatial documents to Solr

`sdr-cli pull`    updates all OGM repositories or pass `--repo` to update a specific repository

`sdr-cli transform`      transforms a collection of GeoBlacklight 1.0 documents to OGM Aardvark

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/NYULibraries/sdr-cli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
