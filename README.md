# mruby-forwardable

Forwardable module for mruby (ported from CRuby).

## Install
add conf.gem to `build_config.rb`:

    MRuby::Build.new do |conf|
    
      # ... (snip) ...
    
      conf.gem :github => 'takahashim/mruby-forwardable'
    end

## Limitation

* This libarary does not support object-level delegation and SingleForwardable yet.

## History

* v0.2.0: support `mruby-metaprog` (by @udzura)
* v0.1.0: initial version

## License

BSDL from CRuby's

## Author

Original library in CRuby is written by Keiju ISHITSUKA.

mruby version of this library is ported by Masayoshi Takahashi.
