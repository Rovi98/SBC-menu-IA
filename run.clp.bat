;;;(batch "run.clp.bat")
(clear)
(load "ontology.pont")
(load "aux_classes.clp")
(load "functions.clp")
(load "rules.clp")
(reset)
(load-instances "instances/Courses.pins")
(load-instances "instances/Ingredients.pins")
(load-instances "instances/IngredientsQuantity.pins")
(load-instances "instances/FoodTypes.pins")
(load-instances "instances/Nutrients.pins")
(load-instances "instances/NutrientsQuantity.pins")
(load-instances "instances/Diseases.pins")
(load-instances "instances/LimitationsNutrient.pins")
(load-instances "instances/LimitationsType.pins")
(load-instances "instances/Preferences.pins")
(run)
