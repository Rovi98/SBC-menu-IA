;%%%%%
;%
;% CLASSES
;%
;%%%%%

(defclass MenuWeek
	(is-a USER)
	(role concrete)
	(multislot menusDay
		(type INSTANCE)
		(cardinality 7 7)
		(create-accessor read-write)))

(defclass MenuDay
	(is-a USER)
	(role concrete)
	(slot breakfast
		(type INSTANCE)
		(create-accessor read-write))
	(slot dinner
		(type INSTANCE)
		(create-accessor read-write))
	(slot lunch
		(type INSTANCE)
		(create-accessor read-write)))

(defclass Meal
	(is-a USER)
	(role concrete))

(defclass Lunch
	(is-a Meal)
	(role concrete)
	(slot dessert
		(type INSTANCE)
		(create-accessor read-write))
	(slot secondCourse
		(type INSTANCE)
		(create-accessor read-write))
	(slot firstCourse
		(type INSTANCE)
		(create-accessor read-write)))

(defclass Dinner
	(is-a Meal)
	(role concrete)
	(slot dessert
		(type INSTANCE)
		(create-accessor read-write))
	(slot secondCourse
		(type INSTANCE)
		(create-accessor read-write))
	(slot firstCourse
		(type INSTANCE)
		(create-accessor read-write)))

(defclass Breakfast
	(is-a Meal)
	(role concrete)
	(slot course
		(type INSTANCE)
		(create-accessor read-write)))

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
  (import  generate_solutions ?ALL)
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
  (slot required-calories (type FLOAT))
  (slot height (type INTEGER))
  (slot weight (type FLOAT))
  (multislot foodtypes-positive (type INSTANCE))
  (multislot foodtypes-negative (type INSTANCE))
  (multislot preferences (type INSTANCE))
  (multislot diseases (type INSTANCE))
)

(deftemplate MAIN::best-menu
  (slot menu (type INSTANCE))
  (slot score (type INTEGER) (default -999999))
)

(deftemplate MAIN::sorted-courses
  (multislot breakfasts (type INSTANCE))
  (multislot firstCourses (type INSTANCE))
  (multislot secondCourses (type INSTANCE))
  (multislot desserts (type INSTANCE))
)

(deffacts MAIN::facts-initialization
    (user)
    (sorted-courses)
	(best-menu)
)

