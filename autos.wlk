import wollok.game.*
import nivel.*
import player.*

class Auto{
	var property position = new Position(x = [4,7,10].anyOne(), y = 9)

	method initialize(){
	   game.onTick(player.velocidadRelativa(), "velocidad", {self.desplazarse()})
	}

	method cambioVelocidad(unaVelocidad){
		game.removeTickEvent("velocidad")
		game.onTick(unaVelocidad, "velocidad", {self.desplazarse()})
	}

	method desplazarse(){
		if(!self.hayEncuentro()) self.position(position.down(1)) else 
		//game.onCollideDo(self, {elemento => elemento.serImpactado(self)})
		game.onCollideDo(self, { player => self.serImpactado(self) });
        if (self.llegue()) {
			nivel.borrarElemento(self)
			game.schedule(1000, {game.removeVisual(self)})
		}
		
	}
	method hayEncuentro() = self.position() == player.position()
	method llegue() = position.y() == 0

	method image()

	method serImpactado(unAuto) {
		game.say(unAuto,"Cuidado gil !!")
		const pos = unAuto.position()
		const autoChocado = new AutoChocado(position = pos) 
		nivel.borrarElemento(unAuto)
		game.removeVisual(unAuto)
		self.actualizarAuto(autoChocado)

	}
	method actualizarAuto(unAutoChocado){
		nivel.mostrarAutoChocado(unAutoChocado)
	}
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
class AutoChocado inherits Auto {
	override method image() = "unAutoConHumo.png"
	override method desplazarse(){game.removeVisual(self)}
}
