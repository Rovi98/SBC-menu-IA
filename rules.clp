;%%%%%
;%
;% DEFINITIONS
;%
;%%%%%

(defglobal
  ?*TEMPORADAS* = (create$ invierno primavera verano otono)
  ;?*EVENT_TYPES* = (create$ Familiar Congress)
  ;?*DRINK_TYPES* = (create$ Alcohol Soft-drinks Caffeine Juice none)
  ;?*CUISINE_STYLES* = (create$ Mediterranean Spanish Italian French Chinese Japanese Turkish American Mexican Indian Moroccan Gourmet any)
  ;?*DIETARY_RESTRICTIONS* = (create$ Gluten-free Vegan Vegetarian Lactose-free Kosher Islamic none)
)

;;; Template para la lista de los dias de la recomendacion
(deftemplate MAIN::lista-dias
	(multislot dias (type INSTANCE))
)

;;;********************
;;;* MENU STATE RULES *
;;;********************

(defrule normal-menu-state-conclusions ""
   (declare (salience 10))
   (vegetables-state normal)
   =>
   (assert (menu1 "Niceee")))
   
(defrule none-menu-state-conclusions ""
   (declare (salience 10))
   (vegetables-state none)
   =>
   (assert (menu1 "Bff..	")))
   
;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-age-range ""
  (not (age ?))
  =>
  (bind ?num (ask-question-num "How old are you?" 0 150))
  (if (<= 30 ?num) then
		(assert (age-range range1))
  )
  (if (and (> 30 ?num) (<= 50 ?num)) then
		(assert (age-range range2))
  )
)

(defrule determine-temporada ""
   (not (temporada ?))
   =>
   (bind ?response 
      (ask-question-opt "What season is it?" ?*TEMPORADAS*))
	  (assert(temporada ?response)))
	

(defrule determine-vegetables-state ""
   (not (vegetables-state ?))
   (not (menu1 ?))
   =>
   (if (ask-question-yes-no "Are you vegan? (yes/no) ") 
       then 
       (if (ask-question-yes-no "Why though? (yes/no) ")
           then (assert (vegetables-state none))
           else (assert (vegetables-state none)))
       else 
       (assert (vegetables-state normal))))
	   
;;;****************************
;;;* STARTUP AND OUTPUT RULES *
;;;****************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Food Menu v0.8")
  (printout t crlf crlf))
  
(defrule print-repair ""
  (declare (salience 10))
  (menu1 ?item)
  =>
  (printout t crlf crlf)
  (printout t "Monday:")
  (printout t crlf)
  (printout t "============================================" crlf)
  (printout t ?item)
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
	;;;(printout t (send ?curr-dia imprimir))
	;;;)
	;;;(assert (final))
;;;)