vim-hy
======

A syntax file for [Hy](http://hylang.org).

Requires a Vim built with Python support and Hy installed so that Vim can load
it. You can verify this with

    :python import hy

which should not show an error.

Options
-------
Use `let g:hy_enable_conceal = 1` to enable support for concealing some
constructs with unicode glyphs. If this option is enabled, this

    (defn something [alpha beta]
      (sum (xi + x1 alpha) (range beta)))

will be displayed like this

    (ƒ something [α β]
      (∑ (xⁱ + x₁ α) (range β)))
