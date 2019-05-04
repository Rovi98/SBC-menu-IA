;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction ask-question-yes-no (?question)
  (printout t "| > " ?question " (yes/no) " crlf "| ")
  (bind ?answer (read))
  (bind ?allowed-values (create$ Yes No yes no Y N y n))
  (while (not (member$ ?answer ?allowed-values)) do
    (printout t "| > " ?question crlf "| ")
    (bind ?answer (read))
  )
  (if (or (eq ?answer Yes) (eq ?answer yes) (eq ?answer Y) (eq ?answer y))
  then TRUE
  else FALSE
  )
)

(deffunction ask-question-opt (?question ?allowed-values)
  (printout t "| > " ?question " " ?allowed-values crlf "| ")
  (bind ?answer (read))
  (while (not (member$ ?answer ?allowed-values)) do
    (printout t "| > " ?question crlf "| ")
    (bind ?answer (read))
  )
  ?answer
)

(deffunction ask-question-multi-opt (?question ?allowed-values)
  (printout t "| > " ?question " " ?allowed-values crlf "| ")
  (bind ?line (readline))
  (bind $?answer (explode$ ?line))
  (bind ?valid FALSE)
  (while (not ?valid) do
    (loop-for-count (?i 1 (length$ $?answer)) do
      (bind ?valid FALSE)
      (bind ?value-belongs FALSE)
      (loop-for-count (?j 1 (length$ $?allowed-values)) do
        (if (eq (nth$ ?i $?answer) (nth$ ?j $?allowed-values)) then
          (bind ?value-belongs TRUE)
          (break)
        )
      )
      (if (not ?value-belongs) then
        (printout t "| > " (nth$ ?i $?answer) " is not a valid option" crlf)
        (break)
      )
      (bind ?valid TRUE)
    )
    (if ?valid then (break))

    (printout t "| > " ?question crlf "| ")
    (bind ?line (readline))
    (bind $?answer (explode$ ?line))
  )
  $?answer
)
	   
(deffunction is-num (?num)
  (bind ?ret (or (eq (type ?num) INTEGER) (eq (type ?num) FLOAT)))
  ?ret
)	   

(deffunction ask-question-num (?question ?min ?max)
  (printout t "| > " ?question crlf "| ")
  (bind ?answer (read))
  (while (not (and (is-num ?answer) (>= ?answer ?min) (<= ?answer ?max))) do
    (printout t "| " ?question)
        (bind ?answer (read)))
  ?answer)


(deffunction print-menu (?menuSemana)
  (printout t "Menu:" crlf)
  (printout t (send ?menuSemana imprimir))
)