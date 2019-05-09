;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction is-num (?num)
  (bind ?ret (or (eq (type ?num) INTEGER) (eq (type ?num) FLOAT)))
  ?ret
)

(deffunction num-between (?num ?min ?max)
  (bind ?ret (and (is-num ?num) (>= ?num ?min) (<= ?num ?max)))
  ?ret
)

(deffunction ask-question-yes-no (?question)
  (bind ?allowed-values-yes (create$ Yes yes Y y 1))
  (bind ?allowed-values-no (create$ No no N n 0))
  (while TRUE do ;return function will exit this loop
    (printout t "| > " ?question " (yes/no) " crlf "| ")
    (bind ?answer (read))
    (if (member$ ?answer ?allowed-values-yes) then
      (return TRUE)
    else (if (member$ ?answer ?allowed-values-no) then
            (return FALSE)
        )
    )
  )
)

(deffunction ask-question-opt (?question ?allowed-values)
  (while TRUE do ;return function will exit this loop
    (printout t "| > " ?question " ")
    (loop-for-count (?i 1 (length$ $?allowed-values)) do
      (printout t crlf tab ?i ") " (nth$ ?i $?allowed-values))
    )
    (printout t crlf "| ")
    (bind ?answer (read))
    (if (num-between ?answer 1 (length$ $?allowed-values)) then
      (return (nth$ ?answer $?allowed-values))
    )
  )
  ?answer
)

(deffunction ask-question-multi-opt (?question ?allowed-values)
  (while TRUE do ;return function will exit this loop
    (printout t "| > " ?question " ")
    (loop-for-count (?i 1 (length$ $?allowed-values)) do
      (printout t crlf tab ?i ") " (nth$ ?i $?allowed-values))
    )
    (printout t crlf "| ")
    (bind ?line (readline))
    (bind $?answer (explode$ ?line))
    (bind ?out (create$))
    (foreach ?i ?answer
      (if (not (num-between ?i 1 (length$ $?allowed-values))) then
        (break)
      )
      (bind ?v (nth$ ?i ?allowed-values))
      (if (not (member$ ?v ?out)) then
        (bind ?out (insert$ ?out 1 ?v))
      )
    )
    (if (eq (length$ ?out) (length$ ?answer)) then
      (return ?out)
    )
  )
)

(deffunction ask-question-num (?question ?min ?max)
  (while TRUE do ;return function will exit this loop
    (printout t "| > " ?question " ")
    (printout t crlf "| ")
    (bind ?answer (read))
    (if (num-between ?answer ?min ?max) then
      (return ?answer)
    )
  )
)


(deffunction print-menu (?menuWeek)
  (printout t "Menu:" crlf)
  (printout t (send ?menuWeek display))
)

(deffunction random-from-list (?list)
  (nth$ (random 1 (length$ ?list)) ?list)
)
