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
		const duracion = 25000
	
	    game.addVisualCharacter(player)
		self.agregarTablero()
		self.agregarAutoCada(velocidadNivel)
		self.actulizarDistanciaPorRecorrerSegunVelocidadCada(tiempo)
		game.schedule(duracion, {self.informarResultado()})
	}

	method informarResultado() {
		if (distanciaNivel == 0 && player.estado() > 0 && player.combustible() > 0)	self.resultado(mensajeGanaste)  else {self.resultado(mensajeTiempoAgotado)}
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
		game.onTick(unTiempo, "agrego", {self.agregoElemento([new Auto1(), new Auto2(), new Auto3(), new Auto4()].anyOne())})
	}

	method actulizarDistanciaPorRecorrerSegunVelocidadCada(unTiempo){
		game.onTick(unTiempo, "tiempo", {
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

	method resultado(unMensaje) {
		game.addVisual(unMensaje)
		game.onTick(2500, "quitar", {self.quitar(unMensaje)})
	}
	method quitar(unMensaje){
		game.removeVisual(unMensaje)
		game.stop()
	}
	method cantidadDeAutosChocados() = if (self.autosChocado().isEmpty()) 0 else self.autosChocado().size()

}
object paleta {
	const property verde = "00FF00FF"
	const property rojo = "FF0000FF"
	const property azul = "0000FFFF"
	const property blanco = "FFFFFFFF"

}
class Score{
	method textColor() = paleta.blanco()
	method text()
	method position() = game.at(13, 9)
}
class ScoreVelocidad inherits Score{
	override method text() = "VELOCIDAD: " + player.velocidad().toString()
}

class ScoreDistancia inherits Score{
	override method position() = super().down(1)
	override method text() = "DISTANCIA: " + nivel.distancia().toString()
}

class ScoreCombustible inherits Score{
	override method position() = super().down(2)
	override method text() = "COMBUSTIBLE: " + player.combustible().toString()
}

class ScoreEstado inherits Score{
	override method position() = super().down(3)
	override method text() = "ESTADO: " + player.estado().toString()
}
class ScoreColisiones inherits Score{
	override method position() = super().down(4)
	override method text() = "COLISIONES: " + nivel.cantidadDeAutosChocados().toString()
}

class Mensaje{
   method textColor() = paleta.azul()
   method position() = game.center()
   method text()
   method serImpactado(unAuto) {}
}
object mensajePerdiste inherits Mensaje{
	override method text() = "LO SIENTO!! VOLVÉ A INTENTARLO"
	override method textColor() = paleta.rojo()
}
object mensajeTiempoAgotado inherits Mensaje{
	override method text() = "Tiempo agotado, perdiste!"
}

object mensajeGanaste inherits Mensaje{
	override method text() = "FELICITACIONES!! SUPERASTE EL NIVEL"
	override method textColor() = paleta.verde()
}

object mensajeFin inherits Mensaje{
	override method text() = "JUEGO FINALIZADO"
	override method textColor() = paleta.blanco()
}
object inicio {
	var image = "presentacion.png"
	var position = game.origin()
	method position() = position
	method image() = image
}

