;%%%%%
;%
;% MODULES
;%
;%%%%%

;;; Main module
(defmodule MAIN (export ?ALL))

;;; Ask questions module
(defmodule ask_questions
  (import MAIN ?ALL)
  (export ?ALL)
)

;;; Inference Module
(defmodule inference_of_data
  (import MAIN ?ALL)
  (import ask_questions ?ALL)
  (export ?ALL)
)

;;; Generate solutions module
(defmodule generate_solutions
  (import MAIN ?ALL)
  (import ask_questions ?ALL)
  (import inference_of_data ?ALL)
  (export ?ALL)
)

;;; Printing Module
(defmodule printing
  (import MAIN ?ALL)
  (import ask_questions ?ALL)
  (import inference_of_data ?ALL)
  (import generate_solutions ?ALL)
  (export ?ALL)
)

;%%%%%
;%
;% DEFINITIONS
;%
;%%%%%



(deftemplate MAIN::user
  (slot sex (type SYMBOL))
  (slot age (type INTEGER))
  (slot exercise-level (type SYMBOL))
  (slot required-weekly-calories (type FLOAT))
  (slot height (type INTEGER))
  (slot weight (type FLOAT))
  (multislot foodtypes-positive (type INSTANCE))
  (multislot foodtypes-negative (type INSTANCE))
  (multislot preferences (type INSTANCE))
  (multislot diseases (type INSTANCE))
)

(deftemplate MAIN::chosen-menu
  (slot menu (type INSTANCE))
  (slot score (type FLOAT) (default -9999999.0))
)

(deftemplate MAIN::chosen-courses
  (multislot breakfasts (type INSTANCE))
  (multislot firstCourses (type INSTANCE))
  (multislot secondCourses (type INSTANCE))
  (multislot desserts (type INSTANCE))
)

(deftemplate MAIN::available-courses
  (multislot breakfasts (type INSTANCE))
  (multislot firstCourses (type INSTANCE))
  (multislot secondCourses (type INSTANCE))
  (multislot desserts (type INSTANCE))
)

(deffacts MAIN::facts-initialization
  (user)
  (available-courses)
  (chosen-courses)
  (best-calories-diff 9999999)
)

