;;; go-build.el --- stuff to help you build go programs more easily

;; Copyright (C) 2014  Nic Ferrier

;; Author: Nic Ferrier <nferrier@ferrier.me.uk>
;; Keywords: languages
;; Version: 0.0.1
;; Requires: ((find-file-in-project "3.3")(go-mode "20131222"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Go programming has very particular, idiomatic, build
;; requirements. Here are some functions to help with that.

;; `go-build/make-compile-command-go-get' can be used in a hook
;; function to set the compile command.

;;; Code:

(require 'find-file-in-project)

(defun go-build/make-compile-command-go-get ()
  "Set the `compile-command' to \"go get\"."
  (make-variable-buffer-local 'compile-command)
  (setq compile-command 
        (let ((root (ffip-project-root))
              (file (buffer-file-name)))
          (message
           (format "GOPATH=%s go get %s"
                   root
                   (save-match-data
                     (string-match
                      (format "%s/\\(.*\\)" (expand-file-name "src" root))
                      file)
                     (match-string 1 file)))))))

;;;###autoload
(defun go-build/install-hooks ()
  (add-hook 'go-mode 'go-build/make-compile-command-go-get))

;;;###autoload
(eval-after-load 'go-build
  '(go-build/install-hooks))

(provide 'go-build)

;;; go-build.el ends here
