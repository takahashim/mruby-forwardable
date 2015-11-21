#
# original comment:
#
#   forwardable.rb -
#       $Release Version: 1.1$
#       $Revision$
#       by Keiju ISHITSUKA(keiju@ishitsuka.com)
#       original definition by delegator.rb
#       Revised by Daniel J. Berger with suggestions from Florian Gross.
#
#       Documentation by James Edward Gray II and Gavin Sinclair

module Forwardable

  FILE_REGEXP = %r"#{Regexp.quote(__FILE__)}"

  @debug = nil
  class << self
    attr_accessor :debug
  end

  def instance_delegate(hash)
    hash.each do |methods, accessor|
      methods = [methods] unless methods.respond_to?(:each)
      methods.each do |method|
        def_instance_delegator(accessor, method)
      end
    end
  end

  def def_instance_delegators(accessor, *methods)
    methods.delete("__send__")
    methods.delete("__id__")
    methods.each do |method|
      def_instance_delegator(accessor, method)
    end
  end

  def def_instance_delegator(accessor, method, ali = method)
    # If it's not a class or module, it's an instance
    if self.class == Class || self.class == Module
      module_eval do
        define_method(ali) do |*args, &block|
          begin
            instance_variable_get(accessor).__send__(method.to_sym, *args, &block)
          rescue Exception
            unless Forwardable::debug
              $@.delete_if{|s| Forwardable::FILE_REGEXP =~ s}
            end
            ::Kernel::raise
          end
        end
      end
    else
      raise "Forwaradable not supported object-level delegation"
    end

  end

  alias delegate instance_delegate
  alias def_delegators def_instance_delegators
  alias def_delegator def_instance_delegator
end
