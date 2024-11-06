import wollok.game.*
import player.*
import autos.*

object juego {
	method iniciar(){		
		game.title("Autos")
		game.height(10)
		game.width(15)
		player.configurarFlechas()
		keyboard.space().onPressDo({game.stop() game.addVisual(mensajeFin)})
		game.boardGround("fondo.png")
		game.addVisual(inicio)
		keyboard.enter().onPressDo({game.removeVisual(inicio) nivel.configurate()})
		game.start()
	}	
}
object nivel {
   var distanciaNivel = 5000
   const velocidadNivel = 2000
   const elementos = []

   method agregoElemento(unElemento) {
	elementos.add(unElemento)
	game.addVisual(unElemento)
   }

   method borrarElemento(unElemento) {
	elementos.remove(unElemento)
   }

   method configurate(){
		const ancho = game.width() 
		const largo = game.height()
	
    //	VISUALES
	    game.addVisualCharacter(player)
		game.addVisual(new ScoreVelocidad())
		game.addVisual(new ScoreDistancia())
		game.addVisual(new ScoreCombustible())
		game.addVisual(new ScoreEstado())

        game.onTick(velocidadNivel, "agrego", {self.agregoElemento([new Auto1(), new Auto2(), new Auto3(), new Auto4()].anyOne())})

		game.onTick(1000, "tiempo", {
			distanciaNivel = 0.max(distanciaNivel - player.velocidad())
			if (distanciaNivel ==0){
				game.addVisual(mensajeGanaste)
				game.stop()
			}
		})

	}

	method distancia() = distanciaNivel

	method perdiste(){
	    game.addVisual(mensajePerdiste)
		game.stop()
    }

	method actualizoVelocidades(unaVelocidad){
		elementos.forEach({auto => auto.cambioVelocidad(unaVelocidad)})
	}
}

class Score{
	method textColor() = "FFFFFFFF"
	method text()
}
class ScoreVelocidad inherits Score{
	method position() = game.at(13,9)
	override method text() = "VELOCIDAD: " + player.velocidad().toString()
}

class ScoreDistancia inherits Score{
	method position() = game.at(13,8)
	override method text() = "DISTANCIA: " + nivel.distancia().toString()
}

class ScoreCombustible inherits Score{
	method position() = game.at(13,7)
	override method text() = "COMBUSTIBLE: " + player.combustible().toString()
}

class ScoreEstado inherits Score{
	method position() = game.at(13,6)
	override method text() = "ESTADO: " + player.estado().toString()
}

class Mensaje{
   method textColor() = "0000FFFF"
   method position() = game.center()
   method text()
   method serImpactado(unAuto) {}
}
object mensajePerdiste inherits Mensaje{
	override method text() = "LO SIENTO!! VOLVÉ A INTENTARLO"
}

object mensajeGanaste inherits Mensaje{
	override method text() = "FELICITACIONES!! SUPERASTE EL NIVEL"
}

object mensajeFin inherits Mensaje{
	override method text() = "JUEGO FINALIZADO"
}

object inicio {
	var image = "presentacion.png"
	var position = game.origin()
	method position() = position
	method image() = image
}

