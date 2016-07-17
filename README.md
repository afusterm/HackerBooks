# Práctica de fundamentos iOS

## Procesado del JSON

Para convertir el objeto JSON a un array de Dictionary o a un dictionary he usado los operadores *is* y *as* para comprobar si era un array y convertirlo es un array respectivamente.

```
var jsonBooks: JSONArray?
if maybeArray is JSONArray {
    jsonBooks = maybeArray as? JSONArray
} else if let dict = maybeArray as? JSONDictionary {
    jsonBooks = [dict]
}
```
No utilicé *isKindOfClass* ya que los tipos que creé para los diccionarios y los arrays de diccionarios no tenían el método *isKindOfClass* al no derivar de NSObject.

## Modelo

Las imágenes de portada y los pdf los guardaría en el directorio de caché, aunque finalmente no he podido implementar la caché de imágenes y pdf.

## Tabla de libros

Para la gestión de favoritos he usado una etiqueta *favoritos* como nos indicaste. Y para persistir el estado de favoritos he guardado en el fichero *favorites.plist* los títulos de los libros que eran favoritos. Al inicio de la ejecución se carga el fichero y se obtiene un array de cadenas con los títulos que se pasa al constructor de AGTLibrary para que añada los libros a la etiqueta *favorites*.

Cuando se modifica la propiedad *favorite* de un objeto *AGTBook*, éste avisa a AGTLibrary mediante una notifiación y *AGTLibrary* lo añade o lo elimina de la etiqueta *favorites* y avisa a su delegado (la *AGTLibraryTableViewController*) para que actualice las vistas.

Para la actualización de la table he llamado a *reloadData*. Este método solo carga las celdas que son visibles, por lo que no penaliza el rendimiento. Creo que es aconsejable usarlo una vez se hayan modificado los datos, y no en cada una de las modificaciones, inserciones o borrados, ya que entonces se harían muchas llamadas y podría penalizar el rendimiento.

