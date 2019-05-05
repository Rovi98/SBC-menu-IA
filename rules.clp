;%%%%%
;%
;% DEFINITIONS
;%
;%%%%%

(defglobal
  ?*DAYS* = (create$ Lunes Martes Miercoles Jueves Viernes)
  ?*MEALS* = (create$ Desayuno Comida Cena)
  ?*SEASONS* = (create$ Invierno Primavera Verano Otono)
  ?*DISEASE* = (create$ Diabetes Celiaco Intolerante-Lactosa Hipertension Osteoporosis VIH Cancer ELA Ebola none)
  ?*NOLIKE* = (create$ Fruits Vegetables Meat Fish Pasta none)
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

(defrule menu-done ""
   (declare (salience 10))
   (menu-done)
   =>
   (bind ?menuSemana (make-instance (gensym) of MenuSemana))
   (bind ?lista-platos (find-all-instances ((?p Plato)) TRUE))
   (loop-for-count (?i 5) do
      
      (bind ?desayuno 
        (make-instance (gensym) of Desayuno
          (plato (nth$ 1 ?lista-platos))
        )
      )
      (bind ?lista-platos (delete$ ?lista-platos 1 1))
      
      (bind ?comida 
        (make-instance (gensym) of Comida
          (primerPlato (nth$ 1 ?lista-platos))
          (segundoPlato (nth$ 2 ?lista-platos))
          (postre (nth$ 3 ?lista-platos))
        )
      )
      (bind ?lista-platos (delete$ ?lista-platos 1 3))

      (bind ?cena 
        (make-instance (gensym) of Cena
          (primerPlato (nth$ 1 ?lista-platos))
          (segundoPlato (nth$ 2 ?lista-platos))
          (postre (nth$ 3 ?lista-platos))
        )
      )
      (bind ?lista-platos (delete$ ?lista-platos 1 3))

      (bind ?menuDia 
        (make-instance (gensym) of MenuDia
          (desayuno ?desayuno)
          (comida ?comida)
          (cena ?cena)
        )
      )
      (slot-replace$ ?menuSemana menusDia ?i ?i ?menuDia)
      ;(slot-insert$ ?menuSemana menusDia 1 ?menuDia)
   )
   
   (print-menu ?menuSemana)
)

;(assert (menu-done))

(defrule normal-menu-state-conclusions ""
   (declare (salience 10))
   (vegetables-state ?)
   (age-range ?)
   (temporada ?)
   (disease ?)
   (nolike ?)
   (sex ?)
   (exercise ?)
   =>
   (assert (menu-done))
)
   
;;;***************
;;;* QUERY RULES *
;;;***************

(defrule determine-exercise ""
  (not (exercise ?))
  =>
   (bind ?response (ask-question-opt "How much exercise do you do per week?" (create$ None Once-a-week Twice-a-week More)))
   (assert(exercise ?response))
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

(defrule determine-sex ""
  (not (sex ?))
  =>
   (bind ?response (ask-question-opt "What is your gender?" (create$ Male Female Other Non-Binary)))
   (assert(sex ?response))
)

(defrule determine-dont-like ""
  (not (nolike ?))
  =>
   (bind ?response (ask-question-multi-opt "Is there something that you do not like?" ?*NOLIKE*))
   (assert(nolike ?response))
)

(defrule determine-temporada ""
   (not (temporada ?))
   =>
   (bind ?response (ask-question-opt "Which season do you want the menu for?" ?*SEASONS*))
	 (assert(temporada ?response))
)

(defrule determine-vegetables-state ""
   (not (vegetables-state ?))
   (not (menu1 ?))
   =>
   (if (ask-question-yes-no "Do you eat meat?") 
       then 
       (assert (vegetables-state normal))
       else 
       (if (ask-question-yes-no "Do you eat milk or egs?")
           then (assert (vegetables-state vegeterian))
           else (assert (vegetables-state vegan)))
       ))
       
(defrule determine-disease ""
  (not (disease $?))
  =>
   (bind ?response (ask-question-multi-opt "Do you have any of the following diseases? Write more than one if needed." ?*DISEASE*))
   (assert(disease ?response))
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

;;;************
;;;* MESSAGES *
;;;************

(defmessage-handler Desayuno imprimir ()
  (printout t "|| · " (send ?self:plato get-nombre) crlf)
)

(defmessage-handler Comida imprimir ()
  (printout t "|| · [1r Plato] " (send ?self:primerPlato get-nombre) crlf)
  (printout t "|| · [2o Plato] " (send ?self:segundoPlato get-nombre) crlf)
  (printout t "|| · [Postre] " (send ?self:postre get-nombre) crlf)
)

(defmessage-handler Cena imprimir ()
  (printout t "|| · [1r Plato] " (send ?self:primerPlato get-nombre) crlf)
  (printout t "|| · [2o Plato] " (send ?self:segundoPlato get-nombre) crlf)
  (printout t "|| · [Postre] " (send ?self:postre get-nombre) crlf)
)

(defmessage-handler MenuDia imprimir ()
  (printout t "||" crlf)
  (printout t "|| >>> Desayuno <<<" crlf)
  (printout t (send ?self:desayuno imprimir))
  (printout t "||" crlf)
  (printout t "|| >>>  Comida  <<<" crlf)
  (printout t (send ?self:comida imprimir))
  (printout t "||" crlf)
  (printout t "|| >>>   Cena   <<<" crlf)
  (printout t (send ?self:cena imprimir))
  (printout t "||" crlf)
)

(defmessage-handler MenuSemana imprimir ()
  (loop-for-count (?i 1 5) do
    (printout t "============================================" crlf)     
    (printout t "|||| " (nth$ ?i ?*DAYS*) crlf)
    (printout t "============================================" crlf)     
    (printout t (send (nth$ ?i ?self:menusDia) imprimir))
  )
  (printout t "============================================" crlf)
)
