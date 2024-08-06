<?php
// Encabezados CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, DELETE, OPTIONS");
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
    die(json_encode(['mensaje' => 'Error', 'error' => 'Conexión fallida: ' . $connec->connect_error]));
}

// Obtener datos del POST
$id_producto = isset($_POST['id_producto']) ? $connec->real_escape_string($_POST['id_producto']) : '';

// Validar datos
if (empty($id_producto)) {
    echo json_encode(['mensaje' => 'Error', 'error' => 'ID del producto no proporcionado']);
    $connec->close();
    exit();
}

// Preparar y ejecutar la consulta SQL
$sql = "DELETE FROM tb_productos_06 WHERE id_producto = '$id_producto'";

if ($connec->query($sql) === TRUE) {
    echo json_encode(['mensaje' => 'Éxito', 'resultado' => 'Producto eliminado']);
} else {
    echo json_encode(['mensaje' => 'Error', 'error' => $connec->error]);
}

// Cerrar conexión
$connec->close();
?>
