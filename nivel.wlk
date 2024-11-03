import wollok.game.*
import player.*
import autos.*

object juego {
	method iniciar(){		
		game.title("Autos")
		game.height(10)
		game.width(15)
		//game.boardGround("presentacion.png")
		player.configurarFlechas()
		nivel.configurate()
		keyboard.space().onPressDo({game.stop() game.addVisual(mensajeFin)})
		game.boardGround("fondo.png")
		game.start()
		//keyboard.enter().onPressDo({game.boardGround("fondo.png") nivel.configurate() game.start() })
	}	
}
object nivel {
   var distanciaNivel = 500
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
		game.addVisual(scoreVelocidad)
		game.addVisual(scoreDistancia)
		game.addVisual(scoreCombustible)
		game.addVisual(scoreEstado)

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
}

object scoreVelocidad{
	method position() = game.at(13,9)
	method text() = "VELOCIDAD: " + player.velocidad().toString()
}

object scoreDistancia{
	method position() = game.at(13,8)
	method text() = "DISTANCIA: " + nivel.distancia().toString()
}

object scoreCombustible{
	method position() = game.at(13,7)
	method text() = "COMBUSTIBLE: " + player.combustible().toString()
}

object scoreEstado{
	method position() = game.at(13,6)
	method text() = "ESTADO: " + player.estado().toString()
}

class Mensaje{
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