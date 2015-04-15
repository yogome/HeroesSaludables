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
					[1] = {x = display.contentWidth * 0.18915642632378,y = display.contentHeight * 0.22432100272473},	
				}
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/chocoleche/piece2.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.1887444390191,y = display.contentHeight * 0.31444445951485},	
				}
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/chocoleche/piece3.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.1881746645327,y = display.contentHeight * 0.48851853358893},	
				}
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/chocoleche/piece4.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18830317744502,y = display.contentHeight * 0.57864199037905},	
				}
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/chocoleche/piece5.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18847582781756,y = display.contentHeight * 0.78358026198399},	
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
					[1] = {x = display.contentWidth * 0.18994236698857,y = display.contentHeight * 0.24901236074942},	
				}
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/lechenatural/piece2.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18979469581887,y = display.contentHeight * 0.33913581753954},	
				}
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/lechenatural/piece3.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18891494185836,y = display.contentHeight * 0.51197532371238},	
				}
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/lechenatural/piece4.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18871047408492,y = display.contentHeight * 0.60333334840374},	
				}
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/lechenatural/piece5.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18902452256944,y = display.contentHeight * 0.77123458297164},	
				}
			},
		}
	},
	[3] = {
		name = "Yogurt",
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
					[1] = {x = display.contentWidth * 0.19035135904948,y = display.contentHeight * 0.24037038544078},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/yogurt/piece2.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19001493100767,y = display.contentHeight * 0.3267901385272},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/yogurt/piece3.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19224616156684,y = display.contentHeight * 0.50209878050251},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/yogurt/piece4.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19071677879051,y = display.contentHeight * 0.58851853358893},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/yogurt/piece5.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19089638038918,y = display.contentHeight * 0.77740742247782},	
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
					[1] = {x = display.contentWidth * 0.19014553493924,y = display.contentHeight * 0.23543211383584},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/jugonatural/piece2.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19002295600043,y = display.contentHeight * 0.32432100272473},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/jugonatural/piece3.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18992518672237,y = display.contentHeight * 0.50086421260127},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/jugonatural/piece4.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18821394178602,y = display.contentHeight * 0.58728396568769},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/jugonatural/piece5.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18823581271701,y = display.contentHeight * 0.77370371877411},	
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
					[1] = {x = display.contentWidth * 0.18831617567274,y = display.contentHeight * 0.2304938422309},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/friturasdequeso/piece2.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18902452256944,y = display.contentHeight * 0.31691359531732},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/friturasdequeso/piece3.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18995010941117,y = display.contentHeight * 0.49345680519387},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/friturasdequeso/piece4.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18840343334057,y = display.contentHeight * 0.57864199037905},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/friturasdequeso/piece5.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18912455240885,y = display.contentHeight * 0.77370371877411},	
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
					[1] = {x = display.contentWidth * 0.19132085729528,y = display.contentHeight * 0.23666668173708},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/jugodemanzana/piece2.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19163151493779,y = display.contentHeight * 0.3230864348235},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/jugodemanzana/piece3.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19186028374566,y = display.contentHeight * 0.50086421260127},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/jugodemanzana/piece4.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18972834834346,y = display.contentHeight * 0.58604939778646},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/jugodemanzana/piece5.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18944634331597,y = display.contentHeight * 0.77246915087288},	
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
					[1] = {x = display.contentWidth * 0.19036560058594,y = display.contentHeight * 0.2304938422309},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/pastelchocolate/piece2.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18967545120804,y = display.contentHeight * 0.31814816321856},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/pastelchocolate/piece3.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19113181785301,y = display.contentHeight * 0.4946913730951},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/pastelchocolate/piece4.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18931127477575,y = display.contentHeight * 0.58111112618152},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/pastelchocolate/piece5.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18948516845703,y = display.contentHeight * 0.77864199037905},	
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
					[1] = {x = display.contentWidth * 0.18947640878183,y = display.contentHeight * 0.24777779284819},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/cerealazucarado/piece2.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18960136131004,y = display.contentHeight * 0.33543211383584},	
				},
			},
			[3] ={	
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/cerealazucarado/piece3.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19143394187645,y = display.contentHeight * 0.51197532371238},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/cerealazucarado/piece4.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.1902749520761,y = display.contentHeight * 0.5983950767988},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/cerealazucarado/piece5.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19008133499711,y = display.contentHeight * 0.77617285457658},	
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
					[1] = {x = display.contentWidth * 0.19097284387659,y = display.contentHeight * 0.23419754593461},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/chocochispas/piece2.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19098160355179,y = display.contentHeight * 0.32061729902103},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/chocochispas/piece3.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19190233018663,y = display.contentHeight * 0.4983950767988},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/chocochispas/piece4.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18958135534216,y = display.contentHeight * 0.58481482988522},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/chocochispas/piece5.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.18942667643229,y = display.contentHeight * 0.78234569408275},	
				},
			},
		}
	},
	[10] = {
		name = "Refresco de cola",
		iconAsset = assetPath.."icons/10.png",
		labelBG = assetPath .. "panels/chocochispas.png",
		description = "Recuerda que los refrescos aportan kilocalorias y no tienen ningún otro valor nutritivo.Los refrescos bajos en calorías, light o diet, en lugar de azúcares naturales contienen azúcares artificiales.",
		pieces = {
			[1] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece1.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19030654342086,y = display.contentHeight * 0.22802470642843},	
				},
			},
			[2] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece2.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.1896413732458,y = display.contentHeight * 0.31567902741609},	
				},
			},
			[3] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece3.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.1905756632487,y = display.contentHeight * 0.49345680519387},	
				},
			},
			[4] ={
				type = "big",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece4.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19012168601707,y = display.contentHeight * 0.57864199037905},	
				},
			},
			[5] ={
				type = "small",
				assets = {
					[1] = assetPath.."pieces/phase1/refrescodecola/piece5.png"
				},
				answers = {
					[1] = {x = display.contentWidth * 0.19070999710648,y = display.contentHeight * 0.75641976815683},	
				},
			},
		}
	},
}

return labeldata