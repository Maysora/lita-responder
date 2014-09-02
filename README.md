# lita-responder

[![Build Status](https://travis-ci.org/Maysora/lita-responder.png?branch=master)](https://travis-ci.org/Maysora/lita-responder)
[![Code Climate](https://codeclimate.com/github/Maysora/lita-responder.png)](https://codeclimate.com/github/Maysora/lita-responder)
[![Coverage Status](https://coveralls.io/repos/Maysora/lita-responder/badge.png?branch=master)](https://coveralls.io/r/Maysora/lita-responder?branch=master)

**lita-responder** is a handler for [Lita](https://www.lita.io/) that responds to most command messages using stored key-value and optionally cleverbot

## Installation

Add lita-responder to your Lita instance's Gemfile at the end after all other handlers:

``` ruby
gem "lita-responder"
```

## Configuration

* `cleverbot` - set true to enable cleverbot responds to undefined messages, otherwise lita-responder will ignore them
```ruby
Lita.configure do |config|
  config.handlers.responder.cleverbot = true
end
```

## Usage

### Add key-value (group: admin, responder_admins)

```
lita, responder add REGEXP_KEY -> VALUE
```

example:

```
lita, responder add (web)?site.*boci(\s*studio)?(\s+.*)?\?$ -> http://www.bocistudio.com
```

will return `http://www.bocistudio.com` to any commands not used by other handlers which match the regexp (eg: `lita, site boci?`)

### Delete key-value (group: admin, responder_admins)

```
lita, responder delete REGEXP_KEY
```

### List key-value (group: admin, responder_admins)

```
lita, responder list
```

### Remove all key-value (group: admin)

```
lita, responder reset
```

## TODO

- allow multiple values for single key, value selected randomly
- allow room specific key-value
- I18n

## License

[MIT](http://opensource.org/licenses/MIT)
