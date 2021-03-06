;;; packages.el --- myemacs layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Jing
;; URL: to be set...
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `myemacs-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `myemacs/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `myemacs/pre-init-PACKAGE' and/or
;;   `myemacs/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:


(defconst myemacs-packages
  '(
    (elisp-demos :location (recipe :repo "xuchunyang/elisp-demos"
                                   :fetcher github
                                   :files ("*.el" "*.org")))

    (org-roam :location (recipe :repo "org-roam/org-roam" :fetcher github :branch "master"))
    (org-roam-server)
    (org)
    (org-noter)
    (ox-reveal)
    (company-tabnine)
    (gomacro-mode)
    (hideshow)
    (ob-mermaid)
    (exercism :location local)
    (devdocs :location local))
  "The list of Lisp packages required by the myemacs layer.

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


;;; packages.el ends here

(defun myemacs/init-gomacro-mode()
  (use-package gomacro-mode
    :hook (go-mode . gomacro-mode)))

(defun myemacs/init-org-roam()
  (use-package org-roam
    :after org
    :hook
    ((org-mode . org-roam-mode))
    :custom
    (org-roam-directory "~/Dropbox/myorgs/to_be_architecter")
    :config
    (require 'org-roam-protocol)
    :init
    (progn
      (spacemacs/declare-prefix "ar" "org-roam")
      (spacemacs/set-leader-keys
       "arl" 'org-roam
       "ari" 'org-roam-insert
       "arf" 'org-roam-find-file
       "arg" 'org-roam-graph))))

(defun myemacs/init-ox-reveal ()
  (use-package ox-reveal
    :after org))

(defun myemacs/init-org-noter()
  (use-package org-noter
    :after org
    :config
    (setq org-noter-always-create-frame nil
          org-noter-insert-note-no-questions t
          org-noter-separate-notes-from-heading t
          org-noter-auto-save-last-location t)

    (defun org-noter-init-pdf-view()
      (pdf-view-fit-page-to-window)
      (pdf-view-auto-slice-minor-mode)
      (run-at-time "0.5 sec" nil #'org-noter))

    (defun org-noter-init-epub-view()
      "what the fuck"
      ())

    (add-hook 'nov-mode-hook 'org-noter-init-epub-view)
    (add-hook 'pdf-view-mode-hook 'org-noter-init-pdf-view)))

(defun myemacs/init-org-roam-server()
  (use-package org-roam-server
    :custom
    (org-roam-server-port 9487)
    :ensure t))

(defun myemacs/post-init-org()
  (spacemacs|use-package-add-hook org
    :post-config (add-to-list 'org-babel-load-languages '(mermaid . t))))

(defun myemacs/init-ob-mermaid ()
  (use-package ob-mermaid))

(defun myemacs/init-company-tabnine ()
  (use-package company-tabnine
    :ensure t
    ))

(defun myemacs/post-init-company-tabnine()
  (with-eval-after-load 'company
    (add-to-list 'company-backends #'company-tabnine)
    (setq company-show-numbers t)
    (setq company-idle-delay 0)))

;;; set up the hideshow mode

(defun myemacs/init-hideshow()
  (use-package hideshow
    :hook ((prog-mode . hs-minor-mode))))

;;; my exercism package

(defun myemacs/init-exercism ()
  (use-package exercism
    ;; :defer t
    ))

(defun myemacs/init-devdocs ()
  (use-package devdocs
    ;; 
    ))

(defun myemacs/init-elisp-demos ()
  (use-package elisp-demos
    :config
    (progn
      (advice-add 'describe-function-1
                  :after #'elisp-demos-advice-describe-function-1))))
