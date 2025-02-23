Lo siguiente es una aplicacion de compra y venta usando Flutter. 
Deberia tener Iniciar Sesion, Registro, Autenticación basica, almacenamiento de datos local, entre otras cosas. 
Todo en menos de una semana.

Solo se realizo la version para Android.

Para esto se decidio usar una Arquitectura limpia, 
debido a que tengo mas experiencia trabajando con dicha Arquitectura y a la final, 
funcionaria para escalar y expandir dicho proyecto en el futuro.

La base de datos utilizado fue SQFlite, trabajada de manera relacional. Existe metodos para manejar debugging dentro de la aplicacion como inicializar usuarios y productos.

El archivo CSV se genera en la carpeta de "Android/data/com.example.pos/files/" de decidio dejar esta ubicación debido a que no habia una espeficicación para donde guardar el archivo.
(Diria que hubiera sido mejor en la carpeta de Documentos o Descargas, pero por el momento se dejo alli.)

No existe test_cases para Unit Testing/Integration Testing, etc.

Esta completado, Hay algunas cosas que me gustaria refactoriar como el manejo de la base de datos, 
debido a que este no sigue los principios SOLID pero para algunos dias de trabajo, Estoy satisfecho de como quedo.


