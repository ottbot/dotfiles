;;; rc-ocaml -- summary
;;; commentary:
;;; Use opam for ocaml tooling
;;; code:

(require 'rc-funs)

(defun rc/opam-env ()
  "Shell out to get the current opam environment."
  (car
   (read-from-string
    (shell-command-to-string "opam config env --sexp"))))

(defun rc/sync-opam-env ()
  "Update the environment based on current opam switch.  Inlcudes $PATH."
  (interactive)
  (dolist (val (rc/opam-env))
    (setenv (car val) (cadr val)))
  (rc/sync-exec-path))


(defun rc/opam-lisp-path ()
  "Get the path for opam's share site-lisp dir."
  (concat
   (rc/shell-command-to-trimmed-string "opam config var share")
   "/emacs/site-lisp"))

(defun rc/bsb-project-path ()
  "Get the Bucklescript project root dir or nil."
  (locate-dominating-file default-directory "bsconfig.json"))

(defun rc/dune-project-path ()
  "Get the Dune project root dir or nil."
  (locate-dominating-file default-directory "dune-project"))

(defun rc/ocaml-compile ()
  "Use bsb, dune, or just interactively call compile."
  (interactive)
  (let ((bsb (rc/bsb-project-path))
        (dune (rc/dune-project-path)))
    (cond
     (bsb (rc/compile-in-dir bsb "bsb"))
     (dune (rc/compile-in-dir dune "dune build"))
     (t (call-interactively 'compile)))))

(defun rc/ocamlformat-before-save ()
  "A named function for the ocamlformat save hook."
  (add-hook 'before-save-hook 'ocamlformat-before-save))

(defun rc/ocaml-hooks ()
  "The hooks for tuareg."
  (rc/sync-opam-env)
  (merlin-mode)
  (utop-minor-mode)
  (electric-pair-local-mode)
  (ocamlformat-before-save))


;;; ======================================================
;;; now the setup -- these packages are installed via opam

(rc/sync-opam-env)
(add-to-list 'load-path (rc/opam-lisp-path))

(use-package merlin
  :custom
  (merlin-completion-with-doc t))

(use-package dune)

(use-package tuareg
  :mode ("\\.ml[ip]?\\'" . tuareg-mode)
  :bind ("C-c c" . rc/ocaml-compile)
  :config
  (add-hook 'tuareg-mode-hook 'rc/ocaml-hooks))

(use-package ocamlformat
  :custom
  (ocamlformat-enable 'enable-outside-detected-project)
  (ocamlformat-show-errors nil))

(use-package utop
  :custom
  (utop-command "dune utop . -- -emacs"))

(use-package ocp-indent)

(provide 'rc-ocaml)
;;; rc-ocaml.el ends here
