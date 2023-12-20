;;; packages.el --- rustic-l layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2023 Sylvain Benner & Contributors
;;
;; Author:  <kvitravn@ArchKorp>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `rustic-l-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `rustic-l/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `rustic-l/pre-init-PACKAGE' and/or
;;   `rustic-l/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst rustic-l-packages
  '(rustic
    lsp-ui
    company
    yasnippet
    dap-mode)
  "The list of Lisp packages required by the rustic-l layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun rustic-l/pre-init-rustic ()
  (use-package rustic
    :ensure
    :bind (:map rustic-mode-map
                ("M-j" . lsp-ui-imenu)))
)

(defun rustic-l/init-lsp-ui ()
  (use-package lsp-ui
    :ensure
    :commands lsp-ui-mode
    :custom
    (lsp-ui-peek-always-show t)
    (lsp-ui-sideline-show-hover t)
    (lsp-ui-doc-enable nil))
)

(defun rustic-l/pre-init-company ()
  (use-package company
    :ensure
    :custom
    (company-idle-delay 0.5) ;; how long to wait until popup
    ;; (company-begin-commands nil) ;; uncomment to disable popup
    :bind
    (:map company-active-map
	        ("C-n". company-select-next)
	        ("C-p". company-select-previous)
	        ("M-<". company-select-first)
	        ("M->". company-select-last)))
 )

(defun rustic-l/pre-init-yasnippet ()
  (use-package yasnippet
    :ensure
    :config
    (yas-reload-all)
    (add-hook 'prog-mode-hook 'yas-minor-mode)
    (add-hook 'text-mode-hook 'yas-minor-mode))
)

(defun rustic-l/init-dap-mode ()
  (use-package dap-mode
    :ensure
    :config
    (dap-ui-mode)
    (dap-ui-controls-mode 1)

    (require 'dap-lldb)
    (require 'dap-gdb-lldb)
    (require 'dap-cpptools)
    ;; installs .extension/vscode
    (dap-gdb-lldb-setup)
    (dap-register-debug-template
     "Rust::LLDB Run Configuration"
     (list :type "lldb"
           :request "launch"
           :name "LLDB::Run"
	         :gdbpath "rust-lldb"
           :target nil
           :cwd nil)))
)