(defglobal
  ?*WEEKDAYS* = (create$ Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
)

;;;********************
;;;* MENU STATE RULES *
;;;********************

(defrule generate_solutions::sort-courses
  (declare (salience 10))
  (not (sort-courses-done))
  (user (required-weekly-calories ?req-calories))
  ?available-courses <- (available-courses  (breakfasts $?breakfasts)
                                            (firstCourses $?firstCourses)
                                            (secondCourses $?secondCourses)
                                            (desserts $?desserts)
  )

  =>

  (bind ?sorted-breakfasts (sort-courses ?breakfasts))
  (bind ?sorted-firstCourses (sort-courses ?firstCourses))
  (bind ?sorted-secondCourses (sort-courses ?secondCourses))
  (bind ?sorted-desserts (sort-courses ?desserts))

  (bind ?dup-breakfasts (offseted-scoredcourses (subseq$ ?sorted-breakfasts 1 3) -1000))
  (bind ?dup-firstCourses (offseted-scoredcourses (subseq$ ?sorted-firstCourses 1 7) -1000))
  (bind ?dup-secondCourses (offseted-scoredcourses (subseq$ ?sorted-secondCourses 1 7) -1000))
  (bind ?dup-desserts (offseted-scoredcourses (subseq$ ?sorted-desserts 1 7) -1000))

  (bind ?sorted-breakfasts (sort-courses (create$ ?breakfasts ?dup-breakfasts)))
  (bind ?sorted-firstCourses (sort-courses (create$ ?firstCourses ?dup-firstCourses)))
  (bind ?sorted-secondCourses (sort-courses (create$ ?secondCourses ?dup-secondCourses)))
  (bind ?sorted-desserts (sort-courses (create$ ?desserts ?dup-desserts)))

  (modify ?available-courses  (breakfasts (subseq$ ?sorted-breakfasts 1 10))
                              (firstCourses (subseq$ ?sorted-firstCourses 1 22))
                              (secondCourses (subseq$ ?sorted-secondCourses 1 24))
                              (desserts (subseq$ ?sorted-desserts 1 20))
  )

  (bind ?fixed-breakfasts (subseq$ ?sorted-breakfasts 1 7))
  (bind ?fixed-firstCourses (subseq$ ?sorted-firstCourses 1 10))
  (bind ?fixed-secondCourses (subseq$ ?sorted-secondCourses 1 9))
  (bind ?fixed-desserts (subseq$ ?sorted-desserts 1 14))

  (bind ?fixed-used-calories (count-calories (create$ ?fixed-breakfasts
                                                      ?fixed-firstCourses
                                                      ?fixed-secondCourses
                                                      ?fixed-desserts
  )))

  (assert (calories-left (- ?req-calories ?fixed-used-calories)))
  (assert (sort-courses-done))
)

(defrule generate_solutions::generate-menus
	(declare (salience 20))
	(sort-courses-done)
  (not (visited-all-menus))
  (not (chosen-menu))
  (not (visited-all-menus))
	(calories-left ?calories-left)
  ?chosen-courses <- (chosen-courses)
  ?best-calories-diff-fact <- (best-calories-diff ?best-calories-diff)

  (available-courses (breakfasts    ?bf1 ?bf2 ?bf3 ?bf4 ?bf5 ?bf6 ?bf7 $?))
  (available-courses (firstCourses  ?fc1 ?fc2 ?fc3 ?fc4 ?fc5 ?fc6 ?fc7 ?fc8 ?fc9 ?fc10 $? ?fc11 $? ?fc12 $? ?fc13 $? ?fc14 $?))
  (available-courses (secondCourses ?sc1 ?sc2 ?sc3 ?sc4 ?sc5 ?sc6 ?sc7 ?sc8 ?sc9 $? ?sc10 $? ?sc11 $? ?sc12 $? ?sc13 $? ?sc14 $?))
  (available-courses (desserts      ?ds1 ?ds2 ?ds3 ?ds4 ?ds5 ?ds6 ?ds7 ?ds8 ?ds9 ?ds10 ?ds11 ?ds12 ?ds13 ?ds14 $?))

	; (test (within-tolerance
	; 	(count-calories   ?fc11 ?fc12 ?fc13 ?fc14
  ;                     ?sc10 ?sc11 ?sc12 ?sc13 ?sc14)
	; 	?calories-left
	; 	1750
	; ))

  =>
  (bind ?this-calories  (count-calories ?fc11 ?fc12 ?fc13 ?fc14
                                        ?sc10 ?sc11 ?sc12 ?sc13 ?sc14))

  (bind ?this-calories-diff (abs (- ?this-calories ?calories-left)))

  (if (< ?this-calories-diff ?best-calories-diff) then
    (printout ?*debug-print* "DEBUG: New best menu. " ?best-calories-diff " -> " ?this-calories-diff crlf)
    (bind ?chosenBreakfasts     (random-sort (create$ ?bf1 ?bf2 ?bf3 ?bf4 ?bf5 ?bf6 ?bf7)))
    (bind ?chosenFirstCourses   (random-sort (create$ ?fc1 ?fc2 ?fc3 ?fc4 ?fc5 ?fc6 ?fc7 ?fc8 ?fc9 ?fc10 ?fc11 ?fc12 ?fc13 ?fc14)))
    (bind ?chosenSecondCourses  (random-sort (create$ ?sc1 ?sc2 ?sc3 ?sc4 ?sc5 ?sc6 ?sc7 ?sc8 ?sc9 ?sc10 ?sc11 ?sc12 ?sc13 ?sc14)))
    (bind ?chosenDesserts       (random-sort (create$ ?ds1 ?ds2 ?ds3 ?ds4 ?ds5 ?ds6 ?ds7 ?ds8 ?ds9 ?ds10 ?ds11 ?ds12 ?ds13 ?ds14)))

    (modify ?chosen-courses (breakfasts     ?chosenBreakfasts)
                            (firstCourses   ?chosenFirstCourses)
                            (secondCourses  ?chosenSecondCourses)
                            (desserts       ?chosenDesserts)
    )

    (retract ?best-calories-diff-fact)
    (assert (best-calories-diff ?this-calories-diff))
  )
)

(defrule generate_solutions::solve-repetitions-firstCourse
  (declare (salience 15))
  (not (visited-all-menus))
  =>
  (assert (visited-all-menus))
)

(defrule generate_solutions::solve-repetitions-firstCourse
  (declare (salience 15))
  (not (chosen-menu))
  (visited-all-menus)
  ?chosen-courses <- (chosen-courses (firstCourses ?fc1 ?fc2 ?fc3 ?fc4 ?fc5 ?fc6 ?fc7 ?fc8 ?fc9 ?fc10 ?fc11 ?fc12 ?fc13 ?fc14))

  (test (or (eq (send ?fc1 get-course) (send ?fc2 get-course))
            (eq (send ?fc3 get-course) (send ?fc4 get-course))
            (eq (send ?fc5 get-course) (send ?fc6 get-course))
            (eq (send ?fc7 get-course) (send ?fc8 get-course))
            (eq (send ?fc9 get-course) (send ?fc10 get-course))
            (eq (send ?fc11 get-course) (send ?fc12 get-course))
            (eq (send ?fc13 get-course) (send ?fc14 get-course))
    )
  )

  =>

  (printout ?*debug-print* "DEBUG: re-sorting firstCourses to avoid repetitions" crlf)
  (bind ?chosenFirstCourses (random-sort (create$ ?fc1 ?fc2 ?fc3 ?fc4 ?fc5 ?fc6 ?fc7 ?fc8 ?fc9 ?fc10 ?fc11 ?fc12 ?fc13 ?fc14)))
  (modify ?chosen-courses (firstCourses ?chosenFirstCourses))
)

(defrule generate_solutions::solve-repetitions-secondCourses
  (declare (salience 15))
  (not (chosen-menu))
  ?chosen-courses <- (chosen-courses (secondCourses ?sc1 ?sc2 ?sc3 ?sc4 ?sc5 ?sc6 ?sc7 ?sc8 ?sc9 ?sc10 ?sc11 ?sc12 ?sc13 ?sc14))

  (test (or (eq (send ?sc1 get-course) (send ?sc2 get-course))
            (eq (send ?sc3 get-course) (send ?sc4 get-course))
            (eq (send ?sc5 get-course) (send ?sc6 get-course))
            (eq (send ?sc7 get-course) (send ?sc8 get-course))
            (eq (send ?sc9 get-course) (send ?sc10 get-course))
            (eq (send ?sc11 get-course) (send ?sc12 get-course))
            (eq (send ?sc13 get-course) (send ?sc14 get-course))
    )
  )

  =>

  (printout ?*debug-print* "DEBUG: re-sorting secondCourses to avoid repetitions" crlf)
  (bind ?chosenSecondCourses (random-sort (create$ ?sc1 ?sc2 ?sc3 ?sc4 ?sc5 ?sc6 ?sc7 ?sc8 ?sc9 ?sc10 ?sc11 ?sc12 ?sc13 ?sc14)))
  (modify ?chosen-courses (secondCourses ?chosenSecondCourses))
)

(defrule generate_solutions::solve-repetitions-desserts
  (declare (salience 15))
  (not (chosen-menu))
  ?chosen-courses <- (chosen-courses (desserts ?ds1 ?ds2 ?ds3 ?ds4 ?ds5 ?ds6 ?ds7 ?ds8 ?ds9 ?ds10 ?ds11 ?ds12 ?ds13 ?ds14))

  (test (or (eq (send ?ds1 get-course) (send ?ds2 get-course))
            (eq (send ?ds3 get-course) (send ?ds4 get-course))
            (eq (send ?ds5 get-course) (send ?ds6 get-course))
            (eq (send ?ds7 get-course) (send ?ds8 get-course))
            (eq (send ?ds9 get-course) (send ?ds10 get-course))
            (eq (send ?ds11 get-course) (send ?ds12 get-course))
            (eq (send ?ds13 get-course) (send ?ds14 get-course))
    )
  )

  =>

  (printout ?*debug-print* "DEBUG: re-sorting desserts to avoid repetitions" crlf)
  (bind ?chosenDesserts (random-sort (create$ ?ds1 ?ds2 ?ds3 ?ds4 ?ds5 ?ds6 ?ds7 ?ds8 ?ds9 ?ds10 ?ds11 ?ds12 ?ds13 ?ds14)))
  (modify ?chosen-courses (desserts ?chosenDesserts))
)

(defrule generate_solutions::assign-menu
  (declare (salience 10))
  (not (chosen-menu))
  (chosen-courses (breakfasts    $?chosenBreakfasts)
                  (firstCourses  $?chosenFirstCourses)
                  (secondCourses $?chosenSecondCourses)
                  (desserts      $?chosenDesserts)
  )

  =>

  (bind ?menuWeek (make-instance (gensym) of MenuWeek))

  (loop-for-count (?i 0 6) do

    (bind ?breakfast
      (make-instance (gensym) of Breakfast
        (course (nth$ (+ ?i 1) ?chosenBreakfasts))
      )
    )

      (bind ?lunch
      (make-instance (gensym) of Lunch
        (firstCourse (nth$ (+ (* ?i 2) 1) ?chosenFirstCourses))
        (secondCourse (nth$ (+ (* ?i 2) 1) ?chosenSecondCourses))
        (dessert (nth$ (+ (* ?i 2) 1) ?chosenDesserts))
      )
    )

    (bind ?dinner
      (make-instance (gensym) of Dinner
        (firstCourse (nth$ (+ (* ?i 2) 2) ?chosenFirstCourses))
        (secondCourse (nth$ (+ (* ?i 2) 2) ?chosenSecondCourses))
        (dessert (nth$ (+ (* ?i 2) 2) ?chosenDesserts))
      )
    )

    (bind ?menuDay
      (make-instance (gensym) of MenuDay
        (breakfast ?breakfast)
        (lunch ?lunch)
        (dinner ?dinner)
      )
    )

    (bind ?i1 (+ ?i 1))
    (slot-replace$ ?menuWeek menusDay ?i1 ?i1 ?menuDay)
  )

  (bind ?score (count-score (create$ ?chosenBreakfasts ?chosenFirstCourses ?chosenSecondCourses ?chosenDesserts)))

  (assert (chosen-menu (menu ?menuWeek) (score ?score)))

)

(defrule generate_solutions::no-menu-found
  (declare (salience -10))
  (not (chosen-menu))
  =>
  (printout t crlf "############################################")
  (printout t crlf "############################################" crlf crlf)

  (printout t "We did not find any valid menu. " crlf "We are very sorry." crlf crlf "Try again with a less restrictive input." crlf)

  (printout t crlf "############################################")
  (printout t crlf "############################################" crlf crlf)
)

(defrule generate_solutions::menu-found
  (declare (salience -10))
  (chosen-menu)
  =>
  (focus printing)
)

(defrule printing::print-result
  (chosen-menu (menu ?menu) (score ?score))
  (available-courses  (breakfasts ?bf1 ?bf2 ?bf3 $?)
                      (firstCourses ?fc1 ?fc2 ?fc3 $?)
                      (secondCourses ?sc1 ?sc2 ?sc3 $?)
                      (desserts ?ds1 ?ds2 ?ds3 $?)
  )

	=>

  (printout t crlf "############################################")
  (printout t crlf "################### MENU ###################")
  (printout t crlf "############################################" crlf crlf)

  (print-menu ?menu)

  (printout t crlf "############################################")
  (printout t crlf "############# MENU INFORMATION #############")
  (printout t crlf "############################################" crlf crlf)

  (bind ?calories (send ?menu get-calories))

  (printout t "Total Calories:" tab tab (integer ?calories) " kcal" crlf)
  (printout t "Approx. Daily Calories:" tab (integer (/ ?calories 7)) " kcal" crlf)

  (printout t crlf "============================================" crlf)
  (printout t "Top Scored Courses" crlf)
  (printout t "============================================" crlf)
  (printout t "- Breakfasts:" tab tab (remove-duplicates (names-list (create$ ?bf1 ?bf2 ?bf3))) crlf)
  (printout t "- First Courses:" tab (remove-duplicates (names-list (create$ ?fc1 ?fc2 ?fc3))) crlf)
  (printout t "- Second Courses:" tab (remove-duplicates (names-list (create$ ?sc1 ?sc2 ?sc3))) crlf)
  (printout t "- Desserts:" tab tab (remove-duplicates (names-list (create$ ?ds1 ?ds2 ?ds3))) crlf)

  (printout t crlf "############################################")
  (printout t crlf "############################################" crlf crlf)

  (printout ?*debug-print* "DEBUG: Menu Score: " ?score crlf)
)

(defrule ask_questions::normal-menu-state-conclusions
  (declare (salience 10))
  (asked-age)
  (asked-weight)
  (asked-height)
  (asked-vegetables-preference)
  (asked-diseases)
  (asked-sex)
  (asked-exercise-level)
  (asked-foodtypes-positive)
  (asked-foodtypes-negative)

   =>

   (printout t crlf "Processing the data obtained..." crlf)
   (focus inference_of_data)
)

(defrule inference_of_data::list-available-courses
  (not (listed-available-courses))
  ?available-courses <- (available-courses)
   =>
  (bind ?breakfasts (find-all-instances ((?c Course)) (member$ Breakfast ?c:category)))
  (bind ?firstCourses (find-all-instances ((?c Course)) (member$ FirstCourse ?c:category)))
  (bind ?secondCourses (find-all-instances ((?c Course)) (member$ SecondCourse ?c:category)))
  (bind ?desserts (find-all-instances ((?c Course)) (member$ Dessert ?c:category)))

  (modify ?available-courses  (breakfasts (init-scoredcourses ?breakfasts 0))
                              (firstCourses (init-scoredcourses ?firstCourses 0))
                              (secondCourses (init-scoredcourses ?secondCourses 0))
                              (desserts (init-scoredcourses ?desserts 0))
  )

  (assert (listed-available-courses))
)


(defrule inference_of_data::apply-specific-preferences
  (listed-available-courses)
  (asked-vegetables-preference)
  (not (applied-specific-preferences))
  (user (preferences $?prefs))
   =>
    (foreach ?pref ?prefs
      (foreach ?lim (send ?pref get-limitations)
        ;(printout t ?lim crlf)
        (send ?lim apply)
      )
    )
    (assert (applied-specific-preferences))
)

(defrule inference_of_data::apply-diseases
  (listed-available-courses)
  (asked-diseases)
  (not (applied-diseases))
  (user (diseases $?diss))
   =>
    (foreach ?dis ?diss
      (foreach ?lim (send ?dis get-limitations)
        ;(printout t ?lim crlf)
        (send ?lim apply)
      )
    )
    (assert (applied-diseases))
)

(defrule inference_of_data::apply-foodtypes-preferences
  (listed-available-courses)
  (asked-foodtypes-positive)
  (asked-foodtypes-negative)
  (not (applied-foodtypes-preferences))
  (user (foodtypes-positive $?types-positive)
        (foodtypes-negative $?types-negative)
  )
   =>
    (foreach ?type ?types-positive
      (send ?type apply-as-preference +50)
    )
    (foreach ?type ?types-negative
      (send ?type apply-as-preference -50)
    )
    (assert (applied-foodtypes-preferences))
)


(defrule inference_of_data::start_generating
  (applied-foodtypes-preferences)
  (applied-diseases)
  (applied-specific-preferences)
  (required-calories-calculated)
  (listed-available-courses)
  (user (height ?height)
        (weight ?weight)
        (age ?age)
        (exercise-level ?exercise-level)
        (sex ?sex)
        (required-weekly-calories ?req-calories)
  )

   =>

   (printout t crlf "############################################")
   (printout t crlf "############# USER INFORMATION #############")
   (printout t crlf "############################################" crlf crlf)

   (printout t "Sex:" tab tab tab tab ?sex crlf)
   (printout t "Age:" tab tab tab tab ?age crlf)
   (printout t "Height:" tab tab tab tab ?height " cm" crlf)
   (printout t "Weight:" tab tab tab tab ?weight " kg" crlf)
   (printout t "Exercise Level:" tab tab ?exercise-level crlf)
   (printout t "Required Daily Calories:" tab (integer (/ ?req-calories 7)) " kcal" crlf)

   (printout t crlf "############################################")
   (printout t crlf "############################################" crlf crlf)

   (printout t "Generating solution..." crlf)

   (focus generate_solutions)
)

(defrule inference_of_data::calories-calculator
	(not (required-calories-calculated))
  ?user <- (user  (height ?height)
                  (weight ?weight)
                  (age ?age)
                  (exercise-level ?exercise-level)
                  (sex ?sex)
  )
	=>
	(bind ?BMR (calculate-daily-calories ?sex ?weight ?height ?age ?exercise-level))
	(printout ?*debug-print* "DEBUG: Daily Required Calories: " ?BMR crlf)

  (bind ?WBMR (* 7 ?BMR))
  (printout ?*debug-print* "DEBUG: Weekly Required Calories: " ?WBMR crlf)

  (modify ?user (required-weekly-calories ?WBMR))
	(assert (required-calories-calculated))
)


;;;***************
;;;* QUERY RULES *
;;;***************

(defrule ask_questions::determine-age
  (not (asked-age))
  ?user <- (user)
  =>
    (bind ?num (ask-question-num "How old are you?" 65 115))
    (modify ?user (age ?num))
    (assert (asked-age))
)

(defrule ask_questions::determine-height
  (not (asked-height))
  ?user <- (user)
  =>
    (bind ?num (ask-question-num "How tall are you? (cm)" 140 210))
    (modify ?user (height ?num))
    (assert (asked-height))
)

(defrule ask_questions::determine-weight
  (not (asked-weight))
  ?user <- (user)
  =>
    (bind ?num (ask-question-num "What is your weight? (kg)" 40 200))
    (modify ?user (weight ?num))
    (assert (asked-weight))
)


(defrule ask_questions::determine-sex
  (not (asked-sex))
  ?user <- (user)
  =>
    (bind ?response (ask-question-opt "What is your gender?" (create$ Male Female n/a)))
    (modify ?user (sex ?response))
    (assert (asked-sex))
)


(defrule ask_questions::determine-exercise-level
  (not (asked-exercise-level))
  ?user <- (user)
  =>
   (bind ?response (ask-question-opt "How much exercise do you do per week?" (create$ Sedentary Active Vigorously-active)))
   (modify ?user (exercise-level ?response))
   (assert (asked-exercise-level))
)


(defrule ask_questions::determine-diseases
  (not (asked-diseases))
  ?user <- (user)
  =>
   (bind ?response (ask-question-multi-opt-instances "Do you have any of the following diseases? List as many as required." Disease (create$)))
   (modify ?user (diseases ?response))
   (assert (asked-diseases))
)

(defrule ask_questions::determine-vegetables-preference
  (not (asked-vegetables-preference))
  ?user <- (user (preferences $?prefs))
   =>
    (if (not (ask-question-yes-no "Do you eat meat?")) then
      (if (ask-question-yes-no "Do you eat milk or eggs?") then
        (modify ?user (preferences ?prefs [Preference_Vegetarian]))
      else
        (modify ?user (preferences ?prefs [Preference_Vegan]))
      )
    )
   (assert (asked-vegetables-preference))
)

(defrule ask_questions::determine-foodtypes-positive
  (not (asked-foodtypes-positive))
  ?user <- (user (foodtypes-negative $?exclude))
  =>
    (bind ?response (ask-question-multi-opt-instances "Do you really LIKE any of the following foods? List as many as required." FoodType $?exclude))
    (modify ?user (foodtypes-positive ?response))
    (assert (asked-foodtypes-positive))
)

(defrule ask_questions::determine-foodtypes-negative
  (not (asked-foodtypes-negative))
  ?user <- (user (foodtypes-positive $?exclude))
  =>
    (bind ?response (ask-question-multi-opt-instances "Do you DISLIKE any of the following foods? List as many as required." FoodType $?exclude))
    (modify ?user (foodtypes-negative ?response))
    (assert (asked-foodtypes-negative))
)

;;;****************************
;;;* STARTUP AND OUTPUT RULES *
;;;****************************

(defrule MAIN::system-banner
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Food Menu v0.8")
  (printout t crlf crlf)
  (focus ask_questions)
)

  ;(format t " %s%n%n%n" ?item))


