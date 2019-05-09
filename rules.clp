;%%%%%
;%
;% DEFINITIONS
;%
;%%%%%

(defglobal
  ?*WEEKDAYS* = (create$ Monday Tuesday Wednesday Thursday Friday Saturday Sunday)
  ?*MEALS* = (create$ Breakfast Lunch Dinner)
  ?*SEASONS* = (slot-allowed-values Course season)
  ?*DISEASES* = (create$ Diabetes Celiaco Intolerante-Lactosa Hipertension Osteoporosis VIH Cancer ELA Ebola)
  ?*FOODTYPES* = (create$ Fruits Vegetables Meat Fish Pasta)
  ;?*EVENT_TYPES* = (create$ Familiar Congress)
  ;?*DRINK_TYPES* = (create$ Alcohol Soft-drinks Caffeine Juice none)
  ;?*CUISINE_STYLES* = (create$ Mediterranean Spanish Italian French Chinese Japanese Turkish American Mexican Indian Moroccan Gourmet any)
  ;?*DIETARY_RESTRICTIONS* = (create$ Gluten-free Vegan Vegetarian Lactose-free Kosher Islamic none)
)

;;;********************
;;;* MENU STATE RULES *
;;;********************

(defrule menu-done ""
   (declare (salience 10))
   (menu-done)
   =>
   (bind ?menuWeek (make-instance (gensym) of MenuWeek))
   (bind ?list-courses (find-all-instances ((?c Course)) TRUE))
   (loop-for-count (?i 7) do

      (bind ?breakfast
        (make-instance (gensym) of Breakfast
          (course (random-from-list ?list-courses))
        )
      )

      (bind ?lunch
        (make-instance (gensym) of Lunch
          (firstCourse (random-from-list ?list-courses))
          (secondCourse (random-from-list ?list-courses))
          (desert (random-from-list ?list-courses))
        )
      )

      (bind ?dinner
        (make-instance (gensym) of Dinner
          (firstCourse (random-from-list ?list-courses))
          (secondCourse (random-from-list ?list-courses))
          (desert (random-from-list ?list-courses))
        )
      )

      (bind ?menuDay
        (make-instance (gensym) of MenuDay
          (breakfast ?breakfast)
          (lunch ?lunch)
          (dinner ?dinner)
        )
      )
      (slot-replace$ ?menuWeek menusDay ?i ?i ?menuDay)
      ;(slot-insert$ ?menuSemana menusDia 1 ?menuDia)
   )

   (print-menu ?menuWeek)
)

;(assert (menu-done))

(defrule normal-menu-state-conclusions ""
   (declare (salience 10))
   (vegetables-state ?)
   (age-range ?)
   (season ?)
   (diseases ?)
   (sex ?)
   (exercise ?)
   (preferences-positive ?)
   (preferences-negative ?)
   =>
   (assert (menu-done))
)

(defrule vegetables-state-vegetarian ""
   (vegetables-state vegetarian)
   =>
    (bind ?pref (nth$ 1 (find-instance ((?p Preference)) (eq ?p:name_ "Vegetarian"))))
    (foreach ?lim (send ?pref get-limitations)
      (send ?lim apply)
    )
)

;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-preferences-positive ""
  (not (preferences-positive ?))
  =>
   (bind ?response (ask-question-multi-opt "Do you really like any of the following foods? List as many as required." ?*FOODTYPES*))
   (assert(preferences-positive ?response))
)

(defrule determine-preferences-negative ""
  (not (preferences-negative ?))
  =>
   (bind ?response (ask-question-multi-opt "Do you dislike any of the following foods? List as many as required." ?*FOODTYPES*))
   (assert(preferences-negative ?response))
)

(defrule determine-vegetables-state ""
   (not (vegetables-state ?))
   =>
   (if (ask-question-yes-no "Do you eat meat?")
       then
       (assert (vegetables-state normal))
       else
       (if (ask-question-yes-no "Do you eat milk or egs?")
           then (assert (vegetables-state vegetarian))
           else (assert (vegetables-state vegan))
      )
    )
)

(defrule determine-disease ""
  (not (diseases $?))
  =>
   (bind ?response (ask-question-multi-opt "Do you have any of the following diseases? List as many as required." ?*DISEASES*))
   (assert(diseases ?response))
)

(defrule determine-exercise ""
  (not (exercise ?))
  =>
   (bind ?response (ask-question-opt "How much exercise do you do per week?" (create$ None Once-a-week Twice-a-week More)))
   (assert(exercise ?response))
)

(defrule determine-sex ""
  (not (sex ?))
  =>
   (bind ?response (ask-question-opt "What is your gender?" (create$ Male Female n/a)))
   (assert(sex ?response))
)

(defrule determine-age-range ""
  (not (age ?))
  =>
  (bind ?num (ask-question-num "How old are you?" 0 150))
  (if (< ?num 65) then
    (assert (age-range range1))
  )
  (if (<= 65 ?num 74) then
    (assert (age-range range2))
  )
  (if (<= 75 ?num 84) then
    (assert (age-range range3))
  )
  (if (<= 85 ?num ) then
    (assert (age-range range4))
  )
)

(defrule determine-season ""
   (not (temporada ?))
   =>
   (bind ?response (ask-question-opt "Which season do you want the menu for?" ?*SEASONS*))
	 (assert(season ?response))
)

;;;****************************
;;;* STARTUP AND OUTPUT RULES *
;;;****************************

(defrule system-banner ""
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
  (printout t "|| · [1r Plato] " (send ?self:firstCourse get-name_) crlf)
  (printout t "|| · [2o Plato] " (send ?self:secondCourse get-name_) crlf)
  (printout t "|| · [Postre] " (send ?self:desert get-name_) crlf)
)

(defmessage-handler Dinner display ()
  (printout t "|| · [1r Plato] " (send ?self:firstCourse get-name_) crlf)
  (printout t "|| · [2o Plato] " (send ?self:secondCourse get-name_) crlf)
  (printout t "|| · [Postre] " (send ?self:desert get-name_) crlf)
)

(defmessage-handler MenuDay display ()
  (printout t "||" crlf)
  (printout t "|| >>> Desayuno <<<" crlf)
  (printout t (send ?self:breakfast display))
  (printout t "||" crlf)
  (printout t "|| >>>  Comida  <<<" crlf)
  (printout t (send ?self:lunch display))
  (printout t "||" crlf)
  (printout t "|| >>>   Cena   <<<" crlf)
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

(defmessage-handler Ingredient gett-energy ()
  ; Las grasas tienen un contenido energético de 9 kcal/g (37,7 kJ/g);
  ; proteínas y carbohidratos tienen 4 kcal/g (16,7 kJ/g).
  ; El etanol tienen contenido de energía de 7 kcal/g (29,3 kJ/g).
  ; source: Wikipedia
  ;(bind ?kcal (+ (* 9 ?self:grasas) (* 7 ?self:proteinas) (* 7 ?self:carbohidratos)))
  ;(return ?kcal)
  (return 0)
)

(defmessage-handler LimitationType apply ()
  (do-for-all-instances  ((?cour Course) (?ingrQty IngredientQuantity))
    (and 
      (member$ ?ingrQty ?cour:ingredients)
      (eq ?self:type (send ?ingrQty:ingredient get-type))
    )
    (bind ?prev_score (send ?cour get-score))
    (printout t "DEBUG: reduced score of course " ?cour " because it has " ?ingrQty crlf)
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

