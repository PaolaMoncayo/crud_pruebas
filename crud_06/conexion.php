<?php
/*$connect = new mysqli('localhost', 'root', '', 'db_productos_06');
$query = mysqli_query($connect, "SELECT * FROM db_productos_06");
$data = mysqli_fetch_all($query, MYSQLI_ASSOC);

echo json_encode($data);*/

//1. ENZABEZADO CORS
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$servername = "192.168.100.13";
$username = "root";
$password = "";
$dbname = "db_productos_06";

$connect = new mysqli($servername, $username, $password, $dbname);

//2. VERIFICAR CONEXION

if ($connect->connect_error) {
    die("Conexion no valida: " . $connect->connect_error);
}


//3. CONSULTA A LA BASE DE DATOS
$query = "SELECT * FROM tb_productos_06";
$result = $connect->query($query);


//4. PROCESAMIENTO DE RESULTADOS
$data=[];
if ($result->num_rows > 0) {
    $data = $result->fetch_all(MYSQLI_ASSOC);
} 


//5. CODIFICACION DE LOS DATOS EN JSON
echo json_encode($data);

//6. CIERRE DE CONEXION
$connect->close();

?>