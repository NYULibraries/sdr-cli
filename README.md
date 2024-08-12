# SdrCli

SDR CLI is a command line tool that wraps the `Geocombine` utility to manage metadata for the Spatial Data Repository (SDR).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add sdr_cli

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install sdr_cli

## Usage

- `sdr-cli audit` compares a local NYU metadata repo with what's available in NYU GeoServer instances
  - Example: `sdr-cli audit --directory tmp/opengeometadata/edu.nyu --destination tmp`
- `sdr-cli clone` clones all OGM repositories or pass --repo to clone a specific repository
- `sdr-cli help [COMMAND]` describe available commands or one specific command
- `sdr-cli index` index a directory of geospatial documents to Solr
- `sdr-cli pull` updates all OGM repositories or pass --repo to update a specific repository
- `sdr-cli transform`  transforms a collection of GeoBlacklight 1.0 documents to OGM Aardvark

## Development

### Running Tests

After checking out the project, copy `.env.example` to `.env`. These variables will inform the `solr_wrapper` gem how to start up a Solr instance when running the test suite.

Then run the test suite with the following command:

```bash
$ bundle exec rake
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/NYULibraries/sdr-cli.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
