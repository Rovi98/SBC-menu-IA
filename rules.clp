;%%%%%
;%
;% DEFINITIONS
;%
;%%%%%

(defglobal ?*debug-print* = t) ; nil vs t

(deftemplate user
  (slot sex (type SYMBOL))
  (slot age-range (type INTEGER))
  (slot exercise-level (type SYMBOL))
  (multislot foodtypes-positive (type INSTANCE))
  (multislot foodtypes-negative (type INSTANCE))
  (multislot preferences (type INSTANCE))
  (multislot diseases (type INSTANCE))
)

(deffacts facts-initialization
    (user)
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

(defrule menu-done
   (declare (salience 10))
   (menu-done)
   =>
    (bind ?menuWeek (make-instance (gensym) of MenuWeek))
    (bind ?list-courses (sort-courses (find-all-instances ((?c Course)) TRUE)))

    (bind ?breakfasts (get-n-courses-of-category ?list-courses 7 Breakfast))
    (bind ?firstCourses (get-n-courses-of-category ?list-courses (* 7 2) FirstCourse))
    (bind ?secondCourses (get-n-courses-of-category ?list-courses (* 7 2) SecondCourse))
    (bind ?desserts (get-n-courses-of-category ?list-courses (* 7 2) Dessert))

   (loop-for-count (?i 0 6) do
      (bind ?breakfast
        (make-instance (gensym) of Breakfast
          (course (nth$ (+ ?i 1) ?breakfasts))
        )
      )
      (bind ?lunch
        (make-instance (gensym) of Lunch
          (firstCourse (nth$ (+ (* ?i 2) 1) ?firstCourses))
          (secondCourse (nth$ (+ (* ?i 2) 1) ?secondCourses))
          (dessert (nth$ (+ (* ?i 2) 1) ?desserts))
        )
      )

      (bind ?dinner
        (make-instance (gensym) of Dinner
          (firstCourse (nth$ (+ (* ?i 2) 2) ?firstCourses))
          (secondCourse (nth$ (+ (* ?i 2) 2) ?secondCourses))
          (dessert (nth$ (+ (* ?i 2) 2) ?desserts))
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
      ;(slot-insert$ ?menuSemana menusDia 1 ?menuDia)
   )

   (printout t crlf "############################################")
   (printout t crlf "############################################" crlf crlf)
   
   (print-menu ?menuWeek)

   (printout t crlf "############################################")
   (printout t crlf "############################################" crlf crlf)

   (bind ?calories (send ?menuWeek get-calories))

   (printout t "Total Calories: " (integer ?calories) crlf)
   (printout t "Approx. Calories per Day: " (integer (/ ?calories 7)) crlf)

   (printout t crlf "############################################")
   (printout t crlf "############################################" crlf crlf)
)

;(assert (menu-done))

(defrule normal-menu-state-conclusions
  (declare (salience 10))
  (asked-age-range)
  (season ?)
  (asked-vegetables-preference)
  (asked-diseases)
  (asked-sex)
  (asked-exercise-level)
  (asked-foodtypes-positive)
  (asked-foodtypes-negative)
   =>
   (assert (menu-done))
)

(defrule apply-preferences
  (asked-vegetables-preference)
  (not (applied-preferences))
  (user (preferences $?prefs))
   =>
    (foreach ?pref ?prefs
      (foreach ?lim (send ?pref get-limitations)
        (send ?lim apply)
      )
    )
    (assert (applied-preferences))
)

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-age-range
  (not (asked-age-range))
  ?user <- (user)
  =>
    (bind ?num (ask-question-num "How old are you?" 0 150))
    (if (< ?num 65) then
      (modify ?user (age-range 1))
    )
    (if (<= 65 ?num 74) then
      (modify ?user (age-range 2))
    )
    (if (<= 75 ?num 84) then
      (modify ?user (age-range 3))
    )
    (if (<= 85 ?num ) then
      (modify ?user (age-range 4))
    )
    (assert (asked-age-range))
)

(defrule determine-sex
  (not (asked-sex))
  ?user <- (user)
  =>
    (bind ?response (ask-question-opt "What is your gender?" (create$ Male Female n/a)))
    (modify ?user (sex ?response))
    (assert (asked-sex))
)

(defrule determine-exercise-level
  (not (asked-exercise-level))
  ?user <- (user)
  =>
   (bind ?response (ask-question-opt "How much exercise do you do per week?" (create$ None Once-a-week Twice-a-week More)))
   (modify ?user (exercise-level ?response))
   (assert (asked-exercise-level))
)

(defrule determine-diseases
  (not (asked-diseases))
  ?user <- (user)
  =>
   (bind ?response (ask-question-multi-opt-instances "Do you have any of the following diseases? List as many as required." Disease (create$)))
   (modify ?user (diseases ?response))
   (assert (asked-diseases))
)

(defrule determine-vegetables-preference
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

(defrule determine-foodtypes-positive
  (not (asked-foodtypes-positive))
  (user (foodtypes-negative $?exclude))
  ?user <- (user)
  =>
    (bind ?response (ask-question-multi-opt-instances "Do you really LIKE any of the following foods? List as many as required." FoodType $?exclude))
    (modify ?user (foodtypes-positive ?response))
    (assert (asked-foodtypes-positive))
)

(defrule determine-foodtypes-negative
  (not (asked-foodtypes-negative))
  (user (foodtypes-positive $?exclude))
  ?user <- (user)
  =>
    (bind ?response (ask-question-multi-opt-instances "Do you DISLIKE any of the following foods? List as many as required." FoodType $?exclude))
    (modify ?user (foodtypes-negative ?response))
    (assert (asked-foodtypes-negative))
)

(defrule determine-season
   (not (temporada ?))
   =>
   (bind ?response (ask-question-opt "Which season do you want the menu for?" ?*SEASONS*))
	 (assert(season ?response))
)

;;;****************************
;;;* STARTUP AND OUTPUT RULES *
;;;****************************

(defrule system-banner
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Food Menu v0.8")
  (printout t crlf crlf))

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

(defmessage-handler Breakfast display ()
  (printout t "|| · " (send ?self:course get-name_) crlf)
)

(defmessage-handler Lunch display ()
  (printout t "|| · " (send ?self:firstCourse get-name_) crlf)
  (printout t "|| · " (send ?self:secondCourse get-name_) crlf)
  (printout t "|| · " (send ?self:dessert get-name_) crlf)
)

(defmessage-handler Dinner display ()
  (printout t "|| · " (send ?self:firstCourse get-name_) crlf)
  (printout t "|| · " (send ?self:secondCourse get-name_) crlf)
  (printout t "|| · " (send ?self:dessert get-name_) crlf)
)

(defmessage-handler MenuDay display ()
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

(defmessage-handler MenuWeek display ()
  (loop-for-count (?i 1 7) do
    (printout t "============================================" crlf)
    (printout t "|||| " (nth$ ?i ?*WEEKDAYS*) crlf)
    (printout t "============================================" crlf)
    (printout t (send (nth$ ?i ?self:menusDay) display))
  )
  (printout t "============================================" crlf)
)

(defmessage-handler NutrientQuantity get-name_ ()
  (send ?self:nutrient get-name_)
)

(defmessage-handler IngredientQuantity get-name_ ()
  (send ?self:ingredient get-name_)
)

(defmessage-handler Ingredient get-calories ()
  (foreach ?nutrientQty ?self:nutrients
    (if (eq (send ?nutrientQty get-nutrient) [Nutrient_calories]) then
      (return (send ?nutrientQty get-quantity))
    )
  )
  0
)

(defmessage-handler IngredientQuantity get-calories ()
  (* ?self:quantity (send ?self:ingredient get-calories))
)

(defmessage-handler Course get-calories ()
  (bind ?sum 0)
  (foreach ?ingredientQty ?self:ingredients
    (bind ?sum (+ ?sum (send ?ingredientQty get-calories)))
  )
)

(defmessage-handler Breakfast get-calories ()
  (send ?self:course get-calories)
)

(defmessage-handler Lunch get-calories ()
  (+ (send ?self:firstCourse get-calories) (send ?self:secondCourse get-calories) (send ?self:dessert get-calories))
)

(defmessage-handler Dinner get-calories ()
  (+ (send ?self:firstCourse get-calories) (send ?self:secondCourse get-calories) (send ?self:dessert get-calories))
)

(defmessage-handler MenuDay get-calories ()
  (+ (send ?self:breakfast get-calories) (send ?self:lunch get-calories) (send ?self:dinner get-calories))
)

(defmessage-handler MenuWeek get-calories ()
  (bind ?sum 0)
  (foreach ?menuDay ?self:menusDay
    (bind ?sum (+ ?sum (send ?menuDay get-calories)))
  )
)

(defmessage-handler LimitationType apply ()
  (do-for-all-instances  ((?cour Course) (?ingrQty IngredientQuantity))
    (and 
      (member$ ?ingrQty ?cour:ingredients)
      (eq ?self:type (send ?ingrQty:ingredient get-type))
    )
    (bind ?prev_score (send ?cour get-score))
    (printout ?*debug-print* "DEBUG: reduced score of course " ?cour " because it has " ?ingrQty crlf)
    (send ?cour put-score (+ ?prev_score (* ?self:value (send ?ingrQty get-quantity))))
  )
)

; (defmessage-handler LimitationNutrient apply ()
;   (do-for-all-instances  ((?cour Course) (?ingrQty IngredientQuantity) (?nutrQty Nutrient))
;     (and 
;       (member$ ?ingrQty (send ?cour get-ingredients))
;       (member$ ?nutr (send ?cour get-nutrients))
;       (eq ?self:type  (send (send ?ingrQty get-ingredient) get-type))
;     )
;     (bind ?prev_score (send ?cour get-score))
;     (printout t "DEBUG: reduced score of course " ?cour " because it has " ?ingrQty crlf)
;     (send ?cour put-score (+ ?prev_score (* ?self:value (send ?ingrQty get-quantity))))
;   )
; )