;;; Modulo de presentacion de resultados ----------------------------------------------------
;;;(defrule presentacion::mostrar-respuesta "Muestra el contenido escogido"
	;;;(lista-dias (dias $?dias))
	;;;(Usuario (nombre ?nombre))
	;;;(not (final))
	;;;=>
	;;;(printout t crlf)
	;;;(format t "%s, esta es nuestra recomendación para usted. ¡Esperamos que la disfrute!" ?nombre)
	;;;(printout t crlf)
	;;;(progn$ (?curr-dia $?dias)
	;;;(progn$ (?curr-dia $?dias)
	;;;(printout t (send ?curr-dia display))
	;;;)
	;;;(assert (final))
;;;)

;;;************
;;;* MESSAGES *
;;;************

(defmessage-handler MAIN::ScoredCourse get-name_ ()
  (send ?self:course get-name_)
)

(defmessage-handler printing::Breakfast display ()
  (printout t "|| - " (send ?self:course get-name_) crlf)
)

(defmessage-handler printing::Lunch display ()
  (printout t "|| - " (send ?self:firstCourse get-name_) crlf)
  (printout t "|| - " (send ?self:secondCourse get-name_) crlf)
  (printout t "|| - " (send ?self:dessert get-name_) crlf)
)

(defmessage-handler printing::Dinner display ()
  (printout t "|| - " (send ?self:firstCourse get-name_) crlf)
  (printout t "|| - " (send ?self:secondCourse get-name_) crlf)
  (printout t "|| - " (send ?self:dessert get-name_) crlf)
)

(defmessage-handler printing::MenuDay display ()
  (printout t "||" crlf)
  (printout t "|| >>> Breakfast <<<" crlf)
  (printout t (send ?self:breakfast display))
  (printout t "||" crlf)
  (printout t "|| >>>   Lunch   <<<" crlf)
  (printout t (send ?self:lunch display))
  (printout t "||" crlf)
  (printout t "|| >>>   Dinner  <<<" crlf)
  (printout t (send ?self:dinner display))
  (printout t "||" crlf)
)

(defmessage-handler printing::MenuWeek display ()
  (loop-for-count (?i 1 7) do
    (printout t "============================================" crlf)
    (printout t "|||| " (nth$ ?i ?*WEEKDAYS*) crlf)
    (printout t "============================================" crlf)
    (printout t (send (nth$ ?i ?self:menusDay) display))
  )
  (printout t "============================================" crlf)
)

(defmessage-handler MAIN::NutrientQuantity get-name_ ()
  (send ?self:nutrient get-name_)
)

(defmessage-handler MAIN::IngredientQuantity get-name_ ()
  (send ?self:ingredient get-name_)
)

(defmessage-handler MAIN::Ingredient get-calories ()
  (foreach ?nutrientQty ?self:nutrients
    (if (eq (send ?nutrientQty get-nutrient) [Nutrient_calories]) then
      (return (* 0.01 (send ?nutrientQty get-quantity) 1))
    )
  )
  0
)

(defmessage-handler MAIN::IngredientQuantity get-calories ()
  (* ?self:quantity (send ?self:ingredient get-calories))
)

(defmessage-handler MAIN::Course get-calories ()
  (bind ?sum 0)
  (foreach ?ingredientQty ?self:ingredients
    (bind ?sum (+ ?sum (send ?ingredientQty get-calories)))
  )
)

(defmessage-handler MAIN::Breakfast get-calories ()
  (send ?self:course get-calories)
)

(defmessage-handler MAIN::Lunch get-calories ()
  (+ (send ?self:firstCourse get-calories) (send ?self:secondCourse get-calories) (send ?self:dessert get-calories))
)

(defmessage-handler MAIN::Dinner get-calories ()
  (+ (send ?self:firstCourse get-calories) (send ?self:secondCourse get-calories) (send ?self:dessert get-calories))
)

(defmessage-handler MAIN::MenuDay get-calories ()
  (+ (send ?self:breakfast get-calories) (send ?self:lunch get-calories) (send ?self:dinner get-calories))
)

(defmessage-handler MAIN::MenuWeek get-calories ()
  (bind ?sum 0)
  (foreach ?menuDay ?self:menusDay
    (bind ?sum (+ ?sum (send ?menuDay get-calories)))
  )
)

(defmessage-handler MAIN::ScoredCourse add-score (?score)
  (bind ?self:score (+ ?self:score ?score))
)

(defmessage-handler inference_of_data::LimitationType apply ()
  (do-for-all-instances  ((?scCour ScoredCourse) (?ingrQty IngredientQuantity))
    (and
      (member$ ?self:type (send ?ingrQty:ingredient get-types))
      (member$ ?ingrQty (send ?scCour:course get-ingredients))
    )
    (printout ?*debug-print* "DEBUG: reduced score of course " ?scCour:course " because it has " ?ingrQty " of type " ?self:type crlf)
    (send ?scCour add-score (* ?self:value ?ingrQty:quantity))
  )
)

(defmessage-handler inference_of_data::LimitationNutrient apply ()
  (do-for-all-instances  ((?scCour ScoredCourse) (?ingrQty IngredientQuantity) (?nutrQty NutrientQuantity))
    (and
      (eq ?self:nutrient ?nutrQty:nutrient)
      (member$ ?nutrQty (send ?ingrQty:ingredient get-nutrients))
      (member$ ?ingrQty (send ?scCour:course get-ingredients))
    )
    (printout ?*debug-print* "DEBUG: reduced score of course " ?scCour:course " because it has " ?ingrQty " with nutrient " ?nutrQty crlf)
    (send ?scCour add-score (* ?self:value ?ingrQty:quantity ?nutrQty:quantity 0.1))
  )
)

(defmessage-handler inference_of_data::FoodType apply-as-preference (?value)
  (do-for-all-instances  ((?scCour ScoredCourse) (?ingrQty IngredientQuantity))
    (and
      (member$ (instance-name ?self) (send ?ingrQty:ingredient get-types))
      (member$ ?ingrQty (send ?scCour:course get-ingredients))
    )
    (printout ?*debug-print* "DEBUG: changed score (" ?value ") of course " ?scCour:course " because it has " ?ingrQty " of type " ?self crlf)
    (send ?scCour add-score (* ?value ?ingrQty:quantity))
  )
)
