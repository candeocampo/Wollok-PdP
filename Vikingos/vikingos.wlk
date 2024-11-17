/*
Punto 1: expedicion.subir(vikingo)
Punto 2: expedicion.valeLaPena()
Punto 3: expedicion.realizar()
Punto 5: vikingo.escalarSocialmente()

*/



class Vikingo{

    var property casta = jarl 
    var property oro = 0

    method esProductivo()

    method puedeSubir(expedicion) = self.esProductivo() && casta.puedeSubir(self,expedicion)
    

    method cobrarVida()

    //Punto 3
    method ganar(monedas){
        oro += monedas
    }

    // Punto 5
    method escalar(){
        casta.escalar(self)
    }

    method ascender(){ //si es soldado o no se ascicente
        casta.ascender(self)
    }

    method bonificarAscenso()

}

// clases sociales
class Casta{ // es una clase porque tenemos diferentes clases
    method puedeSubir(vikingo,expedicion) = true

    method escalar(vikingo)

}

object jarl inherits Casta{ // es un objeto pues el jarl es único

    override method puedeSubir(vikingo,expedicion) = !vikingo.armas() //no tiene armas

    override method escalar(vikingo){
        vikingo.casta(karl) // ascience
        vikingo.bonoficarAscenso()
    }

}


object karl inherits Casta{

    override method escalar(vikingo){
        vikingo.casta(thrall)
    }
}

object thrall inherits Casta{
    override method escalar(vikingo){
        //no hace nada porque es el max del ascenso
    }
}

// TIPOS DE VIKINGOS

class Soldado inherits Vikingo{
    var property vidasCobradas
    var armas 

    override method esProductivo() = self.vidasCobradas() > 20 && self.tieneArmas()
    
    method tieneArmas() = armas > 0 // UN BOOL USAS  = 

    override method bonificarAscenso(){
        armas +=10 // gana 10 armas si es soldado.
    }



}


class Granjero inherits Vikingo{
    var cantHijos
    var hectareas


    override method esProductivo() = hectareas *2 >= cantHijos

    override method bonificarAscenso(){
        cantHijos +=2
        hectareas +=2
    }


}

class Expedicion{
    var property integrantes = []
    var objetivos

    //punto 1
    method subir(vikingo){
        if(!vikingo.puedeSubir(self)){
            self.error("No puede subir a la expedicion")
        }else{
            integrantes.add(vikingo)
        }
    }

    // punto 2
    method valeLaPena() = objetivos.all{obj => obj.valeLaPenaPara(self.cantidadIntegrantes())}

    method cantidadIntegrantes() = integrantes.size()

    // punto 3
    method realizar(){
        objetivos.forEach{obj => obj.serInvadidoPor(self)}
    }

    method aumentarVidasCobradas(cantidad){
        integrantes.take(cantidad).forEach{vikingo => vikingo.cobrarVida()}
    }

    method repartirBotin(botin){
        integrantes.forEach{p => p.ganar(botin/self.cantidadIntegrantes())}
    }

}

class LugarInvadido{

    method botin(cantInvasores)

    method valeLaPenaPara(cantInvasores)

    method serInvadidoPor(expendicion){
    }


}

class Capital inherits LugarInvadido{
    var property defensores
    var property riqueza

    override method botin(cantInvasores) = self.defensoresDerrotados(cantInvasores) * riqueza

    override method valeLaPenaPara(cantInvasores) = cantInvasores < self.botin(cantInvasores) / 3


    method defensoresDerrotados(cantInvasores) = defensores.min(cantInvasores)

    override method serInvadidoPor(expedicion) = 
        expedicion.aumentarVidasCobradas(self.defensoresDerrotados(expedicion.cantidadIntegrantes()))

}

class Aldea inherits LugarInvadido{
    var property crucifijos

    override method botin(cantInvadores) = crucifijos
    override method valeLaPenaPara(cantInvasores) = self.botin(cantInvasores) >=15

 
}

class AldeaAmurallada inherits Aldea{
    var minimoVikingos

    override method valeLaPenaPara(cantInvasores) = super(cantInvasores) && cantInvasores >= minimoVikingos

}




