(defglobal
  ?*WEEKDAYS* = (create$ Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
  ?*MEALS* = (create$ Breakfast Lunch Dinner)
  ?*SEASONS* = (slot-allowed-values Course season)
  ;?*EVENT_TYPES* = (create$ Familiar Congress)
  ;?*DRINK_TYPES* = (create$ Alcohol Soft-drinks Caffeine Juice none)
  ;?*CUISINE_STYLES* = (create$ Mediterranean Spanish Italian French Chinese Japanese Turkish American Mexican Indian Moroccan Gourmet any)
  ;?*DIETARY_RESTRICTIONS* = (create$ Gluten-free Vegan Vegetarian Lactose-free Kosher Islamic none)
)

;;;********************
;;;* MENU STATE RULES *
;;;********************

(defrule generate_solutions::sort-courses
   (declare (salience 10))
   (not (sort-courses-done))
   ?sorted-courses <- (sorted-courses)
   =>
    (bind ?breakfasts (sort-courses (find-all-instances ((?c Course)) (member$ Breakfast ?c:category))))
    (bind ?firstCourses (sort-courses (find-all-instances ((?c Course)) (member$ FirstCourse ?c:category))))
    (bind ?secondCourses (sort-courses (find-all-instances ((?c Course)) (member$ SecondCourse ?c:category))))
    (bind ?desserts (sort-courses (find-all-instances ((?c Course)) (member$ Dessert ?c:category))))

    (modify ?sorted-courses (breakfasts ?breakfasts))
    (modify ?sorted-courses (firstCourses ?firstCourses))
    (modify ?sorted-courses (secondCourses ?secondCourses))
    (modify ?sorted-courses (desserts ?desserts))
	
	(assert (sort-courses-done))
)

(defrule generate_solutions::generate-menu
	(declare (salience 10))
	(sort-courses-done)
	(user (required-calories ?req-calories))
	?best-menu <- (best-menu)
	(best-menu (score ?bestScore))
	(sorted-courses (breakfasts $? ?bf1 $? ?bf2 $? ?bf3 $? ?bf4 $? ?bf5 $? ?bf6 $? ?bf7))
	(sorted-courses (firstCourses $? ?fc1 $? ?fc2 $? ?fc3 $? ?fc4 $? ?fc5 $? ?fc6 $? ?fc7 $? ?fc8 $? ?fc9 $? ?fc10 $? ?fc11 $? ?fc12 $? ?fc13 $? ?fc14))
	(sorted-courses (secondCourses $? ?sc1 $? ?sc2 $? ?sc3 $? ?sc4 $? ?sc5 $? ?sc6 $? ?sc7 $? ?sc8 $? ?sc9 $? ?sc10 $? ?sc11 $? ?sc12 $? ?sc13 $? ?sc14))
	(sorted-courses (desserts $? ?ds1 $? ?ds2 $? ?ds3 $? ?ds4 $? ?ds5 $? ?ds6 $? ?ds7 $? ?ds8 $? ?ds9 $? ?ds10 $? ?ds11 $? ?ds12 $? ?ds13 $? ?ds14))
	(test (within-tolerance
	(count-calories	?bf1 ?bf2 ?bf3 ?bf4 ?bf5 ?bf6 ?bf7
					?fc1 ?fc2 ?fc3 ?fc4 ?fc5 ?fc6 ?fc7 ?fc8 ?fc9 ?fc10 ?fc11 ?fc12 ?fc13 ?fc14
					?sc1 ?sc2 ?sc3 ?sc4 ?sc5 ?sc6 ?sc7 ?sc8 ?sc9 ?sc10 ?sc11 ?sc12 ?sc13 ?sc14
					?ds1 ?ds2 ?ds3 ?ds4 ?ds5 ?ds6 ?ds7 ?ds8 ?ds9 ?ds10 ?ds11 ?ds12 ?ds13 ?ds14 )
	?req-calories ;11000
	1000
	))
   =>

	(bind ?chosenBreakfasts (create$ ?bf1 ?bf2 ?bf3 ?bf4 ?bf5 ?bf6 ?bf7))
	(bind ?chosenFirstCourses (create$ ?fc1 ?fc2 ?fc3 ?fc4 ?fc5 ?fc6 ?fc7 ?fc8 ?fc9 ?fc10 ?fc11 ?fc12 ?fc13 ?fc14))
	(bind ?chosenSecondCourses (create$ ?sc1 ?sc2 ?sc3 ?sc4 ?sc5 ?sc6 ?sc7 ?sc8 ?sc9 ?sc10 ?sc11 ?sc12 ?sc13 ?sc14))
	(bind ?chosenDessert (create$ ?ds1 ?ds2 ?ds3 ?ds4 ?ds5 ?ds6 ?ds7 ?ds8 ?ds9 ?ds10 ?ds11 ?ds12 ?ds13 ?ds14))

	(bind ?score (count-score (create$ ?chosenBreakfasts ?chosenFirstCourses ?chosenSecondCourses ?chosenDessert)))

	(if (> ?score ?bestScore) then
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
				(dessert (nth$ (+ (* ?i 2) 1) ?chosenDessert))
			)
		)

		(bind ?dinner
			(make-instance (gensym) of Dinner
				(firstCourse (nth$ (+ (* ?i 2) 2) ?chosenFirstCourses))
				(secondCourse (nth$ (+ (* ?i 2) 2) ?chosenSecondCourses))
				(dessert (nth$ (+ (* ?i 2) 2) ?chosenDessert))
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

		(modify ?best-menu (menu ?menuWeek) (score ?score))
		
		(focus printing)
	)
)

(defrule printing::print-result 
   (best-menu (score ?score) (menu ?menu))
	=>
   (printout t crlf "############################################")
   (printout t crlf "############################################" crlf crlf)
   
   (print-menu ?menu)

   (printout t crlf "############################################")
   (printout t crlf "############################################" crlf crlf)

   (bind ?calories (send ?menu get-calories))

   (printout t "Total Calories: " (integer ?calories) crlf)
   (printout t "Approx. Calories per Day: " (integer (/ ?calories 7)) crlf)

   (printout t crlf "############################################")
   (printout t crlf "############################################" crlf crlf)
   
   (printout t ?score crlf)
)

;(assert (menu-done))

(defrule ask_questions::normal-menu-state-conclusions
  (declare (salience 10))
  (asked-age)
  (season ?)
  (asked-weight)
  (asked-height)
  (asked-vegetables-preference)
  (asked-diseases)
  (asked-sex)
  (asked-exercise-level)
  (asked-foodtypes-positive)
  (asked-foodtypes-negative)
   =>
   (focus inference_of_data)
   (printout t "Processing the data obtained..." crlf)
)

(defrule inference_of_data::apply-specific-preferences
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
  (asked-foodtypes-positive)
  (asked-foodtypes-negative)
  (not (applied-foodtypes-preferences))
  (user (foodtypes-positive $?types-positive))
  (user (foodtypes-negative $?types-negative))
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
  (calories-calculated)
  
   =>
    (printout t "Generating solution..." crlf)
    (focus generate_solutions)
)

(defrule inference_of_data::calories-calculator
	(not (calories-calculated))
	?user <- (user)
	(user (height ?height-var))
	(user (weight ?weight-var))
	(user (age ?age-var))
	(user (exercise-level ?exercise-var))
	(user (sex ?sex-var))
	=>
	(bind ?BMR (calculate-calories ?sex-var ?weight-var ?height-var ?age-var ?exercise-var))
	(printout ?*debug-print* "DEBUG: Calories: " ?BMR crlf)
	(modify ?user (required-calories ?BMR))
	(assert (calories-calculated))
)


;;;***************
;;;* QUERY RULES *
;;;***************

(defrule ask_questions::determine-age
  (not (asked-age))
  ?user <- (user)
  =>
    (bind ?num (ask-question-num "How old are you?" 0 150))
    (modify ?user (age ?num))
    (assert (asked-age))
)

(defrule ask_questions::determine-height
  (not (asked-height))
  ?user <- (user)
  =>
    (bind ?num (ask-question-num "How tall are you? (cm)" 0 300))
    (modify ?user (height ?num))
    (assert (asked-height))
)

(defrule ask_questions::determine-weight
  (not (asked-weight))
  ?user <- (user)
  =>
    (bind ?num (ask-question-num "What is your weight? (Kg)" 0 300))
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
  (user (preferences $?prefs))
  ?user <- (user)
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
  (user (foodtypes-negative $?exclude))
  ?user <- (user)
  =>
    (bind ?response (ask-question-multi-opt-instances "Do you really LIKE any of the following foods? List as many as required." FoodType $?exclude))
    (modify ?user (foodtypes-positive ?response))
    (assert (asked-foodtypes-positive))
)

(defrule ask_questions::determine-foodtypes-negative
  (not (asked-foodtypes-negative))
  (user (foodtypes-positive $?exclude))
  ?user <- (user)
  =>
    (bind ?response (ask-question-multi-opt-instances "Do you DISLIKE any of the following foods? List as many as required." FoodType $?exclude))
    (modify ?user (foodtypes-negative ?response))
    (assert (asked-foodtypes-negative))
)

(defrule ask_questions::determine-season
   (not (temporada ?))
   =>
   (bind ?response (ask-question-opt "Which season do you want the menu for?" ?*SEASONS*))
	 (assert(season ?response))
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

(defmessage-handler printing::Breakfast display ()
  (printout t "|| · " (send ?self:course get-name_) crlf)
)

(defmessage-handler printing::Lunch display ()
  (printout t "|| · " (send ?self:firstCourse get-name_) crlf)
  (printout t "|| · " (send ?self:secondCourse get-name_) crlf)
  (printout t "|| · " (send ?self:dessert get-name_) crlf)
)

(defmessage-handler printing::Dinner display ()
  (printout t "|| · " (send ?self:firstCourse get-name_) crlf)
  (printout t "|| · " (send ?self:secondCourse get-name_) crlf)
  (printout t "|| · " (send ?self:dessert get-name_) crlf)
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
      (return (* 0.01 (send ?nutrientQty get-quantity)))
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

(defmessage-handler generate_solutions::LimitationType apply ()
  (do-for-all-instances  ((?cour Course) (?ingrQty IngredientQuantity))
    (and
      (eq ?self:type (send ?ingrQty:ingredient get-type))
      (member$ ?ingrQty ?cour:ingredients)
    )
    (printout ?*debug-print* "DEBUG: reduced score of course " ?cour " because it has " ?ingrQty " of type " ?self:type crlf)
    (send ?cour put-score (+ ?cour:score (* ?self:value ?ingrQty:quantity)))
  )
)

(defmessage-handler generate_solutions::LimitationNutrient apply ()
  (do-for-all-instances  ((?cour Course) (?ingrQty IngredientQuantity) (?nutrQty NutrientQuantity))
    (and
      (eq ?self:nutrient ?nutrQty:nutrient)
      (member$ ?nutrQty (send ?ingrQty:ingredient get-nutrients))
      (member$ ?ingrQty ?cour:ingredients)
    )
    (printout t "DEBUG: reduced score of course " ?cour " because it has " ?ingrQty " with nutrient " ?nutrQty crlf)
    (send ?cour put-score (+ ?cour:score (* ?self:value ?ingrQty:quantity ?nutrQty:quantity 0.1)))
  )
)

(defmessage-handler generate_solutions::FoodType apply-as-preference (?value)
  (do-for-all-instances  ((?cour Course) (?ingrQty IngredientQuantity))
    (and
      (eq (instance-name ?self) (send ?ingrQty:ingredient get-type))
      (member$ ?ingrQty ?cour:ingredients)
    )
    (printout ?*debug-print* "DEBUG: changed score (" ?value ") of course " ?cour " because it has " ?ingrQty " of type " ?self crlf)
    (send ?cour put-score (+ ?cour:score (* ?value ?ingrQty:quantity)))
  )
)