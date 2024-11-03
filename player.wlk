import wollok.game.*

object player {
	var image = "autoPlayer.png"
	var position = new Position(x = 7, y = 1)
	var velocidad = 20
	var combustible = 40
	var estado = 100
	
	method velocidad() = velocidad
	method combustible() = combustible
	method estado() = estado
	method initialize(){
		game.onTick(1000, "tiempo", {self.gastaCombustible() self.validarEstado()})
	}
	method gastaCombustible() {
		combustible = 0.max(combustible - 1)
		if (combustible == 0) {
          game.addVisual(nivel.mensajePerdiste)
		  game.stop()
		}
	}
	method velocidadRelativa() = 300 - (velocidad/2)

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
        game.schedule(200, {position = self.position().left(1) self.cambiarImagen("autoPlayer.png")})
	}

	method derecha(){
		position = self.position().right(1)
		game.schedule(200, {position = self.position().right(1)})
        game.schedule(200, {position = self.position().right(1) self.cambiarImagen("autoPlayer.png")})
	}

	method position() = position
    method position(unaPosicion){}

	method serImpactado(unAuto) {
		velocidad = 0
		game.say(unAuto,"Cuidado gil !!")
		estado = 0.max(estado - 10)
		
		game.schedule(1000, {game.removeVisual(unAuto) self.vuelvoOrigen()})
	}

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

	method validarEstado(){
		if (self.position().x() < 4 or self.position().x() > 10){
			estado = 0.max(estado -1)
			if (estado == 0) {
              game.addVisual(nivel.mensajePerdiste)
		      game.stop()
		    }
		}
	}
}

object izquierda { 
	method siguiente(position) = position.left(3)
}

object derecha { 
	method siguiente(position) = position.right(3) 
}

