import wollok.game.*
import nivel.*


 object gameManager {
   const height = 10 // en celdas
   const width = 15 // en celdas
   const property musicIntro = game.sound("intro.mp3")
   
   method inicializar() {

      game.height(height)
      game.width(width)
      game.boardGround("fondo2.gif")
      game.title("CrazyCar")
      
   }
   
   method mostrarMenu() {
      self.configurarTeclasVolumen()
      if(self.musicIntro().volume() == 0){self.musicIntro().volume(0.5)}
      game.onTick(500, "musicaDeIntro", {self.musicaIntro()})
      game.addVisual(home)
      keyboard.enter().onPressDo {  
         self.detenerMusica(musicIntro)
         self.ocultarMenu()        
         juego.iniciarJuego()     
      }      
   }

   method configurarTeclasVolumen(){
         keyboard.b().onPressDo{
            musicIntro.volume(0)
         }
         keyboard.s().onPressDo{
            musicIntro.volume(1)
         }
   }
   method musicaIntro(){    
      self.reproducirMusica(self.musicIntro())
   }

   method reproducirMusica(unaMusica){
      
		unaMusica.shouldLoop(true)
		game.schedule(500, { unaMusica.play() })
	}
   method detenerMusica(unaMusica){
	   unaMusica.volume(0)
      unaMusica.stop()
	}
   method ocultarMenu() {
      if (game.hasVisual(home))
         game.removeVisual(home)
   }
   method restart() {
      self.limpiarEscenario()    
      self.inicializar()
      self.mostrarMenu() 
      game.start()        
	}
   method limpiarEscenario(){
      const musica = juego.music1()
      game.clear() 

      self.detenerMusica(musica)
   }
 }

object home {
   const property image = "fondoPortadaFinal.png"
   const property position = game.at(0, 0)
}
