;;****************
;;* DEFFUNCTIONS *
;;****************

(deffunction MAIN::is-num (?num)
  (bind ?ret (or (eq (type ?num) INTEGER) (eq (type ?num) FLOAT)))
  ?ret
)

(deffunction MAIN::num-between (?num ?min ?max)
  (bind ?ret (and (is-num ?num) (>= ?num ?min) (<= ?num ?max)))
  ?ret
)

(deffunction MAIN::ask-question-yes-no (?question)
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

(deffunction MAIN::ask-question-opt (?question ?allowed-values)
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

(deffunction MAIN::ask-question-multi-opt (?question ?allowed-values)
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
        (bind ?out (create$ ?out ?v))
      )
    )
    (if (eq (length$ ?out) (length$ ?answer)) then
      (return ?out)
    )
  )
)

(deffunction MAIN::names-list (?instances)
  (bind ?out (create$))
  (foreach ?i ?instances
    (bind ?out (create$ ?out (send ?i get-name_)))
  )
)

(deffunction MAIN::ask-question-multi-opt-instances (?question ?class ?exclude)
  (bind ?instances (find-all-instances ((?c ?class)) (not (member$ ?c ?exclude))))
  (bind ?names (names-list ?instances))
  (bind ?count (length$ ?instances))
  
  (if (= ?count 0) then (return (create$)))

  (while TRUE do ;return function will exit this loop
    (printout t "| > " ?question " ")
    (loop-for-count (?i ?count) do
      (printout t crlf tab ?i ") " (nth$ ?i ?names))
    )
    (printout t crlf "| ")
    (bind ?line (readline))
    (bind $?answer (explode$ ?line))
    (bind ?out (create$))
    (foreach ?i ?answer
      (if (not (num-between ?i 1 ?count)) then
        (break)
      )
      (bind ?v (nth$ ?i ?instances))
      (if (not (member$ ?v ?out)) then
        (bind ?out (create$ ?out ?v))
      )
    )
    (if (eq (length$ ?out) (length$ ?answer)) then
      (return ?out)
    )
  )
)

(deffunction MAIN::ask-question-num (?question ?min ?max)
  (while TRUE do ;return function will exit this loop
    (printout t "| > " ?question " ")
    (printout t crlf "| ")
    (bind ?answer (read))
    (if (num-between ?answer ?min ?max) then
      (return ?answer)
    )
  )
)


(deffunction MAIN::print-menu (?menuWeek)
  (printout t "Menu:" crlf)
  (printout t (send ?menuWeek display))
)

(deffunction MAIN::random-item (?list)
  (nth$ (random 1 (length$ ?list)) ?list)
)

(deffunction MAIN::random-ord (?a ?b)
  (eq 1 (random 1 2))
)

(deffunction MAIN::random-sort (?list)
  (sort random-ord ?list)
)

(deffunction MAIN::ord-course (?a ?b)
  (< (send ?a get-score) (send ?b get-score))
)

(deffunction MAIN::sort-courses (?list)
  ;(funcall sort course_ord ?list)  
  (sort ord-course ?list)
)

(deffunction MAIN::get-n-courses-of-category (?list ?n ?category)
  (sort ord-course ?list)
  (bind ?i 0)
  (bind ?out (create$))
  (foreach ?e ?list
    (if (member$ ?category (send ?e get-category)) then
      (bind ?out (create$ ?out ?e))
      (bind ?i (+ ?i 1))
      (if (>= ?i ?n) then (break))
    )
  )
  ?out
)