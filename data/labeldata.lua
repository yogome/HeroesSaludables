local assetPath = "images/label/"
local labeldata = {
	
	[1] = {
		name = "Leche sabor chocolate",
		iconAsset = assetPath.."icons/1.png",
		labelBG = assetPath .. "panels/lecheconchocolate.png",
		description = "Las leches saborizadas agregan azúcar, saborizantes y colorantes artificiales. Prefiere consumir leche natural descremada.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/chocoleche/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -206.55},	
				}
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/chocoleche/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -141.75},	
				}
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/chocoleche/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = -141.75},	
				}
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/chocoleche/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 56.70},	
				}
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/chocoleche/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 210.60},	
				}
			},
		}
	},
	[2] = {
		name = "Leche Natural",
		iconAsset = assetPath.."icons/2.png",
		labelBG = assetPath .. "panels/lechenatural.png",
		description = "La leche contiene calcio y vitamina D, necesarios para la formación de huesos y dientes.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/lechenatural/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -182.25},	
				}
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/lechenatural/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -117.45},	
				}
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/lechenatural/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = 16.20},	
				}
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/lechenatural/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 81.00},	
				}
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/lechenatural/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 214.65},	
				}
			},
		}
	},
	[3] = {
		name = "Queso petit suisse",
		iconAsset = assetPath.."icons/3.png",
		labelBG = assetPath .. "panels/yogurt.png",
		description = "Consume con moderación los productos estilo Queso Petit Suisse ya que pueden contener mucho más de lo suficiente de azúcares y grasas.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/yogurt/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -198.45},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/yogurt/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -133.65},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/yogurt/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = 0},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/yogurt/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 68.85},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/yogurt/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 214.65},	
				},
			},
		}
	},
	[4] = {
		name = "Jugo Natural",
		iconAsset = assetPath.."icons/4.png",
		labelBG = assetPath .. "panels/jugonatural.png",
		description = "Si quieres tener un buen día tienes que tomar un jugo 100% natural. Procura comer fruta también y no solamente en jugos.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/jugonatural/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -198.45},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/jugonatural/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -137.70},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/jugonatural/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = 0},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/jugonatural/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 68.85},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/jugonatural/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 214.65},	
				},
			},
		}
	},
	[5] = {
		name = "Frituras de Queso",
		iconAsset = assetPath.."icons/5.png",
		labelBG = assetPath .. "panels/queso.png",
		description = "Grasas y sodio los encontramos fácilmente en las botanas. Consume botanas con moderación y procura que no sean la base de ningún tiempo de comida en tu dieta.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/friturasdequeso/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -206.55},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/friturasdequeso/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -141.75},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/friturasdequeso/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = -8.10},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/friturasdequeso/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 60.75},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/friturasdequeso/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 218.70},	
				},
			},
		}
	},
	[6] = {
		name = "Jugo de Manzana",
		iconAsset = assetPath.."icons/6.png",
		labelBG = assetPath .. "panels/jugomanzana.png",
		description = "Para la hora del lunch, el agua natural es la opción más recomendable, en segundo lugar la leche descremada, y como las menos recomendables los refrescos y bebidas azucaradas, como jugos, néctares que tienen “azúcar adicionada”.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/jugodemanzana/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -202.50},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/jugodemanzana/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -137.70},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/jugodemanzana/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = 0},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/jugodemanzana/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 68.85},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/jugodemanzana/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 218.70},	
				},
			},
		}
	},
	[7] = {
		name = "Pastelito de chocolate",
		iconAsset = assetPath.."icons/7.png",
		labelBG = assetPath .. "panels/pastelillochocolate.png",
		description = "Acuerdate de consumir con moderación los pastelitos de cualquier tipo. Pueden contener mucha azúcar añadida, grasas y también sodio.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/pastelchocolate/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -210.60},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/pastelchocolate/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -145.80},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/pastelchocolate/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = -4.05},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/pastelchocolate/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 64.80},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/pastelchocolate/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 218.70},	
				},
			},
		}
	},
	[8] = {
		name = "Cereal Azucarado",
		iconAsset = assetPath.."icons/8.png",
		labelBG = assetPath .. "panels/cerealazucarado.png",
		description = "En muchos de los cereales para niños, el azúcar representa más de un tercio de su peso. Consume con moderación los cereales para niños pues el azúcar normalmente sobrepasa las recomendaciones diarias.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/cerealazucarado/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -190.35},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/cerealazucarado/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -125.55},	
				},
			},
			[3] ={	
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/cerealazucarado/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = 8.10},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/cerealazucarado/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 76.95},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/cerealazucarado/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 214.65},	
				},
			},
		}
	},
	[9] = {
		name = "Galletas con chispas",
		iconAsset = assetPath.."icons/9.png",
		labelBG = assetPath .. "panels/chocochispas.png",
		description = "Se tiene la idea errónea de que los productos light adelgazan, o “que no engordan prácticamente nada”. Con esa creencia se consumen en exceso y se consumen en mayor cantidad que los productos convencionales.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/chocochispas/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -206.55},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/chocochispas/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -141.75},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/chocochispas/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = -4.05},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/chocochispas/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 60.75},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/chocochispas/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 214.65},	
				},
			},
		}
	},
	[10] = {
		name = "Refresco de cola",
		iconAsset = assetPath.."icons/10.png",
		labelBG = assetPath .. "panels/latarefresco.png",
		description = "Recuerda que los refrescos aportan kilocalorias y no tienen ningún otro valor nutritivo.Los refrescos bajos en calorías, light o diet, en lugar de azúcares naturales contienen azúcares artificiales.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -206.55},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -141.75},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = -4.05},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 64.80},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 202.50},	
				},
			},
		}
	},
}

return labeldata