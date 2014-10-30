# smart-eval - helpful eval and re-eval for elisp

*Author:* Wilfred Hughes <me@wilfred.me.uk><br>
*Version:* 0.1<br>

## When evaluating an elisp buffer, we want the following features

1. Evaluate the current content.  This could either be the form
before point, the top-level form enclosing point, a region, or a
buffer.
 
2. Easily debug the current form, perhaps by giving a prefix
argument.

3. Force `defvar`, `defface` and `defcustom` to be re-evaluated (as
normally they do not override existing values).

4. Always open a debugger if the evaluation throws an error.

5. The ability to completely uneval (i.e. unload or forget)
our bindings.

Note that eval-last-sexp sets debug-on-error regardless of what it
was set to before.  Customise eval-expression-debug-on-error to
change it.  We need to think about what's best for smart-eval
(always debug, I think).

TODO: uneval / forget the bindings created in the current buffer or
with a given prefix.

---
Converted from `smart-eval.el` by [*el2markdown*](https://github.com/Lindydancer/el2markdown).
