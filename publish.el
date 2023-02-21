;; publish.el --- Publish runcom on Gitlab Pages
;; Author: Pradyumna Paranjape

;;; Commentary:
;; This script will tangle and export org mode files to executables and
;; html pages.

;;; Code:

;; Org mode and melpa repos
(when (getenv "CI_PROJECT_ID")
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("elpa" .  "https://elpa.gnu.org/packages/" ) t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (package-refresh-contents)
  ;; (package-install 'org-contrib)
  (package-install 'htmlize)
  (setq user-full-name nil))

;; org mode
(require 'org)
(require 'ox-publish)
(require 'ox-man)

(defun org-man-publish-to-man (plist filename pub-dir)
  "Publish an org file to MAN-PAGE.

FILENAME is the filename of the Org file to be published.  PLIST
is the property list for the given project.  PUB-DIR is the
publishing directory.

Return output file name."
  (let* ((org-section (or (plist-get plist :section-id) "1"))
         (man-dir (format "%s/man%s" pub-dir org-section)))
    (org-publish-org-to
     'man
     filename
     (concat "." org-section)
     plist
     man-dir)))

(setq org-publish-project-alist
      (list
       (list "org-man"
             :base-directory "org/"
             :base-extension "org"
             :publishing-directory "share/man/"
             :recursive t
             :publishing-function 'org-man-publish-to-man
             :headline-levels 4
             :auto-preamble t)
       (list "org-notes"
             :base-directory "org/"
             :base-extension "org"
             :publishing-directory "docs/"
             :recursive t
             :publishing-function 'org-html-publish-to-html
             :headline-levels 4
             :auto-preamble t)
       (list "org-static"
             :base-directory "org/"
             :base-extension
             "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
             :publishing-directory "docs/"
             :recursive t
             :publishing-function 'org-publish-attachment)
       (list "org" :components
             '("org-notes" "org-static"))))

(defun tangle-runcom ()
  (dolist (pub-dir '("bin/" "env/" "dotfiles/" "docs/" "share/man/"))
    (mkdir (format "%s" pub-dir) t))
  (dolist (litorg (directory-files "org/" nil ".org"))
    (org-babel-tangle-file (format "org/%s" litorg)))
  (org-publish "org-man" t))

(defun export-runcom ()
  (mkdir "docs/" t)
  (org-publish "org" t))

(unless (getenv "CI_PROJECT_ID")
  (tangle-runcom)
  ;; (export-runcom)
  )

;;; publish.el ends here
