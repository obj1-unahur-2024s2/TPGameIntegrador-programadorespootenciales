import wollok.game.*
import nivel.*

object player {
	var image = "autoPlayer.png"
	var position = new Position(x = 7, y = 1)
	var velocidad = 20
	var combustible = 40
	var estado = 100
	var autosQueChoco = 0
	
	method velocidad() = velocidad
	method combustible() = combustible
	method combustible(unCombustible) {combustible = unCombustible}
	method estado() = estado
	method initialize(){
		game.onTick(1000, "tiempo", {self.gastaCombustible() self.validarEstado()})
	}
	method gastaCombustible() {
		combustible = 0.max(combustible - 1)
		self.combustibleEnCero()
	}
	method combustibleEnCero() { if (combustible == 0) {nivel.resultado(mensajePerdiste) nivel.finNivel()}}
	method llegasteALaMeta() {if(nivel.distancia() == 0) {nivel.resultado(mensajeGanaste) nivel.finNivel()}}
	method velocidadRelativa() = 10.min(300 - (velocidad * 0.5))

	method image() = image
	method cambiarImagen(imagenNueva){ image  = imagenNueva }

	method acelerar() {
		velocidad = (95 * estado /100).min(velocidad + 5)
		game.onTick(1000, "aceleracion", { nivel.actualizoVelocidades(self.velocidadRelativa())})
	}

	method frenar() {
		velocidad = 0.max(velocidad - 5)
		game.onTick(1000, "desaceleracion", { nivel.actualizoVelocidades(self.velocidadRelativa())})
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
	method colisiones() = autosQueChoco
	method contarColisiones() {autosQueChoco = autosQueChoco + 1}
	method chocar(auto){
		game.onCollideDo(self, { auto => self.serImpactado(auto) })
	}
	method serImpactado(unAuto) {
		self.contarColisiones()
		self.detenerse()
		estado = 0.max(estado - 10)
		self.actualizaEstado()
		nivel.actualizoVelocidades(self.velocidadRelativa())
		game.schedule(500, {self.vuelvoOrigen()})

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

	method validarEstado(){
		if (self.position().x() < 4 or self.position().x() > 10){
			estado = 0.max(estado - 1)
		}
		self.estadoEsCero()
	}
	method estadoEsCero() = if (estado == 0) {nivel.resultado(mensajePerdiste) nivel.finNivel()}
	method actualizaEstado(){estado = 0.max(estado - 10)}
}

object izquierda { 
	method siguiente(position) = position.left(3)
}

object derecha { 
	method siguiente(position) = position.right(3) 
}

