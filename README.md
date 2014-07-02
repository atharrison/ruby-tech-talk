ruby-tech-talk
=================

### Quick Notes
Put your code in `lib/techtalk/*.rb`

Call your code via Thor commands in `lib/techtalk/cli.rb`

Run with `./bin/techtalk-cli`

## Installation

Install Ruby 2.1, on your local machine.

https://www.ruby-lang.org/en/installation/

Windows: https://www.ruby-lang.org/en/installation/#rubyinstaller

OSX: https://www.ruby-lang.org/en/installation/#homebrew

Linux: https://www.ruby-lang.org/en/installation/#rvm

Verify version:

    ruby --version
    # ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-linux]


Clone (or fork) this repo:

    git clone git@github.com:atharrison/ruby-tech-talk.git
    cd ruby-tech-talk

Run Bundle to pull down the needed external dependencies

    bundle update

Confirm that you can run the test task:

    ./bin/techtalk-cli test
    # Test passes!


## Exercise

Problem: Aggregating deliverability metrics

Goals:

  * Read data from S3
  * Manipulate, Aggregate the data
  * Push data into Graphite

Data:

  * From- Subject Line Stream
  * Determine- delivery by IP, campaign, domain
