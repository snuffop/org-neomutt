
;; I used the -f m to give me the maildir the message is in Modified to put
;; the = in   "=/account/INBOX"  or neomutt would tank.  also use the macro index
;; method to get neomutt to not error out on the push

;; Using termite as well Much easier and less complicated call. not as redundant.



(defun mutt-open-message (message-id)
  "In neomutt, open the email with the the given Message-ID"
  (let*
      ((message-id
        (replace-regexp-in-string "^/*" "" message-id))
       (mail-file
        (replace-regexp-in-string
         "\n$" "" (shell-command-to-string
                   (format "mu find -u i:%s -l m" message-id ))))
       (mutt-keystrokes
        (format "macro index - l~i%s; push -\\nb\\n" (shell-quote-argument message-id)))
       (mutt-command (format "neomutt -f '=%s' -e '%s'" mail-file  mutt-keystrokes)))

    (message "Launching neomutt for message %s" message-id)
    (call-process "setsid" nil nil nil
                  "-f" "termite" "-e"
                  mutt-command)
    ))

;; Hook up `mutt:...` style URLs
;; Doom  (after! org)
(org-add-link-type "message" 'mutt-open-message))
