# Larrow::Runner

It is a command line tool with the following goals:

* build your application
* make a quick image for developer
* save best practices on devops of your team
* help to build the CI service

## Installation

Add this line to your application's Gemfile:
```
$ gem 'larrow-runner'
```

And then execute:
```
$ bundle
```

Or install it yourself as:
```
$ gem install larrow-runner
```

You should setup your cloud access ( why qingcloud ? ) before using larrow

```
$ larrow login
please setup your account of Qing Cloud:
    access id: ******
    secret key: ******
    keypair id: ******
    zone_id(default: pek1): pek1
Congratulation! Now you can use larrow to help your develop works.
```

## Usage

### testing

unit test, integration test, system test, etc.)
```
$ larrow go <source_url>
```

### application startup

make a standalone application and start it(if necessary)
```
$ larrow build server <source_url>
```

### build image

use image to speed-up your development

* build a image of your application
```
$ larrow build image <source_url>
```

* build a image from local LarrowFile
```
$ larrow build image <larrow_file_path>
```

## Larrow File

Larrow need to know how to setup/make/install/start... your application. So developer could write a `Larrow File` to declare these things.

Larrow can be used as a CI worker like travis. 
## Contributing

1. Fork it ( http://github.com/fsword/larrow-core/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
