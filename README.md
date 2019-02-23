vim-hy
======

A syntax file for [Hy](http://hylang.org).

Requires a Vim built with Python support and Hy installed so that Vim can load
it. You can verify this with

    :python import hy

which should not show an error.

Installation
------------

If you are using [Plug](https://github.com/junegunn/vim-plug), add this to your plugins list in `.vimrc`:

    Plug 'hylang/vim-hy'
    
Otherwise, install using whatever vim plugin approach you prefer.

Conceal support
---------------
Use `let g:hy_enable_conceal = 1` to enable support for concealing some
constructs with unicode glyphs. If this option is enabled, this

    (defn something [alpha beta]
      (sum (xi + x1 alpha) (range beta)))

will be displayed like this

    (ƒ something [α β]
      (∑ (x¡ + x₁ α) (range β)))

The full table of concealed symbols looks like this:

Symbol      | Display   | Symbol  | Display | Symbol    | Display
----------: | :-------- | ------: | :------ | --------: | :------
`fn`        | `λ`       | `and`   | `∧`     | `<=`      | `≤`
`lambda`    | `λ`       | `or`    | `∨`     | `>=`      | `≥`
`defn`      | `ƒ`       | `not`   | `¬`     | `!=`      | `≠`
`defn/a`    | `ƒa`      | `fn/a`  | `λa`    | `lfor`    | `s∀`
`sfor`      | `s∀`      | `dfor`  | `d∀`    | `gfor`    | `g∀`
`*`         | `∙`       | `->`    | `⊳`     | `None`    | `∅`
`math.sqrt` | `√`       | `->>`   | `‣`     | `math.pi` | `π`
`sum`       | `∑`       | `for`   | `∀`     | `some`    | `∃`
`in`        | `∈`       | `alpha` | `α`     | `gamma`   | `γ`
`not-in`    | `∉`       | `beta`  | `β`     | `delta`   | `δ`
`epsilon`   | `ε`       | `xi`    | `x¡`    | `#%`      | `x¡`
`x[0-9]`    | `x₀` - `x₉`

If you do `let g:hy_conceal_fancy=1`, `xi`  and `#%` are displayed as `ξ`.
