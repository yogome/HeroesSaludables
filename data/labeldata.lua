local assetPath = "images/label/"
local labeldata = {
	
	[1] = {
		name = "Leche sabor chocolate",
		iconAsset = assetPath.."icons/1.png",
		labelBG = assetPath .. "panels/lechechoco.png",
		labelOperation = assetPath .. "operationPanels/lechechoco.png",
		operationInfo = {
			toCalculate = "Contenido energético",
			portions = 1,
			energetic = 121,
			units = "kcal"
		},
		
		operationData = {
			questions = {
				[1] = {
					text = "¿Cuántas porciones por paquete tiene la lechita sabor chocolate?",
					answerId = 1,
					answers = {
						[1] = 1,
						[2] = 110,
						[3] = 236,
					},
				},
				[2] = {
					text = "¿Cuántas Kcal se muestran en el contenido energético?",
					answerId = 1,
					answers = {
						[1] = 110,
						[2] = 121,
						[3] = 139.5,
					},
				},
				[3] = {
					text = "Calcula el total de las kcal de la lechita sabor chocolate",
					answerId = 3,
					answers = {
						[1] = 13,
						[2] = 139,
						[3] = 121,
					},
				},
			}
		},
		
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
					[1] = {x = 1, y = -8.75},	
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
		labelOperation = assetPath .. "operationPanels/leche.png",
		
		operationInfo = {
			toCalculate = "Contenido energético",
			portions = 1,
			energetic = 124,
			units = "kcal"
		},
		
		operationData = {
			questions = {
				[1] = {
					text = "¿Cuántas porciones por tiene la leche natural?",
					answerId = 1,
					answers = {
						[1] = 1,
						[2] = 250,
						[3] = 236,
					},
				},
				[2] = {
					text = "¿Cuántas Kcal se muestran en el contenido energético?",
					answerId = 2,
					answers = {
						[1] = 110,
						[2] = 124,
						[3] = 139.5,
					},
				},
				[3] = {
					text = "Calcula el total de las kcal de la lechita Natural",
					answerId = 3,
					answers = {
						[1] = 13,
						[2] = 139,
						[3] = 124,
					},
				},
			}
		},
		
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
		labelOperation = assetPath .. "operationPanels/yogurt.png",
		
		operationInfo = {
			toCalculate = "Contenido energético",
			portions = 1,
			energetic = 68,
			units = "kcal"
		},
		
		operationData = {
			questions = {
				[1] = {
					text = "¿Cuántas porciones por paquete tiene el yogurt sabor fresa?",
					answerId = 1,
					answers = {
						[1] = 1,
						[2] = 250,
						[3] = 236,
					},
				},
				[2] = {
					text = "¿Cuántas Kcal se muestran en el contenido energético?",
					answerId = 2,
					answers = {
						[1] = 110,
						[2] = 68,
						[3] = 139.5,
					},
				},
				[3] = {
					text = "Calcula el total de las kcal del yogurt sabor fresa",
					answerId = 3,
					answers = {
						[1] = 13,
						[2] = 139,
						[3] = 68,
					},
				},
			}
		},
		
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
		labelOperation = assetPath .. "operationPanels/jugonatural.png",
		
		operationInfo = {
			toCalculate = "Contenido energético",
			portions = 1.75,
			energetic = 39.84,
			units = "kcal"
		},
		
		operationData = {
			questions = {
				[1] = {
					text = "¿Cuántas porciones por paquete tiene el jugo natural?",
					answerId = 1,
					answers = {
						[1] = 1.75,
						[2] = 1,
						[3] = 100,
					},
				},
				[2] = {
					text = "¿Cuántas Kcal se muestran en el contenido energético?",
					answerId = 2,
					answers = {
						[1] = 110,
						[2] = 39.84,
						[3] = 139.5,
					},
				},
				[3] = {
					text = "Calcula el total de las kcal del jugo natural",
					answerId = 3,
					answers = {
						[1] = 13,
						[2] = 139,
						[3] = 69.72,
					},
				},
			}
		},
		
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
		labelOperation = assetPath .. "operationPanels/queso.png",
		
		operationInfo = {
			toCalculate = "Contenido energético",
			portions = 1.6,
			energetic = 162,
			units = "kcal"
		},
		
		operationData = {
			questions = {
				[1] = {
					text = "¿Cuántas porciones por paquete tienen las frituras de queso?",
					answerId = 1,
					answers = {
						[1] = 1.6,
						[2] = 1,
						[3] = 100,
					},
				},
				[2] = {
					text = "¿Cuántas Kcal se muestran en el contenido energético?",
					answerId = 2,
					answers = {
						[1] = 110,
						[2] = 162,
						[3] = 139.5,
					},
				},
				[3] = {
					text = "Calcula el total de las kcal de las frituras de queso",
					answerId = 3,
					answers = {
						[1] = 13,
						[2] = 139,
						[3] = 259.2,
					},
				},
			}
		},
		
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
		labelOperation = assetPath .. "operationPanels/jugomanzana.png",
		
		operationInfo = {
			toCalculate = "Sodio",
			portions = 1.25,
			energetic = 14,
			units = "mg"
		},
		
		operationData = {
			questions = {
				[1] = {
					text = "¿Cuántas porciones por paquete tiene el jugo de manzana?",
					answerId = 1,
					answers = {
						[1] = 1.25,
						[2] = 9,
						[3] = 2,
					},
				},
				[2] = {
					text = "¿Cuánto sodio se muestra en la etiqueta nutrimental?",
					answerId = 2,
					answers = {
						[1] = 110,
						[2] = 14,
						[3] = 139.5,
					},
				},
				[3] = {
					text = "Calcula el total de sodio que contiene el jugo de manzana",
					answerId = 3,
					answers = {
						[1] = 45,
						[2] = 14,
						[3] = 17.5,
					},
				},
			}
		},
		
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
		labelOperation = assetPath .. "operationPanels/pastelchoco.png",
		
		operationInfo = {
			toCalculate = "Contenido energético",
			portions = 1,
			energetic = 200,
			units = "kcal"
		},
		
		operationData = {
			questions = {
				[1] = {
					text = "¿Cuántas porciones por paquete tiene el pastelito de chocolate?",
					answerId = 1,
					answers = {
						[1] = 1,
						[2] = 5,
						[3] = 8,
					},
				},
				[2] = {
					text = "¿Cuántas Kcal se muestran en el contenido energético?",
					answerId = 2,
					answers = {
						[1] = 823,
						[2] = 200,
						[3] = 400,
					},
				},
				[3] = {
					text = "Calcula el total de las kcal del pastelito con chocolate",
					answerId = 3,
					answers = {
						[1] = 13,
						[2] = 139,
						[3] = 200,
					},
				},
			}
		},
		
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
		labelOperation = assetPath .. "operationPanels/cereal.png",
		
		operationInfo = {
			toCalculate = "Contenido energético",
			portions = 1,
			energetic = 110,
			units = "kcal"
		},
		
		operationData = {
			questions = {
				[1] = {
					text = "¿Cuántas porciones por paquete tiene el cereal?",
					answerId = 1,
					answers = {
						[1] = 1,
						[2] = 5,
						[3] = 8,
					},
				},
				[2] = {
					text = "¿Cuántas Kcal se muestran en el contenido energético?",
					answerId = 2,
					answers = {
						[1] = 480,
						[2] = 110,
						[3] = 230,
					},
				},
				[3] = {
					text = "Calcula el total de las kcal del cereal",
					answerId = 3,
					answers = {
						[1] = 1,
						[2] = 154,
						[3] = 110,
					},
				},
			}
		},
		
		description = "En muchos de los cereales para niños, el azúcar representa más de un tercio de su peso. Consume con moderación los cereales para niños pues el azúcar normalmente sobrepasa las recomendaciones diarias.",
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
		labelOperation = assetPath .. "operationPanels/chocochispas.png",
		labelBG = assetPath .. "panels/chocochispas.png",
		operationInfo = {
			toCalculate = "Contenido energético",
			portions = 2,
			energetic = 134,
			units = "kcal"
		},
		
		operationData = {
			questions = {
				[1] = {
					text = "¿Cuántas porciones por paquete tienen las galletas?",
					answerId = 1,
					answers = {
						[1] = 2,
						[2] = 5,
						[3] = 8,
					},
				},
				[2] = {
					text = "¿Cuántas Kcal se muestran en el contenido energético?",
					answerId = 2,
					answers = {
						[1] = 263,
						[2] = 134,
						[3] = 230,
					},
				},
				[3] = {
					text = "Calcula el total de las kcal de las galletas",
					answerId = 3,
					answers = {
						[1] = 1,
						[2] = 154,
						[3] = 268,
					},
				},
			}
		},
		
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
		labelOperation = assetPath .. "operationPanels/refresco.png",
		
		operationInfo = {
			toCalculate = "Sodio",
			portions = 2,
			energetic = 47,
			units = "mg"
		},
		
		operationData = {
			questions = {
				[1] = {
					text = "¿Cuántas porciones por paquete tiene el refresco de cola?",
					answerId = 1,
					answers = {
						[1] = 2,
						[2] = 5,
						[3] = 8,
					},
				},
				[2] = {
					text = "¿Cuánto sodio se muestran en la etiqueta del refresco de cola?",
					answerId = 2,
					answers = {
						[1] = 200,
						[2] = 47,
						[3] = 408,
					},
				},
				[3] = {
					text = "Calcula el total de sodio que contiene el refresco de cola",
					answerId = 3,
					answers = {
						[1] = 96,
						[2] = 408,
						[3] = 47,
					},
				},
			}
		},
		
		description = "Recuerda que los refrescos aportan kilocalorias y no tienen ningún otro valor nutritivo.Los refrescos bajos en calorías, light o diet, en lugar de azúcares naturales contienen azúcares artificiales.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece1.png"
				},
				answers = {
					[1] = {x = 1, y = -196.55},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece2.png"
				},
				answers = {
					[1] = {x = 1, y = -131.75},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece3.png"
				},
				answers = {
					[1] = {x = 1, y = 4.05},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece4.png"
				},
				answers = {
					[1] = {x = 1, y = 74.80},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece5.png"
				},
				answers = {
					[1] = {x = 1, y = 220.50},	
				},
			},
		}
	},
}

return labeldata