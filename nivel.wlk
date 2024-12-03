import wollok.game.*
import player.*
import autos.*

object juego {
	const music1 = game.sound("music.mp3")

	method iniciar(){		
		game.title("Autos")
		game.height(10)
		game.width(15)
	}
	method pausarJuego(){
		keyboard.space().onPressDo({self.detenerMusica(music1) game.stop() game.addVisual(mensajeFin)})
	}
	method reiniciarJuego(){
		keyboard.r().onPressDo({ self.restart() })
	}
	method detenerMusica(unaMusica){
	   unaMusica.volume(0)
       unaMusica.stop()
	}
	method bajarMusica(unaMusica){
		keyboard.minusKey().onPressDo({unaMusica.volume(0.5)})
	}
	method subirMusica(unaMusica){
		keyboard.plusKey().onPressDo({unaMusica.volume(1)})
	}
	
	method iniciarJuego(){
		player.configurarFlechas()
		self.pausarJuego()
		nivel.iniciarNivel1()
		music1.shouldLoop(true)
		game.schedule(500, { music1.play()})
	}
	method restart() {
		game.clear()
		self.iniciarJuego()
	}

}
object nivel {
   var nivel = 1
   var distanciaNivel = 0
   var velocidadNivel = 2000
   var property duracion = 0
   var property tiempoRestante = 1
   const property elementos = []
   var property nivelActivo = false
   var ganoNivel = false

   method agregoElemento(unElemento) {
		elementos.add(unElemento)
		game.addVisual(unElemento)
   }

   method mostrarAutoChocado(unAuto) {
		game.addVisual(unAuto)
   }

   method borrarElemento(unElemento) {
	
		elementos.remove(unElemento)
	    game.removeVisual(unElemento)
   }

   method iniciarNivel1(){
		duracion = 30000
		distanciaNivel = 2000
        velocidadNivel = 2000
		tiempoRestante = duracion / 1000
		player.combustible(45)
	
	    game.addVisualCharacter(player)
		self.agregarTablero()
		nivelActivo = true
		game.onCollideDo(player, { unAuto => player.serImpactado(unAuto) });
		self.agregarAutoCada(4500)
		self.actualizarDatosCada()
	}

	method finNivel(){
		if (nivel == 1 and ganoNivel) {
			ganoNivel = false
			self.iniciarNivel2()
		}
		else {
			self.fin()
		}
	}
	method distancia() = distanciaNivel

	method iniciarNivel2() {
		duracion = 30000
		tiempoRestante = duracion / 1000
		nivel = 2
		game.schedule(1500, {self.resultado(mensajeNivel, nivel2)
		game.schedule(1500,{
		distanciaNivel = 2500
		velocidadNivel = 1500
		player.combustible(60)
		nivelActivo = true
		game.addVisual(player)
		})
		})
	}

	
	
	method agregarTablero(){
		game.addVisual(new ScoreVelocidad())
		game.addVisual(new ScoreDistancia())
		game.addVisual(new ScoreCombustible())
		game.addVisual(new ScoreEstado())
		game.addVisual(new ScoreColisiones())
		game.addVisual(new TiempoRestante())
	}

	method fin(){
		game.stop()
	}
	
	method agregarAutoCada(unTiempo){
		self.nuevoAuto(new Auto1())
		game.schedule(unTiempo,{self.nuevoAuto(new Auto2())
		game.schedule(unTiempo,{self.nuevoAuto(new Auto3())
		game.schedule(unTiempo,{self.nuevoAuto(new Auto4())})})})
	}

	method nuevoAuto(unAuto){
		self.agregoElemento(unAuto)
	}

	method actualizarDatosCada(){
		game.onTick(1000, "tiempo2", {self.validacion()})
	}

	method validacion(){
		if (nivelActivo) {
      		distanciaNivel = 0.max(distanciaNivel - player.velocidad())
			tiempoRestante=0.max(tiempoRestante-1)
			player.gastaCombustible()
			
		if (player.combustibleEnCero()){
		    nivelActivo = false
			self.resultado(mensajePerdiste, gameOver) 
			self.finNivel()
		}

		if (distanciaNivel == 0){
		    nivelActivo = false
			game.removeVisual(player)
			self.resultado(mensajeGanaste,ganaste)
			ganoNivel = true
			self.finNivel()
		}

		if(tiempoRestante==0){
		    nivelActivo = false
			self.resultado(mensajeTiempoAgotado, gameOver) 
			self.finNivel()
		}
		}
	}

	method resultado(unMensaje, unaImagen) {
		game.addVisual(unaImagen)
		//game.addVisual(unMensaje)
		game.schedule(1500, {self.quitar(unaImagen)})
	}
	method quitar(unMensaje){
		game.removeVisual(unMensaje)
	}

}
object gameOver{
	var image = "gameOver.png"
	var position = game.center()
	method position() = position
	method image() = image
}
object ganaste{
	var image = "ganasteImagen.png"
	var position = game.center()
	method position() = position
	method image() = image
}

object nivel2{
	var image = "nivel2.png"
	var position = game.center()
	method position() = position
	method image() = image
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


class ScoreCombustible inherits Score{
	override method position() = super().down(1)
	override method text() = "COMBUSTIBLE: " + player.combustible().toString()
}

class ScoreEstado inherits Score{
	override method position() = super().down(2)
	override method text() = "ESTADO: " + player.estado().toString()
}
class ScoreColisiones inherits Score{
	override method position() = super().down(3)
	override method text() = "COLISIONES: " + player.colisiones().toString()
}

class TiempoRestante inherits Score{
	override method position() = game.at(1, 9)
	override method text() = "TIEMPO: " + nivel.tiempoRestante().toString()
}


class ScoreDistancia inherits Score{
	override method position() = game.at(1, 8)
	override method text() = "DISTANCIA: " + nivel.distancia().toString()
}

class Mensaje{
   method textColor() = paleta.azul()
   method position() = game.center()
   method text()
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

