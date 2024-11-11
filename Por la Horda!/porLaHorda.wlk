
class Personaje {
    
    const property fuerza 
    const property inteligencia // son constante  
    var property rol // definimos un atributo Rol
    // el property es un setter, me permite cambiarlo desde afuera

    method potencialOfensivo() = 10 * fuerza + rol.potencialOfensivoExtra()

    method esGroso() = self.esInteligente() || rol.esGroso(self)
        //"self" se manda msj a si mismo       
        // self.esGrosoParaSuRol() es igual a  = rol.esGroso(self) -> esto tmb lo podiamos haber puesto así en vez de "self.esGrosoParaSuRol()"

    method esInteligente()

    // method esGrosoParaSuRol() = rol.esGroso(self) // con el self le pasamos el propio rol como parametro
}

class Humano inherits Personaje {

    override method esInteligente() = inteligencia > 50
    // pisamos el método principal
}

class Orco inherits Personaje { 

    override method esInteligente() = false

    override method potencialOfensivo() = super() * 1.1
    // con override pisamos el metodo de personaje
// En el caso particular de los orcos, producto de su brutalidad innata, su potencial ofensivo es
// un 10% más


}

//PUNTO 2) ROLES

object guerrero {
    method potencialOfestivoExtra() = 100

    method esGroso(personaje) = personaje.fuerza() > 50
}

object brujo {
    method potencialOfestivoExtra() = 0
    method esGroso(personaje) = true
}

class Cazador {
    var mascota 
    method potencialOfestivoExtra() = mascota.potencialOfensivo()
    
    method esGroso(personaje) = mascota.esLongeva()

}

class Mascota{
    const fuerza
    const edad
    const tieneGarras

    method potencialOfesivo() =
        if(tieneGarras) fuerza * 2
        else fuerza

    method esLongeva() = edad > 10

}

// new Orco = new Cazador(mascota=...)
// const pirulo = new Orco ( rol = new Cazador(mascota=...))


//No hace falta que hagamos una clase de roles porque sus logicas son diferentes.
//Para que sean polimorfimos solamente basta con que entienden el msj de potencialOfensivoExtra

// const pirulo = new Orco(rol=brujo) instanciamos un orco con su rol
// pirulo.rol(guerrero) acá le cambiamos el rol


// PUNTO 3) ZONAS

class Ejercito{

    const property miembros = [] //lista de personajes

    method potencialOfensivo() = miembros.sum{personaje => personaje.potencialOfensivo()}

    method invadir(zona){
        if(zona.potencialDefensivo() < self.potencialOfensivo()){
            zona.SeOcupadaPor(self) //la zona es ocupada por mi; por eso el self.
        }


    }

    
}

class Zona{

    var habitantes // esto va a ser del ejercito

    method potencialDefensivo() = habitantes.potencialOfensivo()

    method seOcupaPor(ejercito){
        habitantes = ejercito // los habitantes se pisan con el ejercito invasor.
    }
}

class Ciudad inherits Zona{

    override method potencialDefensivo() = super() * 300

}

class Aldea inherits Zona{
    const maxHabitantes = 50 // las aldeas tienen un maximo de ocupación

    override method seOcupaPor(ejercito){ // en este método cambiamos el ejercito que llega
        if(ejercito.miembros().size() > maxHabitantes){ // si el ejercito tiene más miembros de los que puedo soportar
            // si el ejercito es grande lo partimos
            const nuevosHabitantes = 
            ejercito.miembros().sortedBy{uno,otro => uno.potencialOfensivo() > otro.potencialOfensivo()}.take(10)
                                // los ordenamos por el potencial ofensivo y tomamos 10 nomás
            super(new Ejercito(miembros = nuevosHabitantes)) // llamamos a super con esos nuevos habitante; pasamos una LISTA!
            ejercito.miembros().removeAll(nuevosHabitantes) // con esto sacamos los miembros del ejercito y pasan a ser los habitante
        
        }else super(ejercito) // acá no pasa nada
    }

}





