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
   var nivel = 1
   var distanciaNivel = 2000
   var velocidadNivel = 2000
   var activo = true
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
		const duracion = 30000
	
	    game.addVisualCharacter(player)

		self.agregarTablero()
		self.agregarAutoCada(velocidadNivel)
		self.actualizarDistanciaPorRecorrerSegunVelocidadCada(tiempo)
		game.schedule(duracion, {self.informarResultado()})
	}

	method informarResultado() {
		if (activo){self.resultado(mensajeTiempoAgotado) self.fin()}
		elementos.forEach({auto => self.borrarElemento(auto)})
		activo = true
	}

	method finNivel(){
		activo = false
		elementos.forEach({auto => self.borrarElemento(auto)})
		if (nivel == 1) {
			self.iniciarNivel2()
		}
		else {
			self.fin()
		}
	}
	method distancia() = distanciaNivel

	method iniciarNivel2() {
		const duracion = 30000
		nivel = 2
		game.schedule(1500, {self.resultado(mensajeNivel)})
		game.schedule(1500,{
		distanciaNivel = 2500
		velocidadNivel = 1500
		player.combustible(40)
		})
		game.schedule(duracion, {self.informarResultado()})
	}

	method agregarTablero(){
		game.addVisual(new ScoreVelocidad())
		game.addVisual(new ScoreDistancia())
		game.addVisual(new ScoreCombustible())
		game.addVisual(new ScoreEstado())
		game.addVisual(new ScoreColisiones())
	}

	method fin(){
		game.stop()
	}
	
	method agregarAutoCada(unTiempo){
		game.onTick(unTiempo, "agrego", {self.agregoElemento([new Auto1(), new Auto2(), new Auto3(), new Auto4()].anyOne())})
	}

	method actualizarDistanciaPorRecorrerSegunVelocidadCada(unTiempo){
		game.onTick(unTiempo, "tiempo", {self.validacion()})
	}

	method validacion(){
		if (activo) {
      		distanciaNivel = 0.max(distanciaNivel - player.velocidad())
			player.llegasteALaMeta()}
	}

	method actualizoVelocidades(unaVelocidad){
		game.schedule(1000, {elementos.forEach({auto => auto.cambioVelocidad(unaVelocidad)})})
	}
	method actualizoVelocidadDe(unaVelocidad, unAuto){
		unAuto.cambioVelocidad(unaVelocidad)
	}

	method resultado(unMensaje) {
		game.addVisual(unMensaje)
		game.schedule(1500, {self.quitar(unMensaje)})
	}
	method quitar(unMensaje){
		game.removeVisual(unMensaje)
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

object mensajeNivel inherits Mensaje{
	override method text() = "COMIENZA NIVEL 2"
	override method textColor() = paleta.blanco()
}
object inicio {
	var image = "presentacion.png"
	var position = game.origin()
	method position() = position
	method image() = image
}

