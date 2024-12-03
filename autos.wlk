import wollok.game.*
import nivel.*
import player.*

class Auto{
	var property position = new Position(x = 7, y = 5)
	var direccion = ["I","C","D"].anyOne()
	const autoChocado = new AutoChocado()

	method initialize(){
	   game.onTick(1000, "velocidad", {self.desplazarse()})
	}

	method desplazarse(){
		if(!self.hayEncuentro()) {
			self.position(position.down(1))
			if (direccion == "I"){
				self.position(position.left(1))
			   }
			   
               if(direccion == "D"){
				self.position(position.right(1))
			   }
			}

        if (self.llegue()) {
			//nivel.borrarElemento(self)
			game.schedule(1000, {game.removeVisual(self)})
			game.schedule(2000, {self.reinicio() })
		}
		
	}

	method reinicio(){
		direccion = ["I","C","D"].anyOne()
		//self.position(position.up(arriba))
		position = game.center()
		game.addVisual(self)
		//nivel.agregoElemento(self)
	}
	method hayEncuentro() = self.position() == player.position()
	method llegue() = position.y() == 0

	method image()

	method serImpactado(unAuto) {	}

	method colisionar(){
		//player.serImpactado(self)
		const pos = self.position()
		//const autoChocado = new AutoChocado(position = pos) 
		autoChocado.position(pos)
		//nivel.borrarElemento(self)
		game.removeVisual(self)
		self.actualizarAuto(autoChocado)
        game.schedule(2000, {self.reinicio()})
	}
	method actualizarAuto(unAutoChocado){
		game.addVisual(unAutoChocado)
		//nivel.mostrarAutoChocado(unAutoChocado)
		game.schedule(500,{game.removeVisual(unAutoChocado)})
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
	override method desplazarse(){}
}
