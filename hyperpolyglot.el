;;; hyperpolyglot --- navigate hyperpolyglot.org from emacs -*- lexical-binding: t -*-

;; Author: Noah Peart <noah.v.peart@gmail.com>
;; URL: https://github.com/nverno/hyperpolyglot
;; Package-Requires: 
;; Copyright (C) 2016, Noah Peart, all rights reserved.
;; Created: 16 September 2016

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:

;;  Navigate hyperpolyglot.org from emacs.

;;; Code:

(defgroup hyperpolyglot nil
  "Jump around hyperpolyglot"
  :group 'convenience
  :prefix "hyperpolyglot-")

(defvar hyperpolyglot--rb nil)
(setq hyperpolyglot--rb
      (when load-file-name
        (expand-file-name "build/main.rb" (file-name-directory load-file-name))))

;;;###autoload
(defun hyperpolyglot (&optional arg)
  (interactive "P")
  ;; FIXME: multi-word languages, like emacs-lisp need to be quoted, eg.
  ;; "emacs lisp" functions
  (let* ((args (or arg (read-from-minibuffer "Hyperpolyglot: ")))
         (out (shell-command-to-string
               (format "ruby %s %s" hyperpolyglot--rb args)))
         (opts (split-string out "\n" t "\\s-*")))
    (cond
     ((= 1 (length opts))
      (if (string-prefix-p "http" (car opts))
          (browse-url (car opts))
        (hyperpolyglot (concat args " " (car opts)))))
     ((zerop (length opts))
      (message "Nothing found for %s" args))
     (t
      (let ((new-arg (completing-read "Section/ID: " opts)))
        (hyperpolyglot (concat args " " new-arg)))))))

(provide 'hyperpolyglot)

;;; hyperpolyglot.el ends here
