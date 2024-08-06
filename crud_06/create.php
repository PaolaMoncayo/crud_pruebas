<?php
// Encabezados CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// Configuración de la base de datos
$servername = "192.168.100.13";
$username = "root";
$password = "";
$dbname = "db_productos_06";

// Crear conexión
$connec = new mysqli($servername, $username, $password, $dbname);

// Verificar conexión
if ($connec->connect_error) {
    die("Conexión fallida: " . $connec->connect_error);
}

// Leer datos JSON enviados en el cuerpo de la petición
$data = json_decode(file_get_contents("php://input"), true);

// Validar datos
if (empty($data['nombre_producto']) || empty($data['precio_producto'])) {
    echo json_encode(['mensaje' => 'Error', 'error' => 'Datos incompletos']);
    $connec->close();
    exit();
}

$nombre_producto = $connec->real_escape_string($data['nombre_producto']);
$precio_producto = $connec->real_escape_string($data['precio_producto']);

// Preparar y ejecutar la consulta SQL
$sql = "INSERT INTO tb_productos_06 (nombre_producto, precio_producto) VALUES ('$nombre_producto', '$precio_producto')";

if ($connec->query($sql) === TRUE) {
    echo json_encode(['mensaje' => 'Exito']);
} else {
    echo json_encode(['mensaje' => 'Error', 'error' => $connec->error]);
}

// Cerrar conexión
$connec->close();
?>
