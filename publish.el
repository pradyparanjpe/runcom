;; publish.el --- Publish runcom on Gitlab Pages
;; Author: Pradyumna Paranjape

;;; Commentary:
;; This script will tangle and export org mode files to executables and
;; html pages.

;;; Code:

;; Org mode and melpa repos

(when (getenv "CI_PAGES_URL")
  (require 'package)
  (package-initialize)
  (add-to-list
   'package-archives '("elpa" . "https://elpa.gnu.org/packages/" ) t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
  (package-refresh-contents)
  (package-install 'htmlize)
  (setq user-full-name "Pradyumna Paranjape"))

;; org mode
(require 'org)
(require 'ox-publish)
(require 'ox-html)

(setq org-confirm-babel-evaluate nil)
(setq org-html-head-include-default-style nil)
(setq org-html-head "
<link rel=\"stylesheet\" href=\"https://cdn.datatables.net/1.10.22/css/jquery.dataTables.min.css\">

<link rel=\"stylesheet\" type=\"text/css\" href=\"https://fniessen.github.io/org-html-themes/src/readtheorg_theme/css/htmlize.css\"/>
<link rel=\"stylesheet\" type=\"text/css\" href=\"https://fniessen.github.io/org-html-themes/src/readtheorg_theme/css/readtheorg.css\"/>

<script src=\"https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js\"></script>
<script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js\"></script>
<script type=\"text/javascript\" src=\"https://fniessen.github.io/org-html-themes/src/lib/js/jquery.stickytableheaders.min.js\"></script>
<script type=\"text/javascript\" src=\"https://fniessen.github.io/org-html-themes/src/readtheorg_theme/js/readtheorg.js\"></script>

<style>pre.src{background:#343131;color:white;} </style>

<script src=\"https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js\"></script>
<script src=\"https://cdn.datatables.net/1.10.22/js/jquery.dataTables.min.js\"></script>
<script> $(\"table\").DataTable(); </script>
")


(defun org-man-publish-to-man (plist filename pub-dir)
  "Publish an org file to MAN-PAGE.

FILENAME is the filename of the Org file to be published.  PLIST
is the property list for the given project.  PUB-DIR is the
publishing directory.

Return output file name."
  (let* ((org-section (or (plist-get plist :section-id) "1"))
         (man-dir (format "%s/man%s" pub-dir org-section)))
    (org-publish-org-to 'man filename
                        (concat "." org-section)
                        plist man-dir)))


(setq org-publish-project-alist
      '(("prady-shell-scripts-manual"
         :base-directory "./org"
         :base-extension "org"
         :publishing-directory "pss/share/man/"
         :exclude "((.*private.*)|(.*sitemap.*))"
         :publishing-function org-man-publish-to-man
         :recursive t
         :headline-levels 4
         :auto-preamble t)

        ("runcom"
         :base-directory "./org"
         :base-extension "org"
         :publishing-directory "docs/"
         :publishing-function org-html-publish-to-html
         :recursive t
         :auto-sitemap t
         :auto-preamble t)

        ("org-static"
         :base-directory "./"
         :base-extension
         "css\\|js\\|svg\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
         :publishing-directory "docs/"
         :publishing-function org-publish-attachment
         :recursive t)

        ("org" :components ("runcom" "org-static"))))


(defun tangle-runcom ()
  (mkdir "docs/share/man" t)
  (dolist (litorg (directory-files "." nil ".org"))
    (org-babel-tangle-file (format "%s" litorg)))
  (org-publish "runcom-manual" t))


(defun runcom/publish-pages ()
  "Publish everything"
  (mkdir "docs/" t)
  (org-publish "org" t))


(unless (getenv "CI_PAGES_URL")
  (runcom/publish-pages)
  (tangle-runcom))
