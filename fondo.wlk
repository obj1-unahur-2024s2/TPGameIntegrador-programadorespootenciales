import wollok.game.*

class Fondo{
	var property position
	
	method dibujar() {
		game.addVisual(self)
	}

	method serImpactado(unAuto) {}
}
class Cesped inherits Fondo {
	method image() = "ground.png"
}

class Camino_izquierdo inherits Fondo {
	method image() = "ruta_izq.png"
}

class Camino_liso inherits Fondo {
	method image() = "ruta_liso.png"
}

class Camino_derecho inherits Fondo {
	method image() = "ruta_der.png"
}