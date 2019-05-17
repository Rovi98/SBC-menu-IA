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
		(create-accessor read-write))
)

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
		(create-accessor read-write))
)

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
		(create-accessor read-write))
)

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
		(create-accessor read-write))
)

(defclass Breakfast
	(is-a Meal)
	(role concrete)
	(slot course
		(type INSTANCE)
		(create-accessor read-write))
)

(defclass ScoredCourse
  (is-a USER)
  (role concrete)
  (slot course
    (type INSTANCE)
    (create-accessor read-write))
  (slot score
    (type FLOAT)
    (create-accessor read-write))
  (slot calories
    (type FLOAT)
    (create-accessor read-write))
)