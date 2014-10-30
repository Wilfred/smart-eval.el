;;; smart-eval.el --- helpful eval and re-eval for elisp

;; Copyright (C) 2014 Wilfred Hughes <me@wilfred.me.uk>
;;
;; Author: Wilfred Hughes <me@wilfred.me.uk>
;; Created: 18 October 2014
;; Version: 0.1
;; Package-Requires: ((shut-up "0.3"))

;;; Commentary:
;; When evaluating an elisp buffer, we want the following features:
;;
;; 1. Evaluate the current content.  This could either be the form
;; before point, the top-level form enclosing point, a region, or a
;; buffer.
;; 
;; 2. Easily debug the current form, perhaps by giving a prefix
;; argument.
;;
;; 3. Force `defvar', `defface' and `defcustom' to be re-evaluated (as
;; normally they do not override existing values).
;;
;; 4. Always open a debugger if the evaluation throws an error.
;;
;; 5. The ability to completely uneval (i.e. unload or forget)
;; our bindings.
;;
;; Note that eval-last-sexp sets debug-on-error regardless of what it
;; was set to before.  Customise eval-expression-debug-on-error to
;; change it.  We need to think about what's best for smart-eval
;; (always debug, I think).
;;
;; TODO: uneval / forget the bindings created in the current buffer or
;; with a given prefix.

;;; License:

;; This file is not part of GNU Emacs.
;; However, it is distributed under the same license.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:
;; (require 'shut-up)
(require 'edebug)
(require 'lisp-mode)

(defun smart-eval--eval (form)
  (with-temp-buffer
    (princ form (current-buffer))
    (edebug-eval-defun nil)))

;;;###autoload
(defun smart-eval-last-sexp ()
  "Evaluate the sexp before point.
If the sexp is a `defvar', `defcustom' or `defface' form,
reset the variable."
  (interactive)
  (let ((form (preceding-sexp)))
    (smart-eval--eval form)))

;;;###autoload
(defun smart-eval-outer-sexp ()
  "Evaluate the top-level sexp that point is currently inside."
  (interactive)
  (smart-eval--eval (edebug-read-top-level-form)))

;;;###autoload
(defun smart-eval-region (beg end)
  "Evaluate all sexps in the region."
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (< (point) end)
      (forward-sexp)
      (shut-up
        (smart-eval-outer-sexp)))))

;;;###autoload
(defun smart-eval-buffer ()
  "Evaluate the current buffer."
  (interactive)
  (smart-eval-region (point-min) (point-max)))

(provide 'smart-eval)
;;; smart-eval.el ends here
