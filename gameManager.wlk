import wollok.game.*
import nivel.*

 object gameManager {
   //const cellsize = 30 // pixeles
   const height = 10 // en celdas
   const width = 15 // en celdas
   const musicIntro = game.sound("intro.mp3")
   
   method inicializar() {
      //game.cellSize(cellsize)
      game.height(height)
      game.width(width)
      game.boardGround("fondo2.gif")
      game.title("CrazyCar")
      self.musicaIntro()
   }
   
   method mostrarMenu() {
      //game.clear()
      //if (!game.hasVisual(home)) 
      game.addVisual(home)
      keyboard.enter().onPressDo {  
      self.ocultarMenu()        
      juego.detenerMusica(musicIntro)
      juego.iniciarJuego()      }      
   }

   method musicaIntro(){
      musicIntro.play()
   }
   
   method ocultarMenu() {
      if (game.hasVisual(home))
         game.removeVisual(home)
   }
   
 }

object home {
   const property image = "fondoPortadaFinal.png"
   const property position = game.at(0, 0)
}
