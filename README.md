# rubinius-memoize

Method memoization using [Rubinius][rubinius] AST transforms.

## Installation

Add this line to your application's Gemfile:

    gem 'rubinius-memoize'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubinius-memoize

## Caveats

For now it only supports methods with zero arguments.

Also, it only works on Rubinius 2.0+.

### Warning if you don't use Bundler (if you do you're fine)

Since it extends the compiler at runtime, from the moment that you `require
'rubinius/memoize'`, the `memoize` method will only be available in files
*required* after that.

That means that *this won't work*:

```ruby
# shawarma.rb
require 'rubinius/memoize'

class Shawarma
  memoize def foo
    3
  end
end
```

But *this will*:

```ruby
# some_other_file.rb
require 'rubinius/memoize'
require 'shawarma'
```

## Usage

```ruby
class Shawarma
  memoize foo
    expensive_operation
  end
end

adonis = Shawarma.new
adonis.foo # takes a while
adonis.foo # instant!

# Want to expire the memoized method? Be my guest:
Rubinius::Memoize.expire(adonis, :foo)

adonis.foo # takes a while again
```

## Who's this

This was made by [Josep M. Bach (Txus)](http://about.me/txustice) under the MIT
license. I'm [@txustice][twitter] on twitter (where you should probably follow
me!).

[twitter]: https://twitter.com/txustice
[rubinius]: http://rubini.us
