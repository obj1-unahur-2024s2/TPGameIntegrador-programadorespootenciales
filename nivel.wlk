import wollok.game.*
import player.*
import autos.*

object juego {
	method iniciar(){		
		game.title("Autos")
		game.height(10)
		game.width(15)
		game.boardGround("fondo.png")
		player.configurarFlechas()
		self.pausarJuego()
		self.iniciarJuego()
	}
	method pausarJuego(){
		keyboard.space().onPressDo({game.stop() game.addVisual(mensajeFin)})
	}
	method iniciarJuego(){
		game.addVisual(inicio)
		keyboard.enter().onPressDo({game.removeVisual(inicio) nivel.configurate()})
		game.start()
	}

}
object nivel {
   var distanciaNivel = 2000
   const velocidadNivel = 2000
   const tiempo = 1000
   const property elementos = []
   const property autosChocado = []

   method agregoElemento(unElemento) {
		elementos.add(unElemento)
		game.addVisual(unElemento)
   }
   method mostrarAutoChocado(unAuto) {
		autosChocado.add(unAuto)
		game.addVisual(unAuto)
   }

   method borrarElemento(unElemento) {
		elementos.remove(unElemento)
   }

   method configurate(){
		const ancho = game.width() 
		const largo = game.height()
		const duracion = 2000
	
    //	VISUALES
	    game.addVisualCharacter(player)
		self.agregarTablero()
		self.agregarAutoCada(velocidadNivel)
		self.actulizarDistanciaPorRecorrerSegunVelocidadCada(tiempo)
		game.schedule(duracion, {self.informarResultado()})
	}

	method informarResultado() {
		if (distanciaNivel == 0 && player.estado() > 0 && player.combustible() > 0)	self.ganaste() else {self.perdisteTiempoAgotado()}
	}
	method distancia() = distanciaNivel

	method agregarTablero(){
		game.addVisual(new ScoreVelocidad())
		game.addVisual(new ScoreDistancia())
		game.addVisual(new ScoreCombustible())
		game.addVisual(new ScoreEstado())
		game.addVisual(new ScoreColisiones())
	}
	method agregarAutoCada(unTiempo){
		game.onTick(tiempo, "agrego", {self.agregoElemento([new Auto1(), new Auto2(), new Auto3(), new Auto4()].anyOne())})
	}

	method actulizarDistanciaPorRecorrerSegunVelocidadCada(unTiempo){
		game.onTick(tiempo, "tiempo", {
			player.llegasteALaMeta()
			distanciaNivel = 0.max(distanciaNivel - player.velocidad())
		})
	}

	method actualizoVelocidades(unaVelocidad){
		game.schedule(1000, {elementos.forEach({auto => auto.cambioVelocidad(unaVelocidad)})})
	}
	method actualizoVelocidadDe(unaVelocidad, unAuto){
		unAuto.cambioVelocidad(unaVelocidad)
	}
	
	method ganaste(){
		game.addVisual(mensajeGanaste)
		game.stop()
    }

	method perdiste(){
	    game.addVisual(mensajePerdiste)
		game.stop()
    }
	method perdisteTiempoAgotado() = mensajeTiempoAgotado
	method cantidadDeAutosChocados() = if (self.autosChocado().isEmpty()) 0 else self.autosChocado().size()

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
class ScoreColisiones inherits Score{
	method position() = game.at(13,5)
	override method text() = "Colisiones: " + nivel.cantidadDeAutosChocados().toString()
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
object mensajeTiempoAgotado inherits Mensaje{
	override method text() = "Tiempo agotado, perdiste! VOLVÉ A INTENTARLO"
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

