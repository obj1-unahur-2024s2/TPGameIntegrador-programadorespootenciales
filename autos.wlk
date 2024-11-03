import wollok.game.*
import nivel.*
import player.*

class Auto{
	var property position = new Position(x = [4,7,10].anyOne(), y = 9)

	method initialize(){
	   game.onTick(player.velocidadRelativa(), "velocidad", {self.desplazarse()})
	}

	method desplazarse(){
		self.position(position.down(1))

        if (self.llegue()) {
			nivel.borrarElemento(self)
			game.schedule(1000, {game.removeVisual(self)})
		}
		game.onCollideDo(self, {elemento => elemento.serImpactado(self)})
		
	}

	method llegue() = position.y() == 0

	method image()
}
class Auto1 inherits Auto {
	override method image() = "auto1.png"
}

class Auto2 inherits Auto {
	override method image() = "auto2.png"
}

class Auto3 inherits Auto {
	override method image() = "auto3.png"
}

class Auto4 inherits Auto {
	override method image() = "auto4.png"
}
