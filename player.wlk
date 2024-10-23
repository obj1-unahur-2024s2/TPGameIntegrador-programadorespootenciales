import wollok.game.*

object player {
	var image = "player.png"
	var property position = new Position(x = 7, y = 1)

	method image() = image
	method cambiarImagen(imagenNueva){ image  = imagenNueva }
	
}
//player.cambiarImagen("autosRojoConPersonajesSinFondoALaIzquierda.png")
//player.image()