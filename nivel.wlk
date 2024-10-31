import wollok.game.*
import fondo.*
import player.*
import autos.*

object juego {
	method iniciar(){		
		game.title("Autos")
		//game.cellSize(80)
		game.height(10)
		game.width(15)
		game.boardGround("ground.png")
		player.configurarFlechas()
		nivel.configurate()
		game.start()
	}	
}
object nivel {
   var distanciaNivel = 500
   var velocidadNivel = 2000
   const elementos = []

   method agregoElemento(unElemento) {
	elementos.add(unElemento)
	game.addVisual(unElemento)
	unElemento.inicioMovimiento()
   }

   method borrarElemento(unElemento) {
	elementos.remove(unElemento)
   }

   method configurate(){
	//	ARBUSTOS
		const ancho = game.width() 
		const largo = game.height() 
	
		(3..11).forEach({a=> (0 .. largo).forEach { n => new Camino_liso(position = new Position(x =a, y = n)).dibujar() }}) // ruta
        (0 .. largo).forEach { n => new Camino_izquierdo(position = new Position(x =5, y = n)).dibujar() } // bordeIzq 
		(0 .. largo).forEach { n => new Camino_derecho(position = new Position(x =9, y = n)).dibujar() } // bordeDer
		

    //	VISUALES
	    game.addVisualCharacter(player)
		game.addVisual(scoreVelocidad)
		game.addVisual(scoreDistancia)
		game.addVisual(scoreCombustible)
		game.addVisual(scoreEstado)

        game.onTick(velocidadNivel, "agrego", {self.agregoElemento([new Auto1(), new Auto2()].anyOne())})

		//game.onTick(player.velocidadRelativa(), "movimiento1", {self.moverObjetos()})
		game.onTick(1000, "tiempo", {
			player.gastaCombustible()
			player.validarEstado()
			distanciaNivel = 0.max(distanciaNivel - player.velocidad())
			if (distanciaNivel ==0){
				game.addVisual(mensajeGanaste)
				game.stop()
			}
		})

	}

	//method moverObjetos(){
    //   elementos.forEach({e=>e.desplazarse() })
	//}

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
}
object mensajePerdiste inherits Mensaje{
	override method text() = "LO SIENTO!! VOLVÉ A INTENTARLO"
}

object mensajeGanaste inherits Mensaje{
	override method text() = "FELICITACIONES!! SUPERASTE EL NIVEL"
}