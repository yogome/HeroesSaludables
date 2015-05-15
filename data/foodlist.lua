local assetPath = "images/food/"
local foodData = {
	["vegetable"] = { -- "Verduras"
		asset = assetPath .. "vegetable/base.png",
		name = "Verduras",
		food = {
			[1] = {
				name = "apio",
				asset = assetPath .. "vegetable/v_apio.png",
				description = {
					[1] = "1 y 1/2 taza de apio crudo",
					[2] = "3/4 de taza de apio",
				}
			},
			[2] = {
				name = "brocoli",
				asset = assetPath .. "vegetable/v_brocoli.png",
				description = {
					[1] = "1 taza de brócoli",
					[2] = "3/4 de taza de apio",
				}
			},
			[3] = {
				name = "calabaza",
				asset = assetPath .. "vegetable/v_calabacita.png",
				description = {
					[1] = "1 pieza calabaza redonda",
					[2] = " 1/2 taza calabaza cocida,",
				}
			},
			[4] = {
				name = "cebolla",
				asset = assetPath .. "vegetable/v_cebolla.png",
				description = {
					[1] = "1/4 taza cebolla cocida",
					[2] = "1/2 taza cebolla rebanada",
				}
			},
			[5] = {
				name = "champinon",
				asset = assetPath .. "vegetable/v_champinon.png",
				description = {
					[1] = "1/2 taza champiñón entero cocido",
					[2] = "1 1/2 taza champiñón crudo rebanado",
					[3] = "1 taza champiñón crudo entero,",	 
				}
			},
			[6] = {
				name = "coliflor",
				asset = assetPath .. "vegetable/v_coliflor.png",
				description = {
					[1] = "3/4 taza coliflor cocida",
				}
			},
			[7] = {
				name = "ejotes",
				asset = assetPath .. "vegetable/v_ejotes.png",
				description = {
					[1] = "1/2 taza ejotes cocidos picados",
				}
			},
			[8] = {
				name = "espinaca",
				asset = assetPath .. "vegetable/v_espinaca.png",
				description = {
					[1] = "2 tazas espinaca cruda picada",
					[2] = "1/2 taza espinaca cocida",
				}
			},
			[9] = {
				name = "jitomate",
				asset = assetPath .. "vegetable/v_jitomate.png",
				description = {
					[1] = "1 pieza jitomate",
					[2] = "4 piezas jitomate cherry",
				}
			},
			[10] = {
				name = "nopal",
				asset = assetPath .. "vegetable/v_nopal.png",
				description = {
					[1] = "1 taza nopal cocido",
				}
			},
			[11] = {
				name = "zanahoria",
				asset = assetPath .. "vegetable/v_zanahoria.png",
				description = {
					[1] = "1/2 taza zanahoria rallada",
					[2] = "1/2 taza zanahoria picada.",
				},
			},
		},
	},
	["fruit"] = { -- "Frutas"
		asset = assetPath .. "fruit/base.png",
		name = "Frutas",
		food = {
			[1] = {
				name = "fresa",
				asset = assetPath .. "fruit/f_fresas.png",
				description = {
					[1] = "17 fresas medianas",
				},
			},
			[2] = {
				name = "manzana",
				asset = assetPath .. "fruit/f_manzana.png",
				description = {
					[1] = "1 manzana",
				},
			},
			[3] = {
				name = "naranja",
				asset = assetPath .. "fruit/f_naranja.png",
				description = {
					[1] = "2 naranjas",
				},
			},
			[4] = {
				name = "pera",
				asset = assetPath .. "fruit/f_pera.png",
				description = {
					[1] = "1/2 pera",
				},
			},
			[5] = {
				name = "platano",
				asset = assetPath .. "fruit/f_platano.png",
				description = {
					[1] = "1/2 plátano",
					[1] = "3 plátanos dominicos",
				},
			},
		}
	},
	["cereal"] = { -- "Cereales"
		asset = assetPath .. "cereal/base.png",
		name = "Cereales",
		food = {
			[1] = {
				name = "arroz",
				asset = assetPath .. "cereal/c_arroz.png",
				description = {
					[1] = "1/4 taza arroz cocido",
					[2] = "1/2 taza cereal de arroz",
				},
			},
			[2] = {
				name = "avena",
				asset = assetPath .. "cereal/c_avena.png",
				description = {
					[1] = "3/4 taza avena cocida",
					[2] = "1/3 taza hojuelas de avena",
				},
			},
			[3] = {
				name = "elote",
				asset = assetPath .. "cereal/c_elote.png",
				description = {
					[1] = "1 1/2 pieza elote amarillo cocido",
					[2] = "1/2 taza elote cocido desgranado",
					[3] = " 1/2 taza elote amarillo enlatado",
				},
			},
			[4] = {
				name = "pan",
				asset = assetPath .. "cereal/c_pan.png",
				 description = {
					[1] = "1 rebanada pan integral",
					[2] = "1/2 pieza pan árabe",
				},
			},
			[5] = {
				name = "pasta",
				asset = assetPath .. "cereal/c_pasta.png",
				description = {
					[1] = "1/2 taza pasta cocida",
					[2] = "1/4 taza pasta estrellitas cocidas",
					[3] = "1/4 taza pasta letras cocidas",
				},
			},
		},
	},
	["grain"] = { -- "Leguminosas"
		asset = assetPath .. "grain/base.png",
		name = "Leguminosas",
		food = {
			[1] = {
				name = "frijol",
				asset = assetPath .. "grain/le_frijol.png",
				description = {
					[1] = "1/2 taza frijol entero cocido",
					[2] = "1/3 taza frijoles refritos",
					[3] = "1/3 taza frijoles enlatados",
				},
			},
			[2] = {
				name = "haba",
				asset = assetPath .. "grain/le_haba.png",
				description = {
					[1] = "1/2 taza haba cocida",
				},
			},
		}
	},
	["protein"] = { -- "P. Animal"
		asset = assetPath .. "protein/base.png",
		name = "Origen Animal",
		food = {
			[1] = {
				name = "camaron",
				asset = assetPath .. "protein/a_camaron.png",
				description = {
					[1] = "5 piezas camarón cocido",
				},
			},
			[2] = {
				name = "carne",
				asset = assetPath .. "protein/a_carne.png",
				description = {
					[1] = "1/2 pieza chuleta ahumada",
					[2] = "30g bistec de res",
					[3] = "30g carne molida",
					[4] = "1 salchicha",
				},
			},
			[3] = {
				name = "huevo",
				asset = assetPath .. "protein/a_huevo.png",
				description = {
					[1] = "2 claras de huevo",
					[2] = "1 huevo entero",
				},
			},
			[4] = {
				name = "pollo",
				asset = assetPath .. "protein/a_pollo.png",
				description = {
					[1] = "25g pechuga de pollo asada",
					[2] = "30g pechuga desmenuzada",
				},
			},
			[5] = {
				name = "salmon",
				asset = assetPath .. "protein/a_salmon.png",
				description = {
					[1] = "35g salmón ahumado",
					[2] = "30 g salmón fresco",
					[3] = "30 g salmón cocido",
				},
			},
		},
	},
	["milk"] = { -- "Leche"
		asset = assetPath .. "milk/base.png",
		name = "Leche",
		food = {
			[1] = {
				name = "leche",
				asset = assetPath .. "milk/l_leche.png",
				description = {
					[1] = "1 taza leche descremada",
					[2] = "3/4 taza jocoque",
				},
			},
			[2] = {
				name = "yogourt",
				asset = assetPath .. "milk/l_yogourt.png",
				description = {
					[1] = "1 taza yogurt",
				},
			},
		},
	},
	["fat"] = { -- "Grasas"
		asset = assetPath .. "fat/base.png",
		name = "Grasas",
		food = {
			[1] = {
				name = "aguacate",
				asset = assetPath .. "fat/g_aguacate.png",
				description = {
					[1] = "3 rebanadas de aguacate",
				},
			},
			[2] = {
				name = "mantequilla",
				asset = assetPath .. "fat/g_mantequilla.png",
				description = {
					[1] = "1 cucharadita mantequilla",
				},
			},
		},
	},
	["dryfruit"] = { -- "Semillas"
		asset = assetPath .. "dryfruit/base.png",
		name = "Semillas",
		food = {
			[1] = {
				name = "almendra",
				asset = assetPath .. "dryfruit/fs_almendra.png",
				description = {
					[1] = "10 almendras",
				},
			},
			[2] = {
				name = "nuez",
				asset = assetPath .. "dryfruit/fs_nuez.png",
				description = {
					[1] = "6 nueces en mitades",
					[2] = "7 nueces de la india,",
				},
			},
		},
	},
	["sugar"] = { -- "Azucares"
		asset = assetPath .. "sugar/base.png",
		name = "Azucar",
		food = {
			[1] = {
				name = "cajeta",
				asset = assetPath .. "sugar/a_cajeta.png",
				description = {
					[1] = "1 cucharadita de cajeta",
				},
			},
			[2] = {
				name = "gelatina",
				asset = assetPath .. "sugar/a_gelatina.png",
				description = {
					[1] = "1/3 taza gelatina",
				},
			}
		},
	}
	
}

return foodData