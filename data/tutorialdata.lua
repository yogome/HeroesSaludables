local tutorialdata = {
	---How to category
	[1] = {
		id = "moveOutCircle",
		name = "Control",
		pages = 1,
		description = {
			[1] = "Intenta moverte por el mapa tocando el control de la izquierda, intenta salir del circulo",
		},
		--animation = {1,2,3},
	},
	[2] = {
		id = "moveToBase",
		name = "Bases",
		description = {
			[1] = "Muy bien, ahora muevete a la base de la derecha",
		}
	},
	[3] = {
		id = "baseTutorial",
		name = "Bases de porciones",
		description = {
			[1] = "Cuando te acercas a una base, esta soltara una porción, recoje la porción que acaba de salir",
		}
	},
	[4] = {
		id = "collectPortion",
		name = "¡Muy bien!",
		description = {
			[1] = "Ahora lleva la porcion al planeta de la izquierda",
		}
	},
	[5] = {
		id = "finishLevel",
		name = "¡Excelente!",
		description = {
			[1] = "Ahora ya sabes como entregar porciones, entrega la porción restante para terminar el nivel",
		}
	},
}

return tutorialdata
