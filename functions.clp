;;****************
;;* DEFFUNCTIONS *
;;****************
(defglobal ?*debug-print* = nil) ; nil vs t


(deffunction MAIN::is-num (?num)
  (or (eq (type ?num) INTEGER) (eq (type ?num) FLOAT))
)

(deffunction MAIN::num-between (?num ?min ?max)
  (and (is-num ?num) (>= ?num ?min) (<= ?num ?max))
)

(deffunction within-tolerance (?num ?ideal ?tolerance)
  (num-between ?num (- ?ideal ?tolerance) (+ ?ideal ?tolerance))
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
    else (printout t "| ## Invalid input ##" crlf))
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
	  else (printout t "| ## Invalid input ##" crlf)
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
	  else (printout t "| ## Invalid input ##" crlf)
    )
  )
)

(deffunction MAIN::names-list (?instances)
  (bind ?out (create$))
  (foreach ?i ?instances
    (bind ?out (create$ ?out (send ?i get-name_)))
  )
)

(deffunction MAIN::remove-duplicates (?list)
  (bind ?out (create$))
  (foreach ?i ?list
    (if (not (member$ ?i ?out)) then
      (bind ?out (create$ ?out ?i))
    )
  )
  ?out
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
	  else (printout t "| ## Invalid input ##" crlf)
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
	  else (printout t "| ## Invalid input ##" crlf)
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

(deffunction MAIN::calculate-daily-calories (?sex-var ?weight-var ?height-var ?age-var ?exercise-var)
  (bind ?BMR (- (+ (* 10 ?weight-var) (* 6.25 ?height-var)) (* 5 ?age-var)))
	(if (eq ?sex-var Male)
		then
			(bind ?BMR (+ ?BMR 5))
			(printout ?*debug-print* "DEBUG: Male" crlf)
		else
			(bind ?BMR (- ?BMR 161))
			(printout ?*debug-print* "DEBUG: Female" crlf)
	)
	(if (eq ?exercise-var Sedentary)
		then
			(bind ?BMR (* ?BMR 1.53))
			(printout ?*debug-print* "DEBUG: Sedentary" crlf)
		else
			(if (eq ?exercise-var Active)
				then
					(bind ?BMR (* ?BMR 1.76))
						(printout ?*debug-print* "DEBUG: Active" crlf)
				else
					(bind ?BMR (* ?BMR 2.25))
						(printout ?*debug-print* "DEBUG: Vigorously-active" crlf)
			)
	)
  (return ?BMR)
)

(deffunction MAIN::init-scoredcourses (?courses ?init-score)
  (bind ?out (create$))
  (foreach ?course ?courses
    (bind ?out (create$ ?out
      (make-instance (sym-cat Scored (instance-name ?course)) of ScoredCourse
          (course ?course)
          (score ?init-score)
          (calories (send ?course get-calories))
      )
    ))
  )
)

(deffunction MAIN::offseted-scoredcourses (?courses ?offset-score)
  (bind ?out (create$))
  (foreach ?course ?courses
    (bind ?out (create$ ?out
      (duplicate-instance ?course to (sym-cat Copy (instance-name ?course))
        (score (+ (send ?course get-score) ?offset-score))
      )
    ))
  )
)

(deffunction MAIN::count-calories ($?courses)
  (bind ?count 0)
  (foreach ?course ?courses
    (bind ?count (+ ?count (send ?course get-calories)))
  )
)

(deffunction count-score ($?courses)
  (bind ?count 0)
  (foreach ?course ?courses
    (bind ?count (+ ?count (send ?course get-score)))
  )
)
