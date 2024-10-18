import wollok.game.*
import fondo.*
import player.*
import movimiento.*
import autos.*
object nivel {

method configurate(){
	//	CONFIG	
		game.title("Autos")
		game.height(10)
		game.width(15)
		game.boardGround("ground.png")
		

	 	movimiento.configurarFlechas(player)
		
	//	ARBUSTOS
		const ancho = game.width() 
		const largo = game.height() 
	
		(3..11).forEach({a=> (0 .. largo).forEach { n => new Camino_liso(position = new Position(x =a, y = n)).dibujar() }}) // ruta
        (0 .. largo).forEach { n => new Camino_izquierdo(position = new Position(x =5, y = n)).dibujar() } // bordeIzq 
		(0 .. largo).forEach { n => new Camino_derecho(position = new Position(x =9, y = n)).dibujar() } // bordeDer
		
        
    //	VISUALES
	 	game.addVisualCharacter(player)
        game.addVisual(auto1)
        game.onTick(1000, "movimiento",{ movimiento.moverobjetos(abajo,auto1) })
	//	TECLADO

		
		//keyboard.space().onPressDo{ game.say(granjero, "mi oro: " + granjero.oro()) }  
	}

}