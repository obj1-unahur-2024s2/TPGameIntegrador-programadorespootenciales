import wollok.game.*
import nivel.*
import player.*

class Auto{
	var property position = new Position(x = [4,7,10].anyOne(), y = 9)

	method inicioMovimiento(){
	   game.onTick(300, "velocidad", {self.desplazarse()})
	}

	method desplazarse(){
		const nuevaPosicion = position.down(1) 
		if (nuevaPosicion.y() >= 0 && nuevaPosicion.y() < game.height() - 1)
		self.position(nuevaPosicion)
		
        if (nuevaPosicion.y() == 0) {
			nivel.borrarElemento(self)
			game.schedule(1000, {game.removeVisual(self)})
		}
		game.onCollideDo(self, {elemento => elemento.serImpactado(self)})
		
	}

	method image()
}
class Auto1 inherits Auto {
	override method image() = "player.png"
}

class Auto2 inherits Auto {
	override method image() = "autosRojoConPersonajesSinFondoArriba.png"
}

object abajo { 
	method siguiente(position) = position.down(1) 
}

object arriba { 
	method siguiente(position) = position.up(1) 
}