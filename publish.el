(require 'ox-man)
(require 'ox-publish)
(dolist (pub-dir '("bin/" "env/" "dotfiles/" "docs/" "share/man/"))
  (mkdir (format "%s" pub-dir) t))
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
       (list "org-html"
             :base-directory "org/"
             :base-extension "org"
             :publishing-directory "docs/"
             :recursive t
             :publishing-function 'org-html-publish-to-html
             :headline-levels 4
             :auto-preamble t)
       (list "org-man"
             :base-directory "org/"
             :base-extension "org"
             :publishing-directory "share/man/"
             :recursive t
             :publishing-function 'org-man-publish-to-man
             :headline-levels 4
             :auto-preamble t)
       (list "org-static"
             :base-directory "."
             :base-extension
             "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf"
             :publishing-directory "docs/"
             :recursive t
             :publishing-function 'org-publish-attachment)
       (list "org" :components
             '("org-html" "org-static" "org-man"))))
(org-publish "org" t)
(dolist (litorg (directory-files "org/" nil ".org"))
  (org-babel-tangle-file (format "%s/%s" "org/" litorg)))
