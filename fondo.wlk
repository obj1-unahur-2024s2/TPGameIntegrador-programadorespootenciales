import wollok.game.*

class Cesped {
	var property position
	
	method dibujar() {
		game.addVisual(self)
	}

	method image() = "ground.png"
}

class Camino_izquierdo {
	var property position
	
	method dibujar() {
		game.addVisual(self)
	}

	method image() = "ruta_izq.png"
}

class Camino_liso {
	var property position
	
	method dibujar() {
		game.addVisual(self)
	}

	method image() = "ruta_liso.png"
}

class Camino_derecho {
	var property position
	
	method dibujar() {
		game.addVisual(self)
	}

	method image() = "ruta_der.png"
}