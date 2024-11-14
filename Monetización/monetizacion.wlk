
class Contenido{ // es una clase abstracta
    const property titulo
    var property cantVistas = 0
    var property contenidoOfensivo = false
    var property monetizacion 

    method recaudacion() = monetizacion.recaudacionDe(self)

    method esPopular() // método abstracto

    method recaudacionMaximaParaPublicidad()

    method puedeVenderse() = self.esPopular() // autodelegacion de si es popular y con eso se fija si es video o imagen

    //la monetización se usa al momento de la recaudacion
    method monetizacion(nuevaMonetizacion){
        if(!nuevaMonetizacion.puedeAplicarseA(self))
            throw new DomainException(message = "El contenido no soporta la forma de monetizacion")
        monetizacion = nuevaMonetizacion
    }

    method initialize(){
        if(!monetizacion.puedeAplicarseA(self))
            throw new DomainException(message = "El contenido no soporta la forma de monetizacion")

    }
    
    method puedeAlquilarse()

}

// el contenido DELEGA la MONETIZACION

// por "var property monetizacion" usaremos composición porque distintos contenidos van a obtar por cambiar
// su estrategia de monetización por lo que se va a redireccionar la variable
// si lo hicieramos por herencia no podriamos cambiar lo que cada contenido elige como estrategia

class Video inherits Contenido{

    override method esPopular() = cantVistas > 100000

    override method recaudacionMaximaParaPublicidad() = 10000

    override method puedeAlquilarse() = true

}

const tagsDeModa = ["objetos","pdp","serPeladoHoy"]

class Imagen inherits Contenido{
    const property tags = []

    override method esPopular() = tagsDeModa.all{tag => tags.contais(tag)}
    // para c/u de los tagsDeModa yo espero que mis tags lo incluyan

    override method recaudacionMaximaParaPublicidad() = 4000

    override method puedeAlquilarse() = false
}


// MONETIZACIONES

object publicidad{ // es un object porque acá no hay que manejar los estados internos

    method recaudacionDe(contenido) = 
    (0.05 * contenido.cantVistas() + if(contenido.esPopular()) 2000 else 0).min(contenido.recaudacionMaximaParaPublidad())

    // estamos delegando esPopular y recaudacionMaxParaPublicidad en contenido
    // porque si el contenido es un video es una cosa pasa algo y si es una imagen pasa otra

    method puedeAplicarse(contenido) = !contenido.ofensivo()


}

class Donacion{
    var property donaciones = 0

    method recaudacionDe(contenido) = donaciones

    method puedeAplicarse(contenido) = true
}

class Descarga{
    const property precio

    /*
    method initialize(){
        if(precio < 5)
            throw new DomainException("No, error barato")
    }
    */

    method recaudacionDe(contenido) = contenido.cantVistas() * precio

    method puedeAplicarse(contenido) = contenido.puedeVenderse()
}

class Alquiler inherits Descarga{

    override method precio() = 1.max(super()) // 1 es el min y max es el comportamos que heredamos con super

    override method puedeAplicarse(contenido) = super(contenido) && contenido.puedeAlquilarse()
                    // con el puedeAlquilarse verificaremos que tipo de contenido es

}



// Punto 2)  Hacer que el sistema permita realizar las siguientes consultas:
// a. Saldo total de un usuario, que es la suma total de lo recaudado por todos sus
// contenidos.

// b. Email de los 100 usuarios verificados con mayor saldo total.
// Podemos crear una variable usuarios y hacemos consultas sobre eso pero NO nos beneficia esto
// const usuarios = [new Usuario(),...]
// nos conviene hacer un objeto que nos sirve para consultas que refieren a TODOS los usuarios

object usuarios{
    const todosLosUsuarios = []

    method emailsDeUsuariosRicos() = 
    todosLosUsuarios.filter{usuario => usuario.verificado()}
    .sortedBy{uno,otro => uno.saldoTotal() > otro.saldoTotal()}
    .take(100)
    .map{usuario=>usuario.email()}

    method cantSuperUsuarios() = todosLosUsuarios.count{usuario => usuario.esSuperUsuario()}
    // le delege usuario.esSuperUsuario()

}

// c. Cantidad de super-usuarios en el sistema (usuarios que tienen al menos 10
// contenidos populares publicados).

class Usuario{
    const property nombre
    const property email
    var property verificado = false
    const contenidos = []

    //2.a
    method saltoTotal() = contenidos.sum{contenido => contenido.recaudacion()}

    method esSuperUsuario() = contenidos.count{contenido => contenido.esPopular()} >= 10

    // parte del 3
    method publicar(contenido){
        contenidos.add(contenido)
        
        //if(monetizacion.puedeAplicarse(contenido)) //acaba debemos ver donde delegamos
            //throw new DomainException(message = "El contenido no soporta la forma de monetizacion")
        
        /* contenidos.add(contenido) // agregamos el contenido
        contenido.monetizacion(monetizacion) // lo asociamos a la monetizacion
        */
    }
}
// Punto 3)
// Permitir que un usuario publique un nuevo contenido, asociándolo a una forma de
// monetización.
// osea debemos asegurar que el contenido puede ir con esa forma de monetizacion



// Punto 4)
// Aparece un nuevo tipo de estrategia de monetización: El Alquiler. Esta estrategia es
// muy similar a la venta de descargas, pero los archivos se autodestruyen después de
// un tiempo. Los alquileres tienen un precio mínimo de $1.00 y, además de tener todas
// las restricciones de las ventas, los alquileres sólo pueden aplicarse a videos

//_---------------
// PUNTO TEORICO //
// -------------
// Punto 5)
//a. ¿Cuáles de los siguientes requerimientos te parece que sería el más fácil y
// cuál el más difícil de implementar en la solución que modelaste? Responder
// relacionando cada caso con conceptos del paradigma.

// i. Agregar un nuevo tipo de contenido.
// No sería tan díficil ya que al utilizar herencia podriamos crear una nueva clase que herede los atributos y metodos de la clase madre

// ii. Permitir cambiar el tipo de un contenido (e.j.: convertir un video a
// imagen).

// Como lo estamos haciendo con herencia sería más complicado, seguramente necesitaria cambiar el codigo y con composición
// y agregar un "contrato" que diga "tipoDeContenido" que sería un atributo más en Contenido
// podriamos pensarlo como hicimos con monetización

// iii. Agregar un nuevo estado “verificación fallida” a los usuarios, que no
// les permita cargar ningún nuevo contenido.

// Los usuarios tenian un atributo bool de verificado y lo usabamos en el metodo publicar
// nos convendria tener un objeto para delegar "estado de validacion" y tuvieramos objetos de "validado" "sinvalidar" "validacionFallida"
// y con un metodo que utilice el metodo puedePublicar


// b. ¿En qué parte de tu solución se está aprovechando más el uso de
// polimorfismo? ¿Por qué?

// lo usamos en saldoTotal porque el usuario trata indiferente a los contenidos que tiene
// otro es en la recaudación 












