<?php
require_once("global.php");
require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';
require 'PHPMailer/src/Exception.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=utf-8");

// Leer JSON
$data = json_decode(file_get_contents("php://input"), true);

if (!$data || !isset($data["correo"])) {
    echo json_encode(["status" => "error", "mensaje" => "Correo no recibido"]);
    exit;
}

$correo = $data["correo"];

// Verificar si el correo existe
$check = $conn->prepare("SELECT registro, nombre FROM lector WHERE correo = ?");
$check->bind_param("s", $correo);
$check->execute();
$check->store_result();

if ($check->num_rows == 0) {
    echo json_encode(["status" => "error", "mensaje" => "El correo no está registrado"]);
    exit;
}

$check->bind_result($registro, $nombre);
$check->fetch();
$check->close();

// Generar código de recuperación (6 bytes hex = 12 caracteres)
$codigo = bin2hex(random_bytes(6));
$hash = hash("sha256", $codigo);  // almacenar hash, no el token puro

// Insertar en la tabla de recuperación
$stmt = $conn->prepare("
    INSERT INTO recuperacion_password (lector_registro, token, expira)
    VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 15 MINUTE))
");
$stmt->bind_param("is", $registro, $hash);
$stmt->execute();
$stmt->close();

// Enviar correo
$mail = new PHPMailer(true);

try {
    $mail->CharSet = 'UTF-8';
    $mail->Encoding = 'base64';
    $mail->isSMTP();
    $mail->Host       = 'mail.elbservicios.com.bo';
    $mail->SMTPAuth   = true;
    $mail->Username   = 'soporte@elbservicios.com.bo';
    $mail->Password   = 'Proyectoscelular2025+*';
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
    $mail->Port       = 465;

    $mail->setFrom('soporte@elbservicios.com.bo', 'Sistema IoT Riego');
    $mail->addAddress($correo, $nombre);

    $mail->isHTML(true);
    $mail->Subject = 'Código de recuperación de acceso';
    $mail->Body = "
        <h3>Hola $nombre</h3>
        <p>Tu código para recuperar tu contraseña es:</p>
        <h2>$codigo</h2>
        <p>Es válido por 15 minutos.</p>
    ";

    $mail->send();

    echo json_encode(["status" => "ok", "mensaje" => "Se envió un código a su correo"]);
    exit;

} catch (Exception $e) {
    echo json_encode(["status" => "error", "mensaje" => "Error al enviar correo"]);
    exit;
}

?>
