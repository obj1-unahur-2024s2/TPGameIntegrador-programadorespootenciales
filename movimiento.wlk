import wollok.game.*

object movimiento {

	method configurarFlechas(visual){
		keyboard.up().onPressDo {
			self.mover(arriba,visual)
		}
		keyboard.down().onPressDo { 
			self.mover(abajo,visual)
		}
		keyboard.left().onPressDo{
			self.mover(izquierda,visual)
            game.schedule(500, {self.mover(izquierda,visual)})
            game.schedule(500, {self.mover(izquierda,visual)})
		}
		keyboard.right().onPressDo{ 
			self.mover(derecha,visual)
            game.schedule(500, {self.mover(derecha,visual)})
            game.schedule(500, {self.mover(derecha,visual)})
		}
   }
	method cambiarPersonajeSegunDireccion(unPersonaje, unaDireccion){
		const imagen = imagenNueva.imagenSegunDireccion(unaDireccion)
		unPersonaje.cambiarImagen(imagen)
		
	}
	method mover(direccion,personaje){
		const nuevaPosicion = direccion.siguiente(personaje.position())
		if (nuevaPosicion.x() >= 1 && nuevaPosicion.x() < game.width() - 1 &&
				nuevaPosicion.y() >= 1 && nuevaPosicion.y() < game.height() - 1){
					self.cambiarPersonajeSegunDireccion(personaje, direccion)
					personaje.position(nuevaPosicion)
				}

		
	}

	method moverobjetos(direccion,personaje){
		const nuevaPosicion = direccion.siguiente(personaje.position())
		if (nuevaPosicion.x() >= 1 && nuevaPosicion.x() < game.width() - 1 &&
				nuevaPosicion.y() >= 0 && nuevaPosicion.y() < game.height() - 1)
		personaje.position(nuevaPosicion)
        if (nuevaPosicion.y() == 0) game.schedule(1000, {game.removeVisual(personaje)})
	}
}

object izquierda { 
	method siguiente(position) = position.left(1)
}

object derecha { 
	method siguiente(position) = position.right(1) 
}

object abajo { 
	method siguiente(position) = position.down(1) 
}

object arriba { 
	method siguiente(position) = position.up(1) 
}

object imagenNueva{
	method imagenSegunDireccion(unaDireccion){
		var imagen = "player.png"
		if (unaDireccion == izquierda){
			imagen = "autosRojoConPersonajesSinFondoALaIzquierda.png"
		}
		else if (unaDireccion == derecha){
			imagen = "autosRojoConPersonajesSinFondoALaDerecha.png"
		}
		else if (unaDireccion == arriba){
			imagen = "autosRojoConPersonajesSinFondoArriba.png"
		}
		else {imagen = "autosRojoConPersonajesSinFondoAbajo.png"}
		return imagen
	}
}