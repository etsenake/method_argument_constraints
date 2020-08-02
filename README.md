# Method argument constraints
Gem for setting constraints on method arguments. Very similar to [contracts](https://github.com/egonSchiele/contracts.ruby) but a bit simpler. It also does not validate the return of method.
 - It leverages classes already existing in your project when validating when doing direct comparison (more to come on this later)
 - It allows you to define customized constraints easily when what you want to do is a bit atypical ie pass a proc or define a method in your class and pass the name as a symbol
 
 ## Installation

Add this line to your application's Gemfile:

```ruby
gem 'method_argument_constraints'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install method_argument_constraints

## Usage
To set requirements based on an already existing class you'd do it like so: 
```ruby
class A
  def hi(friend)
  method_constraints!(binding, friend: String)
    puts "hi #{friend}"
  end
end
```

If the kind of constraint isn't as straightforward as just a `is_a?` comparison you could do it one of two other ways 
```ruby
class A
  def hi(number)
  my_proc = Proc.new{|arg_value, _arg_name| arg_value.is_a? Integer && arg_value > 1 }
  method_constraints!(binding, friend: my_proc)
    puts "number: #{number}"
  end
end
```
or

```ruby
class A
  def my_validation_method(arg_value, _arg_name)
    arg_value.is_a? Integer && arg_value > 1
  end

  def hi(number)
  method_constraints!(binding, friend: :my_validation_method)
    puts "number: #{number}"
  end
end
```

Note that: When using a Proc or method the return value must always be a boolean value

Why do we need to pass the current binding? This allows the gem to access the arguments, and parameters the method we want to validate was called with.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/method_argument_constraints. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/method_argument_constraints/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RequiredMethodArguments project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/method_argument_constraints/blob/master/CODE_OF_CONDUCT.md).
