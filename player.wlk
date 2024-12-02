import wollok.game.*
import nivel.*

object player {
	var image = "autoPlayer.png"
	var position = new Position(x = 7, y = 1)
	var velocidad = 20
	var combustible = 1
	var estado = 100
	var autosQueChoco = 0
	
	method velocidad() = velocidad
	method combustible() = combustible
	method combustible(unCombustible) {combustible = unCombustible}
	method estado() = estado

	method gastaCombustible() {
		combustible = 0.max(combustible - 1)
	}
	method combustibleEnCero() = combustible == 0
	
	method image() = image
	method cambiarImagen(imagenNueva){ image  = imagenNueva }

	method acelerar() {
		velocidad = (95 * estado /100).min(velocidad + 5)
	}

	method frenar() {
		velocidad = 0.max(velocidad - 5)
	}

	method izquierda(){
		position = self.position().left(1)
		game.schedule(200, {position = self.position().left(1)})
		game.schedule(200, {position = self.position().left(1)})
        game.schedule(200, {position = self.position().left(1) self.cambiarImagen("autoPlayer.png")})
	}

	method derecha(){
		position = self.position().right(1)
		game.schedule(200, {position = self.position().right(1)})
		game.schedule(200, {position = self.position().right(1)})
        game.schedule(200, {position = self.position().right(1) self.cambiarImagen("autoPlayer.png")})
	}

	method position() = position
    method position(unaPosicion){}
	method colisiones() = autosQueChoco
	method contarColisiones() {autosQueChoco = autosQueChoco + 1}

	method serImpactado(unAuto) {
		self.contarColisiones()
		self.detenerse()
		estado = 0.max(estado - 10)
		self.actualizaEstado()
		unAuto.colisionar()
		game.schedule(1000, {self.vuelvoOrigen()})

	}
	method detenerse(){velocidad = 0}
	method vuelvoOrigen() {
		position = game.at(7,1)
	}

	method configurarFlechas(){
		keyboard.up().onPressDo {
			self.acelerar()
		}
		
		keyboard.down().onPressDo { 
			self.frenar()
		}

		keyboard.left().onPressDo{
			self.mover(izquierda)
            
		}
		keyboard.right().onPressDo{ 
			self.mover(derecha)
		}
   }

	method mover(direccion){
		const nuevaPosicion = direccion.siguiente(self.position())
		if (nuevaPosicion.x() < self.position().x() && nuevaPosicion.x() >= 1) {
		   self.cambiarImagen("autoPlayerIzq.png")
           self.izquierda()
		}
		if (nuevaPosicion.x() > self.position().x() && nuevaPosicion.x() <= 13) {
		   self.cambiarImagen("autoPlayerDer.png")
           self.derecha()
		}
	}

	method actualizaEstado(){estado = 0.max(estado - 10)}
}

object izquierda { 
	method siguiente(position) = position.left(4)
}

object derecha { 
	method siguiente(position) = position.right(4) 
}

