(define-key global-map [f6] 'my-ido-project-files)

(windmove-default-keybindings)
(setq framemove-hook-into-windmove t)

(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)

(global-set-key (kbd "M-N") 'forward-page)
(global-set-key (kbd "M-P") 'backward-page)

(global-set-key [f7] 'magit-status)
(global-set-key [f8] 'mu4e)

(global-unset-key (kbd "<C-down>"))
(global-unset-key (kbd "<C-up>"))

(global-unset-key (kbd "C-s"))
(global-set-key (kbd "C-s") 'swiper)


(global-unset-key (kbd "M-c"))
(global-set-key (kbd "M-c") 'ace-window)

(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
(autoload  'ace-jump-mode-pop-mark "ace-jump-mode" "Ace jump back:-)" t)

(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark)

;; remap C-a to `smarter-move-beginning-of-line
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)


(provide 'keybindings)
