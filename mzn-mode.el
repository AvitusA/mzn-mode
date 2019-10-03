
;;; Code:

(setq mzn-minizinc-binary "minizinc")


(setq mzn-keywords
  '("annotation"
    ;; "any" red
    ;; "case" red
    "constraint"
    "else"
    "elseif"
    "endif"
    ;; "false"
    "function"
    "if"
    "in"
    "include"
    "let"
    ;; "list"
    "maximize"
    "minimize"
    "op"
    ;; "opt"
    "output"
    "predicate"
    ;; "record"
    "satisfy"
    "solve"
    "test"
    "then"
    ;; "true"
    "type"
    "where"
    ))

(setq mzn-types
  '("var"
    "par"
    "bool"
    "int"
    "float"
    "string"

    "array"
    "enum"
    "of"
    "set"
    "tuple"))

(setq mzn-operators
      (concat "<\\->\\|\\->\\|<-\\|\\\\/\\|/\\\\\\|<\\|>=\\|<="
	      "\\|==\\|!=\\|>\\|++\\|+\\|-\\|*\\|/\\|\\.\\.\\|"
	      "=\\|\\<\\(superset\\|diff\\|symdiff\\|intersect"
	      "\\|div\\|mod\\|xor\\|in\\|subset\\|union\\|not\\)\\>"))

(setq mzn-literals
      ;; TODO these need to be verified Ex: 1.2 does not highlight the decimal sign
      (concat
       ; Boolean
       "false"
       "\\|true"
       
       ; Float
       "\\|0[xX]([0-9a-fA-F]*\"\.\"[0-9a-fA-F]+|[0-9a-fA-F]+\"\.\")([pP][+-]?[0-9]+)"
       "\\|(0[xX][0-9a-fA-F]+[pP][+-]?[0-9]+)"
       "\\|[0-9]+\"\.\"[0-9]+[Ee][-+]?[0-9]+"
       "\\|[0-9]+\"\.\"[0-9]+"
       "\\|[0-9]+[Ee][-+]?[0-9]+"

       ; Integer
       "\\|0x[0-9A-Fa-f]+"
       "\\|0o[0-7]+"
       "\\|[0-9]"
       ))

;;(setq mzn-keywords-regexp (regexp-opt mzn-keywords 'words))
(setq mzn-highlights `(
			 ("\\(%[^\n]*\\)$" . font-lock-comment-face)
			 (,mzn-operators . font-lock-builtin-face)
			 (,(regexp-opt mzn-keywords 'words) . font-lock-function-name-face)
			 (,mzn-literals . font-lock-constant-face)

			 (,(regexp-opt mzn-types 'words) . font-lock-type-face)
			 
			 ))



(defun mzn-flatten-and-run ()
  "Flatten the model in the current buffer, and start solving."
  (interactive)
  (let
      ;; TODO: Is file saved/null?
      ((cmdline (concat mzn-minizinc-binary " " buffer-file-name))
       (buffer-name "MiniZinc output")
       (sw (selected-window)))
    (switch-to-buffer-other-window buffer-name)
    (shell-command cmdline buffer-name)
    (select-window sw)
    ))
;;(bind-key "C-c C-c" 'mzn-flatten-and-run)

(setq mzn-last-data-file nil)
(defun mzn-flatten-and-run-data ()
  "Flatten the model in the current buffer, and start solving, with user supplied data file."
  (interactive)
  (let*
      ;; TODO: Is file saved/null?
      ((data-file (read-file-name "Data file: " nil nil nil mzn-last-data-file)) ;; TODO match .dzn
       (cmdline (concat mzn-minizinc-binary
			" " buffer-file-name
			" --data " data-file))
       (buffer-name "MiniZinc output")
       (sw (selected-window)))
    (setq mzn-last-data-file data-file)
    (switch-to-buffer-other-window buffer-name)
    (shell-command cmdline buffer-name)
    (select-window sw)
    ))
;; TODO bind in mode only
;;(bind-key "C-c C-d" 'mzn-flatten-and-run-data)

(defvar mzn-mode-map
  (let ((map (make-sparse-keymap)))
  (define-key map (kbd "C-c C-c") 'mzn-flatten-and-run)
  (define-key map (kbd "C-c C-d") 'mzn-flatten-and-run-data)
  map)
  "Keymap for mzn major mode.")

(define-derived-mode mzn-mode prog-mode
  "mzn-mode4" "TODO: Docstring"
  (setq font-lock-defaults '(mzn-highlights))
  (use-local-map mzn-mode-map))


(provide 'mzn-mode)
;;; mzn-mode.el ends here
