
(defun clay/start ()
  (interactive)
  (cider-interactive-eval "
    (require '[scicloj.clay.v2.api])
    (scicloj.clay.v2.api/start!)")
  t)

(defun clay/show-namespace ()
  (interactive)
  (clay/start)
  (save-buffer)
  (let
      ((filename
        (buffer-file-name)))
    (when filename
      (cider-interactive-eval
       (concat "(scicloj.clay.v2.api/show-namespace! \"" filename "\" {})")))))

(defun clay/render-namespace-quarto-html ()
  (interactive)
  (clay/start)
  (save-buffer)
  (let
      ((filename
        (buffer-file-name)))
    (when filename
      (cider-interactive-eval
       (concat "(scicloj.clay.v2.api/render-namespace-quarto! \"" filename "\" {:format :html})")))))

(defun clay/render-namespace-quarto-revealjs ()
  (interactive)
  (clay/start)
  (save-buffer)
  (let
      ((filename
        (buffer-file-name)))
    (when filename
      (cider-interactive-eval
       (concat "(scicloj.clay.v2.api/render-namespace-quarto! \"" filename "\" {:format :revealjs})")))))

(defun clay/write-namespace-quarto ()
  (interactive)
  (clay/start)
  (save-buffer)
  (let
      ((filename
        (buffer-file-name)))
    (when filename
      (cider-interactive-eval
       (concat "(scicloj.clay.v2.api/write-namespace-quarto! \"" filename "\" {})")))))

(defun clay/cider-interactive-notify-and-eval (code)
  (cider-interactive-eval
   code
   (cider-interactive-eval-handler nil (point))
   nil
   nil))

(defun clay/send (code)
  (clay/start)
  (clay/cider-interactive-notify-and-eval
   (concat "(scicloj.clay.v2.api/handle-form! (quote " code "))")))

(defun clay/send-last-sexp ()
  (interactive)
  (clay/start)
  (clay/send (cider-last-sexp)))

(defun clay/send-defun-at-point ()
  (interactive)
  (clay/start)
  (clay/send (thing-at-point 'defun)))
